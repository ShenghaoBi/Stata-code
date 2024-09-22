ssc install did_imputation		// Borusyak et al. (2021)

ssc install did_multiplegt		// de Chaisemartin and D'Haultfoeuille (2022)
ssc install did_multiplegt_dyn	// 更快的 de Chaisemartin and D'Haultfoeuille (2022)

ssc install csdid				// Callaway and Sant'Anna (2021)

ssc install eventstudyinteract	// Sun and Abraham (2021)
ssc install avar				// Sun and Abraham (2021) 附加包

ssc install stackedev			// Cengiz et al.(2019)

ssc install event_plot			// 绘图工具包

*- 调用数据
use data.dta, clear

*- Borusyak et al. (2021)
did_imputation Y i t Ei, allhorizons pretrend(5) minn(0)
est store did1


*- de Chaisemartin and D'Haultfoeuille (2022)
did_multiplegt_dyn Y i t D, effects(10) placebo(3)
est store did2

*- Callaway and Sant'Anna (2021)
csdid Y, ivar(i) time(t) gvar(gvar) agg(event)
est store did3

*- Sun and Abraham (2021)
sum Ei
gen nevertreated = (Ei==.) // dummy for the latest- or never-treated cohort
forvalues l = 0/10 {
	gen L`l'event = K==`l'
}
forvalues l = 1/3 {
	gen F`l'event = K==-`l'
}
drop F1event // normalize K=-1 to zero

eventstudyinteract Y L*event F*event, vce(cluster i) absorb(i t) cohort(Ei) control_cohort(nevertreated)
matrix sa_b = e(b_iw) 
matrix sa_v = e(V_iw)

*- Cengiz et al.(2019)
stackedev Y F*event L*event, cohort(Ei) time(t) never_treat(nevertreated) unit_fe(i) clust_unit(i)
est store did5
*- TWFE
drop F*event L*event
forvalues l = 0/10 {
	gen L`l'event = K==`l'
}
forvalues l = 1/3 {
	gen F`l'event = K==-`l'
}
drop F1event // normalize K=-1 to zero
reghdfe Y F*event L*event, a(i t) cluster(i)
est store did6



*- 绘图
set scheme white_tableau
event_plot did1 did2 did3 sa_b#sa_v did5 did6, 							///
	stub_lag(tau# Effect_# Tp# L#event L#event L#event) 				///
	stub_lead(pre# Placebo_# Tm# F#event F#event F#event)				///
	plottype(scatter) ciplottype(rcap) 									///
	together perturb(-0.325(0.13)0.455) noautolegend 					///
	graph_opt(title("六种DID估计量(处理效应随t变化)", size(medlarge)) 	///
		xtitle("距离接受处理的时间") ytitle("平均处理效应") xlabel(-7(1)6) ylabel(-1(1)6) ///
		legend(order(1 "Borusyak et al. (2021)" 3 "de Chaisemartin and D'Haultfoeuille (2022)" 5 "Callaway and Sant'Anna (2021)" 7 "Sun and Abraham (2021)" 9  "Cengiz et al.(2019)" 11 "TWFE" ) r(3) pos(6)) ///
	/// the following lines replace default_look with something more elaborate
		xline(-0.5, lcolor(gs8) lpattern(dash)) yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ylabel(, angle(horizontal)) ylabel(-1(1)1) ///
	) ///
	lag_opt1(msymbol(+) color(cranberry)) lag_ci_opt1(color(cranberry)) ///
	lag_opt2(msymbol(O) color(purple)) lag_ci_opt2(color(purple)) ///
	lag_opt3(msymbol(Dh) color(blue)) lag_ci_opt3(color(blue)) ///
	lag_opt4(msymbol(Th) color(dkorange)) lag_ci_opt4(color(dkorange)) ///
	lag_opt5(msymbol(Sh) color(green)) lag_ci_opt5(color(green)) ///
	lag_opt6(msymbol(Oh) color(green)) lag_ci_opt6(color(green)) ///
	lag_opt7(msymbol(Ah) color(green)) lag_ci_opt7(color(green))
