

*安慰剂检验
*安慰剂绘图(500次)
use 能成功数据, clear
permute did beta = _b[did],  ///
          reps(500) saving("simulations500.dta"):  ///
         reg Y   did X1 X2 X3
		 
use "simulations500.dta", clear
#delimit ;
dpplot beta, xline( -0.006  , lc(black*0.5) lp(dash))
             xline(0, lc(black*0.5) lp(solid))
             xtitle("回归参数", size(*0.8)) 
             xlabel(-0.008(0.001)0.008, format(%4.1f) labsize(small))
             ytitle("概率密度", size(*0.8)) 
             ylabel(, nogrid format(%4.1f) labsize(small)) 
             note("") caption("") 
             graphregion(fcolor(white)) ;
#delimit cr



		   














		   
