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
NHKP = pd.read_csv(NHKurl)

# 人口データの読込（同一リポジトリ内）
POP = pd.read_csv(popurl,thousands=',')[['Pref','Population']]

# 列名の再定義
NHKP.set_axis(['Date','PrefCode','Pref','Positive','Pos.cumulative',
  'Deaths','Deaths.cumulative','Pos.per100K'], axis=1, inplace=True)

# データの整形
NHKP['Date'] = pd.to_datetime(NHKP['Date'])

from datetime import date,timedelta
last7 = NHKP['Date'].max()-timedelta(days=7)
NHKP7 = NHKP[NHKP['Date'] > last7]
NHKP7['Date2'] = NHKP7['Date'].dt.strftime('%Y-%m-%d')

NHKT = NHKP7[['Pref','Positive']].groupby('Pref').agg('sum') \
  .rename(columns={'Positive': 'Pos7'})
NHKPP = NHKP7.pivot(index='Pref', columns='Date2', values='Positive') \
  .reset_index()

NHKN = NHKP[NHKP['Date'] == NHKP['Date'].max()][['Pref','Positive']] \
  .rename(columns={'Positive': 'Pos'})

# データの結合
NHKT1 = NHKT.merge(NHKN,on='Pref',how='inner') \
  .merge(POP,on='Pref',how='inner')
NHKT1['per100K7']=NHKT1['Pos7']/(NHKT1['Population']/100000)
NHKT1['per100K']=NHKT1['Pos']/(NHKT1['Population']/100000)
NHKTT = pd.merge(NHKT1, NHKPP, on='Pref',how='inner') \
  .sort_values('per100K7', ascending=False)

# 各県の状況の書き出し
NHKTT.to_csv('../data/COVID-19_NHK.csv',index=False)
NHKTT.to_csv(cred.HP_URL+'/COVID-19_NHK.csv',index=False)