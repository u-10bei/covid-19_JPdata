# ライブラリの読み込み
 library(readr)
 library(dplyr)

# 全国データ
# オープンデータのあるＵＲＬを変数に格納
c("https://www3.nhk.or.jp/n-data/opendata/coronavirus/") -> NHKURL

# ネット上のファイル読み込み
NHKURL |> paste("nhk_news_covid19_prefectures_daily_data.csv",sep="") |>
  read_csv() -> NHKP
# 人口データの読込（同一リポジトリ内）
c("data/Population_Pref_20191001.csv") |>
  read_csv(col_names=TRUE,locale(encoding="UTF-8")) -> POP

# 列名の再定義
c("Date","PrefCode","Pref",
  "Positive","Pos.cumulative","Deaths","Deaths.cumulative") -> colnames(NHKP)

# データの整形
as.Date(NHKP$Date) -> NHKP$Date
NHKP |> filter(NHKP$Date >  last(NHKP$Date)-7) |>
  group_by(Pref) |>
  summarise(Pos=sum(Positive)) -> NHKT




# 全国データの書き出し
JPdata.all |> subset(Pref==c("ALL")) |>
  write_csv("./data/COVID-19_JP.csv","")

# 各県の状況の書き出し
JPdata.all |> subset(Pref!=c("ALL")) |>
  select(Date,Pref,Positive,Inpatient,Discharged,Unconfirmed) |>
  write_csv("./data/COVID-19_PREF.csv","")

# 北九州データ
# オープンデータのあるＵＲＬを変数に格納
c("https://ckan.open-governmentdata.org/dataset/") -> ktqURL

# ネット上のファイル読み込み
ktqURL |> paste("bdb93937-3522-4c54-bf99-1ff24f51eb9d/",sep="") |>
  paste("resource/f9bbb2bd-cb82-4395-8d7a-18566784c2bc/",sep="") |>
  paste("download/401005_kitakyushu_covid19_test_count.csv",sep="") |>
  read_csv(col_names=TRUE,locale=locale(encoding="SHIFT-JIS")) -> ktqT
ktqURL |> paste("550f889f-f758-41e5-83c0-2e631d41af06/",sep="") |>
  paste("resource/888afc2d-61ba-4f62-8494-c8022fcd8548/",sep="") |>
  paste("download/401005_kitakyushu_covid19_confirm_negative.csv",sep="") |>
  read_csv(col_names=TRUE,locale=locale(encoding="SHIFT-JIS")) -> ktqN

# 列名の再定義
c("Date","code","Pref","City","Tested") -> colnames(ktqT)
c("Date","code","Pref","City","Negative") -> colnames(ktqN)

# ＣＳＶの結合と陽性者数の作成、書き出し
ktqT |> inner_join(ktqN,by="Date") |>
  select(Date,Tested,Negative) |>
  mutate(Positive=Tested-Negative) |>
  mutate(Prate=Positive/Tested*100) |>
  write_csv("./data/COVID-19_KTQ.csv","")
