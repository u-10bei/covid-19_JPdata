"C:\Program Files\R\R-4.1.1\bin\rscript.exe" CreateNHK.R
cd C:\Users\holy1\Documents\R\covid-19_JPdata
set A=Improved 
set B=%date%
set C="%A%%B%"
git add .
git commit -a -m %C%
git push --all origin