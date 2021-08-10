library(dplyr)
c("https://www.mhlw.go.jp/content/") -> mhlwurl
c("https://ckan.open-governmentdata.org/dataset/") -> ckanurl
ckanurl %>% paste("401005_kitakyushu_covid19_test_count/",sep="") -> cktqurl
ckanurl %>% paste("401000_pref_fukuoka_covid19_exam/",sep="") -> pfukurl
