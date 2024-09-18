
use 能成功数据, clear

xtset id year 
*1
ppmlhdfe Y DID X1 X2 X3 X4 X5
est store m01
	esttab  m01 , nogap compress s(N r2_a F) ///
		   b(%6.3f) star(* 0.1 **  0.05 *** 0.01) t(%6.3f) ///
		 
		   
esttab  m01  using 1.csv, nogap compress s(N r2_a F) ///
		   b(%6.3f) star(* 0.1 **  0.05 *** 0.01) t(%6.3f) ///

