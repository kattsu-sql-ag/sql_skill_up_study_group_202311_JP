①数量、重量の数値が表せない場合は「-」と表示してほしい。​
  , COALESCE(
        CAST(ROUND(thm.hanbai_suryo,0) AS VARCHAR)
    ,'-')                                         AS "販売数量"
  , COALESCE(
        CAST(ROUND(thm.hanbai_juryo_kg,0) AS VARCHAR)
    ,'-')                                         AS "販売重量（ｋｇ）"
  , COALESCE(
        CAST(ROUND(tnb.nebiki_kingaku,0) AS VARCHAR)
    ,'-')                                         AS "値引金額"

②状態が不明な場合は「※要確認」と表示してほしい。ただしダミー品目は「-」と表示してほしい。​
  , CASE WHEN thm.hinmoku_cd = '999' THEN '-'                                    -- 調整用ダミーの場合は'-'
         ELSE COALESCE(mes.end_status_name,'※要確認') 
    END                                           AS "状態"

③販売金額は販売当時の単価で算出しているが、出力時点の単価で算出した金額を追加で表示してほしい。​
  , CASE
        WHEN thm.hanbai_suryo IS NOT NULL THEN
            mhi.tanka_pc * thm.hanbai_suryo
        WHEN thm.hanbai_juryo_kg IS NOT NULL THEN
            mhi.tanka_kg * thm.hanbai_juryo_kg
        ELSE 0
    END                                           AS "販売金額＿現在単価"

④値引後の販売金額を表示してほしい。販売当時と出力時点の両方の値引金額が必要。​
  , CASE
        WHEN thm.hanbai_suryo IS NOT NULL THEN
            thm.hanbai_kingaku - COALESCE(tnb.nebiki_kingaku,0)
        WHEN thm.hanbai_juryo_kg IS NOT NULL THEN
            thm.hanbai_kingaku - COALESCE(tnb.nebiki_kingaku,0)
        ELSE 0
    END                                           AS "販売金額＿値引後＿販売当時"
  , CASE
        WHEN thm.hanbai_suryo IS NOT NULL THEN
            (mhi.tanka_pc * thm.hanbai_suryo) - COALESCE(tnb.nebiki_kingaku,0)
        WHEN thm.hanbai_juryo_kg IS NOT NULL THEN
            (mhi.tanka_kg * thm.hanbai_juryo_kg) - COALESCE(tnb.nebiki_kingaku,0)
        ELSE 0
    END                                           AS "販売金額＿値引後＿現在単価"

⑤値引金額の入力は正の数で実施するが、誤って負の数が入力される場合がある。
  , COALESCE(
        CAST(ABS(ROUND(tnb.nebiki_kingaku,0)) AS VARCHAR)
    ,'-')                                         AS "値引金額"

  , CASE
        WHEN thm.hanbai_suryo IS NOT NULL THEN
            thm.hanbai_kingaku - ABS(COALESCE(tnb.nebiki_kingaku,0))
        WHEN thm.hanbai_juryo_kg IS NOT NULL THEN
            thm.hanbai_kingaku - ABS(COALESCE(tnb.nebiki_kingaku,0))
        ELSE 0
    END                                           AS "販売金額＿値引後＿販売当時"

  , CASE
        WHEN thm.hanbai_suryo IS NOT NULL THEN
            (mhi.tanka_pc * thm.hanbai_suryo) - ABS(COALESCE(tnb.nebiki_kingaku,0))
        WHEN thm.hanbai_juryo_kg IS NOT NULL THEN
            (mhi.tanka_kg * thm.hanbai_juryo_kg) - ABS(COALESCE(tnb.nebiki_kingaku,0))
        ELSE 0
    END                                           AS "販売金額＿値引後＿現在単価"
