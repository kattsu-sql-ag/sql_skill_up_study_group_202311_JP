/*組織一覧*/
SELECT
    mso.soshiki_cd                           AS "組織コード"
  , mso.soshiki_name                         AS "組織名称"
  , mso.joi_soshiki_cd                       AS "上位組織コード"
  , msj.soshiki_name                         AS "組織名称"
FROM m_soshiki mso                                                    -- 組織マスタ
LEFT OUTER JOIN 
    m_soshiki msj                                                     -- 組織マスタ（上位組織取得用）
    ON mso.joi_soshiki_cd = msj.soshiki_cd                            -- 上位組織コード=組織コード
WHERE
    1=1
ORDER BY
    mso.soshiki_cd                                                    -- 組織コード
;
