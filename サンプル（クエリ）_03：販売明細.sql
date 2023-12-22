/*販売明細（レポート出力用）*/
/*販売明細トランザクションに各種マスタを結合する*/
/*組織一覧*/
WITH vso AS (
    SELECT
          mso.soshiki_cd                                                         -- 組織コード
        , mso.soshiki_name                                                       -- 組織名称
        , COALESCE(mso.joi_soshiki_cd,mso.soshiki_cd) AS joi_soshiki_cd          -- 上位組織コード
        , COALESCE(msj.soshiki_name,mso.soshiki_name) AS joi_soshiki_name        -- 上位組織名称
    FROM m_soshiki mso                                                           -- 組織マスタ
    LEFT OUTER JOIN 
        m_soshiki msj                                                            -- 組織マスタ（上位組織取得用）
    ON mso.joi_soshiki_cd = msj.soshiki_cd                                       -- 上位組織コード=組織コード
)
/*顧客マスタ*/
, mkk AS (
    SELECT
          kokyaku_cd                                                             -- 顧客コード
        , kokyaku_name                                                           -- 顧客名称
    FROM m_kokyaku
)
/*品目マスタ*/
, mhi AS (
    SELECT 
          hinmoku_cd                                                             -- 品目コード
        , hinmoku_name                                                           -- 品目名称
        , kikaku                                                                 -- 規格
        , category_cd                                                            -- カテゴリコード
        , gyotai_cd                                                              -- 業態コード
        , tanka_pc                                                               -- 単価（１個）
        , tanka_kg                                                               -- 単価（１ｋｇ）
        , end_status_cd                                                          -- 終売ステータスコード
    FROM m_hinmoku                                                               -- 品目マスタ
)
/*終売ステータスマスタ*/
, mes AS (
    SELECT
          end_status_cd                                                          -- 終売ステータスコード
        , end_status_name                                                        -- 終売ステータス名称
    FROM m_end_status
)
/*値引明細*/
, tnb AS (
    SELECT
          denpyo_no                                                              -- 伝票番号
        , nebiki_kingaku                                                         -- 値引金額
    FROM t_nebiki_meisai
)
SELECT
    thm.denpyo_no                                 AS "伝票番号"
  , thm.hanbai_date                               AS "販売日"
  , thm.soshiki_cd                                AS "組織コード"
  , vso.soshiki_name                              AS "組織名称"
  , vso.joi_soshiki_cd                            AS "上位組織コード"
  , vso.joi_soshiki_name                          AS "上位組織名称"
  , thm.kokyaku_cd                                AS "顧客コード"
  , mkk.kokyaku_name                              AS "顧客名称"
  , thm.hinmoku_cd                                AS "品目コード"
  , CONCAT(
        CONCAT(mhi.hinmoku_name,'：')
    ,mhi.kikaku)                                  AS "流通用商品名称"
  , mes.end_status_name                           AS "状態"
  , thm.hanbai_kingaku                            AS "販売金額＿当時"
  , thm.hanbai_suryo                              AS "販売数量"
  , thm.hanbai_juryo_kg                           AS "販売重量（ｋｇ）"
  , tnb.nebiki_kingaku                            AS "値引金額"
FROM t_hanbai_meisai thm                                                         -- 販売明細
/*組織、顧客、品目はマスタ登録が保証されている前提で内部結合とする*/
/*内部パターン１：内部結合の代表INNER JOIN*/
INNER JOIN
    vso                                                                          -- 組織一覧
    ON thm.soshiki_cd = vso.soshiki_cd                                           -- 組織コード
/*内部パターン２：INNERを省略し、USINGを使ってみる*/
JOIN 
    mkk                                                                          -- 顧客マスタ
    USING(kokyaku_cd)                                                            -- 顧客コード
/*内部パターン３：取り扱い注意！自然結合NATURAL JOIN*/
NATURAL JOIN 
    mhi                                                                          -- 品目マスタ
/*終売ステータスはマスタ登録が保証されていない前提で外部結合とする*/
/*外部パターン１：みんな大好き左外部結合LEFT*/
LEFT OUTER JOIN
    mes                                                                          -- 終売ステータスマスタ
    ON mhi.end_status_cd = mes.end_status_cd                                     -- 終売ステータスコード
/*値引は発生しない場合の方が多いので、外部結合とする*/
/*外部パターン２：完全外部結合FULL（ざっくり言うとLEFT+RIGHT）*/
/*もしイレギュラーで値引しかない伝票が発生した場合に検知することが可能
（識別にはSELECTを工夫する必要あり）*/
FULL OUTER JOIN
    tnb                                                                          -- 伝票番号
    USING(denpyo_no) /*敢えてUSINGを使ってみる*/                                  -- 値引金額
WHERE
    1=1  
ORDER BY
    thm.denpyo_no                                                                -- 伝票番号
;
