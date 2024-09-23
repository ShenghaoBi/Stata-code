
use data, clear

xtset id year 
*1
set seed 10101
qui bsqreg  Y did ,reps(100) q(0.5)
grqreg, ci ols olsci












		   
