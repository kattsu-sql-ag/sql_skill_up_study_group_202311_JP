/*組織マスタ*/
SELECT * FROM m_soshiki ORDER BY soshiki_cd ;
/*顧客マスタ*/
SELECT * FROM m_kokyaku ORDER BY kokyaku_cd;
/*終売ステータスマスタ*/
SELECT * FROM m_end_status ORDER BY end_status_cd;
/*カテゴリマスタ*/
SELECT * FROM m_category ORDER BY category_cd;
/*業態マスタ*/
SELECT * FROM m_gyotai ORDER BY gyotai_cd;
/*品目マスタ*/
SELECT * FROM m_hinmoku ORDER BY hinmoku_cd;
/*販売明細*/
SELECT * FROM t_hanbai_meisai ORDER BY denpyo_no;
/*値引明細*/
SELECT * FROM t_nebiki_meisai ORDER BY denpyo_no;