@rem "C:\Program Files\R\R-4.0.5\bin\rscript.exe" CreateData.R
"C:\Program Files\R\R-4.1.2\bin\rscript.exe" CreateData410.R
cd C:\Users\holy1\Documents\R\covid-19_JPdata
set A=Improved 
set B=%date%
set C="%A%%B%"
git add .
git commit -a -m %C%
git push --all origin
cd .\data
copy /y COVID-19_JP.csv C:\Users\holy1\Documents\R\u-10bei.github.io\datas
copy /y COVID-19_KTQ.csv C:\Users\holy1\Documents\R\u-10bei.github.io\datas
copy /y COVID-19_PREF.csv C:\Users\holy1\Documents\R\u-10bei.github.io\datas
cd C:\Users\holy1\Documents\R\u-10bei.github.io
set A=copy 
set B=%date%
set C="%A%%B%"
git add .
git commit -a -m %C%
git push --all origin
