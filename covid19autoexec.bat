@rem "C:\Program Files\R\R-4.0.5\bin\rscript.exe" CreateData.R
"C:\Program Files\R\R-4.1.1\bin\rscript.exe" CreateData410.R
cd C:\Users\holy1\Documents\R\covid-19data\data
set A=Improved 
set B=%date%
set C="%A%%B%"
git add .
git commit -a -m %C%
git push --all origin