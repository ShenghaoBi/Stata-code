
use 能成功数据, clear


gen tDID= year-treat_date
replace tDID=-4 if tDID<-4
replace tDID=8 if tDID>8
tab tDID,missing
forvalues i=1/4{
	gen d_`i' =0
	replace d_`i' = 1 if treat == 1 & tDID == -`i'
}
forvalues i=0/8{
	gen d`i' =0
	replace d`i' = 1 if treat == 1 & tDID == `i'
}
order  d_4 d_3 d_2 d_1 d0 d1 d2 d3 d4 d5 d6 d7 d8
reghdfe Y  d_4-d_2 d0-d8  X1 X2 X3 X4 X5,absorb(i.year i.id) vce(robust)
gen t=invttail(24,0.05)
forvalues i=2/4{ 
	gen b_`i' = _b[d_`i'] 
	gen se_b_`i' = _se[d_`i']
	gen b_`i'LB = b_`i' - t * se_b_`i'
	gen b_`i'UB = b_`i' + t * se_b_`i'
}
forvalues i=0/8 { 
	gen b`i' = _b[d`i'] 
	gen se_b`i' = _se[d`i']
	gen b`i'LB = b`i' - t * se_b`i'
	gen b`i'UB = b`i' + t * se_b`i'
}
gen b = .
gen LB = .
gen UB = .
forvalues i=2/4 {
	replace b = b_`i'  if tDID == -`i'
}
forvalues i=0/8{
	replace b = b`i'  if tDID == `i'
}
forvalues i=2/4 {
	replace LB = b_`i'LB if tDID == -`i'
}
forvalues i=0/8 {
	replace LB = b`i'LB if tDID == `i'
}
forvalues i=2/4 {
	replace UB = b_`i'UB if tDID == -`i'
}
forvalues i=0/8{
	replace UB = b`i'UB if tDID == `i'
}
replace b = 0  if tDID == -1
replace LB = 0 if tDID == -1
replace UB = 0 if tDID == -1
keep tDID b LB UB
duplicates drop tDID,force
sort tDID
twoway (connected b tDID, sort)(rcap LB UB tDID)


//政策实施年平行趋势敏感性检验图//

matrix list e(b)
honestdid, pre(1/4) post(5/12) mvec(0(0.002)0.02) alpha(0.1)
local plotopts xtitle(平行趋势不成立的相对程度Mbar) ytitle(90%稳健置信区间) title(相对偏离程度限制) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) scheme(s1mono) 
honestdid, cached coefplot `plotopts'
local plotopts xtitle(平行趋势不成立的相对程度Mbar) ytitle(90%稳健置信区间) title(平滑限制) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) scheme(s1mono) 
honestdid,pre(1/4) post(5/12) mvec(0(0.002)0.02) delta(sd) alpha(0.1) coefplot `plotopts'


matrix l_vec = 0 \ 0 \ 0 \ 0 \ 0 \ 0 \ 0 \ 1 \ 0
honestdid,l_vec(l_vec) pre(1/4) post(5/13) mvec(0(0.002)0.02) alpha(0.1)
local plotopts xtitle(平行趋势不成立的相对程度Mbar) ytitle(90%稳健置信区间) title(相对偏离程度限制_post6) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) scheme(s1mono) 
honestdid, cached coefplot `plotopts'
local plotopts xtitle(平行趋势不成立的相对程度Mbar) ytitle(90%稳健置信区间) title(平滑限制_post6) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) scheme(s1mono)
matrix l_vec =0 \ 0 \ 0 \ 0 \ 0 \ 0 \ 0 \ 1 \ 0
honestdid,l_vec(l_vec) pre(1/4) post(5/13) mvec(0(0.002)0.02) delta(sd) coefplot `plotopts'









