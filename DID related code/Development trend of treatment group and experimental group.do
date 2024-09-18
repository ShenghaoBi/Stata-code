
use 能成功数据, clear


graph set window fontface "Times New Roman"
graph set window fontfacesans "宋体" // 设置图形输出的字体
egen mean_y=mean(Y), by(year treat)
graph twoway (connect mean_y year if treat==1,sort)        ///
(connect mean_y year if treat==0,sort lpattern(dash)), ///
 xline(2011,lpattern(dash) lcolor(gray))  
///
ytitle("Y", ///
orientation(h)) xtitle("Yearear") ///
ylabel(0(0.5)10,labsize(*0.75)  format(%02.1f)) xlabel(,labsize(*0.75))   ///
legend(label(1 "{stSans:处理组}") label( 2 "{stSans:控制组}")) ///图例
xlabel(2007 (1) 2019)  graphregion(color(white)) //白底

		   
