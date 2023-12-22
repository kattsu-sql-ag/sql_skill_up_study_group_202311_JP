/*サンプル：菓子販売業者の販売管理システム*/
/*組織マスタ*/
CREATE TABLE m_soshiki (
    soshiki_cd CHAR(2) NOT NULL PRIMARY KEY                 -- 組織コード
  , soshiki_name VARCHAR(30)                                -- 組織名称
  , joi_soshiki_cd CHAR(2) REFERENCES m_soshiki(soshiki_cd) -- 上位組織コード
);
INSERT INTO m_soshiki
VALUES ('11','仙台支店','94')
      ,('12','新宿本店','94')
      ,('13','名古屋支店','94')
      ,('14','梅田支店','94')
      ,('15','博多支店','94')
      ,('91','経営企画室',NULL)
      ,('92','人事総務部',NULL)
      ,('93','財務経理部',NULL)
      ,('94','営業部',NULL)
      ,('95','情報システム部',NULL);
/*顧客マスタ*/
CREATE TABLE m_kokyaku (
    kokyaku_cd CHAR(4) NOT NULL PRIMARY KEY -- 顧客コード
  , kokyaku_name VARCHAR(30)                -- 顧客名称
);
INSERT INTO m_kokyaku
VALUES ('1001','株式会社いつもすこやか〇〇〇〇フードマート')
      ,('1002','株式会社みんなで健康△△△△ドラッグ')
      ,('1003','（株）安さで勝負してます□□□□ストア')
      ,('1004','（株）うちは小売もやってるよ××××卸センター')
      ,('9999','※調整用ダミー');
/*終売ステータスマスタ*/
CREATE TABLE m_end_status (
    end_status_cd CHAR(1) NOT NULL PRIMARY KEY -- 終売ステータスコード
  , end_status_name VARCHAR(30)                -- 終売ステータス名称
);
INSERT INTO m_end_status
VALUES ('0','販売中')
      ,('1','終売予定（生産中）')
      ,('2','終売予定（生産終了）')
      ,('3','販売終了');
/*カテゴリマスタ*/
CREATE TABLE m_category (
    category_cd CHAR(1) NOT NULL PRIMARY KEY -- カテゴリコード
  , category_name VARCHAR(30)                -- カテゴリ名称
);
INSERT INTO m_category
VALUES ('a','ケーキ')
      ,('b','クッキー')
      ,('c','チョコレート')
      ,('d','キャンディ');
/*業態マスタ*/
CREATE TABLE m_gyotai (
    gyotai_cd CHAR(1) NOT NULL PRIMARY KEY -- 業態コード
  , gyotai_name VARCHAR(30)                -- 業態名称
);
INSERT INTO m_gyotai
VALUES ('1','家庭用')
      ,('2','業務用');
/*品目マスタ*/
CREATE TABLE m_hinmoku (
    hinmoku_cd CHAR(3) NOT NULL PRIMARY KEY                      -- 品目コード
  , hinmoku_name VARCHAR(30)                                     -- 品目名称
  , kikaku VARCHAR(30)                                           -- 規格
  , category_cd CHAR(1) REFERENCES m_category(category_cd)       -- カテゴリコード
  , gyotai_cd CHAR(1) REFERENCES m_gyotai(gyotai_cd)             -- 業態コード
  , tanka_pc NUMERIC(19,3)                                       -- 単価（１個）
  , tanka_kg NUMERIC(19,3)                                       -- 単価（１ｋｇ）
  , end_status_cd CHAR(1) REFERENCES m_end_status(end_status_cd) -- 終売ステータスコード
);
INSERT INTO m_hinmoku
VALUES ('001','イチゴショート','ホール','a','1',2000,0,'0')
      ,('002','ガトーショコラ','ハーフ','a','1',1200,0,'0')
      ,('003','レモンレアチーズ','１Ｐ','a','1',480,0,'1')
      ,('004','シュガーバターサブレ','３００ｇ','b','1',400,0,'0')
      ,('005','豆乳きなこ黒ゴマクッキー','２枚','b','1',220,0,'2')
      ,('006','オレンジスパイスブレッド','１箱','b','1',1700,0,'0')
      ,('007','スイートミルク','８５ｇ×５','c','1',800,0,'1')
      ,('008','カシス＆ダーク','７０ｇ×３','c','1',1100,0,'0')
      ,('009','ハッカミント','５０ｇ','d','1',200,0,'3')
      ,('010','沖縄産天然黒糖くろあめ','３０ｇ','d','1',350,0,'0')
      ,('011','１０種のキャンディ詰合せ','８００ｇ','d','1',1500,0,'0')
      ,('101','業務用冷凍パイシート','縦横３０ｃｍ×１０枚','a','2',0,1000,NULL)
      ,('102','業務用サクサク感マーガリン','','b','2',NULL,650,'0')
      ,('103','業務用製菓向け低糖タイプ',NULL,'c','2',0,480,'2')
      ,('999','※調整用ダミー',NULL,NULL,NULL,NULL,NULL,NULL)
      ;
/*販売明細*/
CREATE TABLE t_hanbai_meisai (
    denpyo_no BIGINT NOT NULL PRIMARY KEY                  -- 伝票番号
  , hanbai_date DATE NOT NULL                              -- 販売日
  , soshiki_cd CHAR(2) NOT NULL                            -- 組織コード
  , kokyaku_cd CHAR(4) NOT NULL                            -- 顧客コード
  , hinmoku_cd CHAR(3) NOT NULL                            -- 品目コード
  , hanbai_kingaku NUMERIC(19,3) NOT NULL DEFAULT 0        -- 販売金額
  , hanbai_suryo NUMERIC(19,3)                             -- 販売数量
  , hanbai_juryo_kg NUMERIC(19,3)                          -- 販売重量（ｋｇ）
);
INSERT INTO t_hanbai_meisai
VALUES (1,'2023-09-01','11','1001','001',105000,58,NULL)
      ,(2,'2023-09-02','11','1003','002',13500,12,NULL)
      ,(3,'2023-09-01','12','1001','001',167000,87,NULL)
      ,(4,'2023-09-02','12','1002','003',69870,154,NULL)
      ,(5,'2023-09-01','13','1002','004',80000,203,NULL)
      ,(6,'2023-09-02','13','1003','005',20000,98,NULL)
      ,(7,'2023-09-01','14','1004','101',870000,NULL,950)
      ,(8,'2023-10-01','11','1001','001',138700,73,NULL)
      ,(9,'2023-10-01','12','1001','002',114000,98,NULL)
      ,(10,'2023-10-02','12','1002','001',246000,130,NULL)
      ,(11,'2023-10-01','13','1002','003',75600,160,NULL)
      ,(12,'2023-10-02','13','1003','102',484000,NULL,760)
      ,(13,'2023-10-01','14','1004','101',80000,NULL,830)
      ,(14,'2023-10-01','93','9999','999',-98000,NULL,NULL)
      ,(15,'2023-11-01','11','1001','001',91000,47,NULL)
      ,(16,'2023-11-02','11','1003','003',61000,130,NULL)
      ,(17,'2023-11-01','12','1001','004',93000,240,NULL)
      ,(18,'2023-11-01','13','1002','005',18700,90,NULL)
      ,(19,'2023-11-01','14','1003','103',409000,NULL,890)
      ,(20,'2023-11-02','14','1004','101',660000,NULL,680)
;
/*値引明細*/
CREATE TABLE t_nebiki_meisai (
    denpyo_no BIGINT NOT NULL PRIMARY KEY REFERENCES t_hanbai_meisai(denpyo_no) -- 伝票番号
  , nebiki_kingaku NUMERIC(19,3) NOT NULL DEFAULT 0                             -- 値引金額
);
INSERT INTO t_nebiki_meisai
VALUES (5,3000)
      ,(8,-2000)
      ,(19,250000)
