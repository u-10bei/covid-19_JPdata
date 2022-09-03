# ライブラリの読み込み
 library(readr)
 library(dplyr)

# 全国データ
# オープンデータのあるＵＲＬを変数に格納
c("https://covid19.mhlw.go.jp/public/opendata/") -> mhlwURL

# ネット上のファイル読み込み
mhlwURL |> paste("newly_confirmed_cases_daily.csv",sep="") |>
  read_csv() -> mhlwCC
mhlwURL |> paste("requiring_inpatient_care_etc_daily.csv",sep="") |>
  read_csv() -> mhlwRR
mhlwURL |> paste("deaths_cumulative_daily.csv",sep="") |>
  read_csv() -> mhlwDD
c("https://www.mhlw.go.jp/content/pcr_tested_daily.csv") |>
  read_csv() -> mhlwT

# 列名の再定義
c("Date","Tested") -> colnames(mhlwT)

# 空のデータフレーム作成
data.frame(matrix(rep(NA,3),nrow=1))[numeric(0),] -> mhlwC
data.frame(matrix(rep(NA,5),nrow=1))[numeric(0),] -> mhlwR
data.frame(matrix(rep(NA,3),nrow=1))[numeric(0),] -> mhlwD

#データ投入
for(i in 2:49){
  data.frame(mhlwCC[,1],names(mhlwCC[,i]),mhlwCC[,i]) -> df
  c("Date","Pref","Positive") -> colnames(df)
  rbind(mhlwC,df) -> mhlwC
  data.frame(mhlwDD[,1],names(mhlwDD[,i]),mhlwDD[,i]) -> df
  c("Date","Pref","Deaths.cumulative") -> colnames(df)
  rbind(mhlwD,df) -> mhlwD
}
for(i in 2:49){
  data.frame(mhlwRR[,1],
             names(mhlwCC[,i]),
             mhlwRR[,i*3-4],
             mhlwRR[,i*3-3],
             mhlwRR[,i*3-2]) -> df
  c("Date","Pref","Inpatient","Discharged","Unconfirmed") -> colnames(df)
  rbind(mhlwR,df) -> mhlwR
}

# データの結合
mhlwC |> left_join(mhlwT,by="Date") |>
  left_join(mhlwR,by=c("Date","Pref")) |>
  left_join(mhlwD,by=c("Date","Pref")) -> JPdata.all

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
  paste("resource/1bbf3ac2-0a3c-4846-a209-95f7d752e90e/",sep="") |>
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
