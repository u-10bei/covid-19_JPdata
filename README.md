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

## Data source<br>（データ取得元）
[**厚生労働省**：https://www.mhlw.go.jp/stf/covid-19/open-data.html](https://www.mhlw.go.jp/stf/covid-19/open-data.html) <br>
[**北九州市**：https://ckan.open-governmentdata.org/organization/kitakyushu-city](https://ckan.open-governmentdata.org/organization/kitakyushu-city)

## Output data<br>（出力データ）
[**National data（全国データ）**：COVID-19_JP.csv](./data/COVID-19_JP.csv)<br>
[**Prefectural data（各県データ）**：COVID-19_PREF.csv](./data/COVID-19_PREF.csv)<br>
[**Kitakyushu City Data（北九州市データ）**：COVID-19_KTQ.csv](./data/COVID-19_KTQ.csv)<br>

## Reference Page<br>（参考ページ）

|Reference site<br>（参考サイト）|Adress<br>（アドレス）|memo<br>（備考）|
|---|---|---|
|Heavy Watal|[readr — 高速で柔軟なテーブル読み込み](https://heavywatal.github.io/rstats/readr.html)|readr|
|Heavy Watal|[dplyr — 高速data.frame処理](https://heavywatal.github.io/rstats/dplyr.html)|dlpyr|