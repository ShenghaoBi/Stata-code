
use 能成功数据, clear

xtset id year 

ssc install ddml,all replace
ssc install lassopack,all replace
ssc install rforest,all replace
ssc install pystacked,all replace
python:pip install scikit-learn 
set python_exec /Users/bishenghao/anaconda3/bin/python  //路径用终端搜where is python
global Y  人均绿色申请 
*global X Edu	Constru	Urban	Pass	Fre	Inv	Inter	Fis	Unemp	Size	Consump	Sci	Cap i.year i.id
global X i.id i.year  Constru	Urban	Pass	Fre	Inv	Inter	Fis	Unemp	Size	Consump	Sci	Cap
global D DID

ddml init partial, kfolds(6)
ddml E[D|X]: pystacked $D $X, type(reg) method(lassocv)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(lassocv)
ddml crossfit
ddml estimate, robust

est store m09

esttab  m09, nogap compress s(N r2_a F) ///
		   b(%6.3f) star(* 0.1 **  0.05 *** 0.01) t(%6.3f) ///
esttab   m09 using 1.csv, nogap compress s(N r2_a F) ///
		   b(%6.3f) star(* 0.1 **  0.05 *** 0.01) t(%6.3f) ///










		   
