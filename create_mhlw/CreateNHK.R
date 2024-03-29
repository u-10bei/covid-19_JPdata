# ライブラリの読み込み
 library(readr)
 library(dplyr)
 library(tidyr)

# 全国データ
# オープンデータのあるＵＲＬを変数に格納
c("https://www3.nhk.or.jp/n-data/opendata/coronavirus/") -> NHKURL

# ネット上のファイル読み込み
NHKURL |> paste("nhk_news_covid19_prefectures_daily_data.csv",sep="") |>
  read_csv() -> NHKP
# 人口データの読込（同一リポジトリ内）
c("data/FEH_00200521_20201001.csv") |> read_csv() |>
  select(Pref,Population) -> POP

# 列名の再定義
c("Date","PrefCode","Pref","Positive","Pos.cumulative",
  "Deaths","Deaths.cumulative","Pos.per100K") -> colnames(NHKP)

# データの整形
as.Date(NHKP$Date) -> NHKP$Date

NHKP |> filter(NHKP$Date > last(NHKP$Date)-7) |>
  group_by(Pref) |>
  summarise(Pos7=sum(Positive)) -> NHKT
NHKP |> filter(NHKP$Date > last(NHKP$Date)-7) |>
  select(Date,Pref,Positive) |>
  pivot_wider(names_from = "Date",
              values_from = "Positive") -> NHKPP
NHKP |> filter(NHKP$Date == last(NHKP$Date)) |>
  group_by(Pref) |>
  summarise(Pos=sum(Positive)) -> NHKN
NHKT |> inner_join(NHKN,by=c("Pref"="Pref")) |>
  inner_join(POP,by=c("Pref"="Pref")) |>
  mutate(per100K7=Pos7/(Population/100000)) |>
  mutate(per100K=Pos/(Population/100000)) |>
  inner_join(NHKPP,by=c("Pref"="Pref")) -> NHKTT
  NHKTT[order(NHKTT$per100K7,decreasing=T),] -> NHKTT

# 各県の状況の書き出し
NHKTT |> write_csv("data/COVID-19_NHK.csv","")
