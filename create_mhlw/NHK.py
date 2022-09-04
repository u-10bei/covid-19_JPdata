# -*- coding: utf-8 -*-
# カレントディレクトリの設定
from util import credential as cred
import os
os.chdir(cred.CH_DIR)

# 全国データ
# オープンデータのあるＵＲＬを変数に格納
import pandas as pd
NHKurl = 'https://www3.nhk.or.jp/n-data/opendata/coronavirus/' \
  'nhk_news_covid19_prefectures_daily_data.csv'
popurl = '../data/FEH_00200521_20201001.csv'

# ネット上のファイル読み込み
NHKP = pd.read_csv(NHKurl,dtype=str)

# 人口データの読込（同一リポジトリ内）
POP = pd.read_csv(popurl,dtype=str)[['Pref','Population']]

# 列名の再定義
NHKP.set_axis(['Date','PrefCode','Pref','Positive','Pos.cumulative',
  'Deaths','Deaths.cumulative','Pos.per100K'], axis=1, inplace=True)

# データの整形
NHKP['Date'] = pd.to_datetime(NHKP['Date'])

# データフレームを縦持ちに変更
mhlwC = pd.melt(mhlwCC, id_vars='Date',var_name='Pref',value_name='Positive')
mhlwD = pd.melt(mhlwDD, id_vars='Date',var_name='Pref',value_name='Deaths.cumulative')

mhlwR1 = mhlwRR.filter(like='inpatient',axis=1) \
  .reset_index() \
  .melt(id_vars='Date',var_name='Pref',value_name='Inpatient')
mhlwR1['Pref'] = mhlwR1['Pref'].str[1:].str.extract('(.+)\)', expand=True)
mhlwR2 = mhlwRR.filter(like='Discharged',axis=1) \
  .reset_index() \
  .melt(id_vars='Date',var_name='Pref',value_name='Discharged')
mhlwR2['Pref'] = mhlwR2['Pref'].str[1:].str.extract('(.+)\)', expand=True)
mhlwR3 = mhlwRR.filter(like='confirmed',axis=1) \
  .reset_index() \
  .melt(id_vars='Date',var_name='Pref',value_name='Unconfirmed')
mhlwR3['Pref'] = mhlwR3['Pref'].str[1:].str.extract('(.+)\)', expand=True)

# データの結合
JPdata_all = mhlwC.merge(mhlwT,on='Date',how='left') \
  .merge(mhlwR1, on=['Date','Pref'],how='left') \
  .merge(mhlwR2, on=['Date','Pref'],how='left') \
  .merge(mhlwR3, on=['Date','Pref'],how='left') \
  .merge(mhlwD, on=['Date','Pref'],how='left') \
  .fillna('')

# 全国データの書き出し
JPdata_all.query('Pref == "ALL"').to_csv('../data/COVID-19_JP.csv',index=False)
JPdata_all.query('Pref == "ALL"').to_csv(cred.HP_URL+'/COVID-19_JP.csv',index=False)

# 各県の状況の書き出し
JPdata_all[['Date','Pref','Positive','Inpatient','Discharged','Unconfirmed']] \
  .query('Pref != "ALL"').to_csv('../data/COVID-19_PREF.csv',index=False)
JPdata_all[['Date','Pref','Positive','Inpatient','Discharged','Unconfirmed']] \
  .query('Pref != "ALL"').to_csv(cred.HP_URL+'/COVID-19_PREF.csv',index=False)

# 北九州データ
# オープンデータのあるＵＲＬを変数に格納
ktqURL = 'https://ckan.open-governmentdata.org/dataset/'
ktqURL_t = ktqURL + 'bdb93937-3522-4c54-bf99-1ff24f51eb9d/' \
  'resource/1bbf3ac2-0a3c-4846-a209-95f7d752e90e/' \
  'download/401005_kitakyushu_covid19_test_count.csv'
ktqURL_n = ktqURL + '550f889f-f758-41e5-83c0-2e631d41af06/' \
  'resource/888afc2d-61ba-4f62-8494-c8022fcd8548/' \
  'download/401005_kitakyushu_covid19_confirm_negative.csv'

# ネット上のファイル読み込み
ktqT = pd.read_csv(ktqURL_t,encoding="cp932")
ktqN = pd.read_csv(ktqURL_n,encoding="cp932")

# 列名の再定義
ktqT.set_axis(['Date','code','Pref','City','Tested'], axis=1,inplace = True)
ktqN.set_axis(['Date','code','Pref','City','Negative'], axis=1,inplace = True)

# データの結合と陽性者数の作成、書き出し
ktqdata = pd.merge(ktqT,ktqN)[['Date','Tested','Negative']]
ktqdata['Positive']=ktqdata['Tested']-ktqdata['Negative']
ktqdata['Prate']=ktqdata['Positive']/ktqdata['Tested']*100
ktqdata.to_csv('../data/COVID-19_KTQ.csv',index=False)
ktqdata.to_csv(cred.HP_URL+'/COVID-19_KTQ.csv',index=False)