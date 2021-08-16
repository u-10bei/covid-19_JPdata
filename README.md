# covid-19_JPdata
Acquisition of open data from the mhlw.go.jp and city.kitakyushu.jp<br>
Data is updated daily after 11pm.<br>
厚生労働省、北九州市のオープンデータを取得します。<br>
毎日２３時過ぎにデータを更新します。

## CreateData.R and CreateData410.R

|Name<br>（名前）|Version<br>（バージョン）|Library<br>（ライブラリ）|memo<br>（備考）|
|---|---|---|---|
|CreateData.R|4.0.5|tidyverse|pipe %>%|
|CreateData410.R|4.1.0|readr,dplyr|pipe \|>|

## データ取得元<br>
[**厚生労働省**：https://www.mhlw.go.jp/stf/covid-19/open-data.html](https://www.mhlw.go.jp/stf/covid-19/open-data.html) <br>
[**北九州市**：https://ckan.open-governmentdata.org/organization/kitakyushu-city](https://ckan.open-governmentdata.org/organization/kitakyushu-city)

## 出力データ<br>
[**全国データ**：COVID-19_JP.csv](./data/COVID-19_JP.csv)<br>
[**各県データ**：COVID-19_PREF.csv](./data/COVID-19_PREF.csv)<br>
[**北九州市データ**：COVID-19_KTQ.csv](./data/COVID-19_KTQ.csv)<br>
