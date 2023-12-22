/*取扱品目一覧*/
SELECT
    mhi.gyotai_cd || mhi.category_cd || mhi.hinmoku_cd      AS "識別コード"
  , mhi.gyotai_cd || '：' || mgy.gyotai_name                AS "業態"
  , mhi.category_cd || '：' || mct.category_name            AS "カテゴリ"
  , mhi.hinmoku_cd                                          AS "品目コード"
  , mhi.hinmoku_name || '：' || mhi.kikaku                  AS "流通用商品名称"
  , CASE mhi.tanka_pc
        WHEN 0 THEN mhi.tanka_kg
        ELSE mhi.tanka_pc
    END                                                     AS "単価"
  , mhi.end_status_cd || '：' || mes.end_status_name        AS "状態"
FROM m_hinmoku mhi                                                                -- 品目マスタ
LEFT OUTER JOIN 
    m_category mct                                                                -- カテゴリマスタ
    ON mhi.category_cd = mct.category_cd                                          -- カテゴリコード
LEFT OUTER JOIN
    m_gyotai mgy                                                                  -- 業態マスタ
    ON mhi.gyotai_cd = mgy.gyotai_cd                                              -- 業態コード
LEFT OUTER JOIN
    m_end_status mes                                                              -- 終売ステータスマスタ
    ON mhi.end_status_cd = mes.end_status_cd                                      -- 終売ステータスコード
WHERE
    mhi.gyotai_cd = '1'                                                           -- 業態コード
ORDER BY
    "識別コード"
;
