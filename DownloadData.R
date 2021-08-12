#ライブラリインストール（必要に応じて）
#install.packages("tidyverse")

# ライブラリ読み込み
library(tidyverse)

# オープンデータのあるＵＲＬを変数に格納
c("https://covid19.mhlw.go.jp/public/opendata/") -> mhlwURL
c("https://ckan.open-governmentdata.org/dataset/") -> ktqURL

# ネット上のファイル読み込み
mhlwURL %>% paste("newly_confirmed_cases_daily.csv",sep="") %>%
  read_csv() -> mhlwC
mhlwURL %>% paste("requiring_inpatient_care_etc_daily.csv",sep="") %>%
  read_csv() -> mhlwR
mhlwURL %>% paste("deaths_cumulative_daily.csv",sep="") %>%
  read_csv() -> mhlwD
c("https://www.mhlw.go.jp/content/pcr_tested_daily.csv") %>%
  read_csv() -> mhlwT
ktqURL %>% paste("bdb93937-3522-4c54-bf99-1ff24f51eb9d/",sep="") %>%
  paste("resource/f9bbb2bd-cb82-4395-8d7a-18566784c2bc/",sep="") %>%
  paste("download/401005_kitakyushu_covid19_test_count.csv",sep="") %>%
  read_csv(col_names=TRUE,locale=locale(encoding="SHIFT-JIS")) -> ktqT
ktqURL %>% paste("550f889f-f758-41e5-83c0-2e631d41af06/",sep="") %>%
  paste("resource/888afc2d-61ba-4f62-8494-c8022fcd8548/",sep="") %>%
  paste("download/401005_kitakyushu_covid19_confirm_negative.csv",sep="") %>%
  read_csv(col_names=TRUE,locale=locale(encoding="SHIFT-JIS")) -> ktqN
