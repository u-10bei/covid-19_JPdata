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
  read_csv(locale(encoding="UTF-8")) |>
  select(X2,X3) -> POP

# 列名の再定義
c("Date","PrefCode","Pref",
  "Positive","Pos.cumulative","Deaths","Deaths.cumulative") -> colnames(NHKP)
c("Pref","Population") -> colnames(POP)

# データの整形
as.Date(NHKP$Date) -> NHKP$Date
NHKP |> filter(NHKP$Date > last(NHKP$Date)-7) |>
  group_by(Pref) |>
  summarise(Pos7=sum(Positive)) -> NHKT
NHKP |> filter(NHKP$Date == last(NHKP$Date)) |>
  group_by(Pref) |>
  summarise(Pos=sum(Positive)) -> NHKN
NHKT |> inner_join(NHKN,by=c("Pref"="Pref")) |>
  inner_join(POP,by=c("Pref"="Pref")) |>
  mutate(per100K7=Pos7/Population*100) |>
  mutate(per100K=Pos/Population*100)-> NHKTT
  NHKTT[order(NHKTT$per100K7,decreasing=T),] -> NHKTT

# 各県の状況の書き出し
NHKTT |> write_csv("data/COVID-19_NHK.csv","")
