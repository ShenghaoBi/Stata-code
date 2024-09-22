
reghdfe rebel did, absorb(i.county i.year) cluster(county)
estimates store did_cao_chen

**时间安慰剂检验
didplacebo did_cao_chen, treatvar(did) pbotime(1(1)10)

**空间安慰剂检验
didplacebo did_cao_chen, treatvar(did) pbounit rep(500) seed(1)

**混合安慰剂检验
didplacebo did_cao_chen, treatvar(did)  pbomix(1)

