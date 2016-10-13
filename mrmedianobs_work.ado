*! version 0.1.0 04jun2016 Tom Palmer
program mrmedianobs_work, eclass
_iv_parse `0'   // parses `0' of form: lhs exog (endog = inst)
local lhs `s(lhs)'
local endog `s(endog)'
local exog `s(exog)'
local inst `s(inst)'
local 0 `s(zero)'
local k = wordcount("`inst'") // no. instruments
tokenize `inst'
syntax [if] [in] [, PENWeighted Weighted]
mata gd = gdse = gp = gpse = J(`k', 1, .)
forvalues i=1/`k' {
        qui regress `lhs' ``i'' `exog' `if' `in'
        mata gd[`i'] = st_matrix("e(b)")[1]
        mata gdse[`i'] = sqrt(st_matrix("e(V)")[1,1])
        qui regress `endog' ``i'' `exog' `if' `in'
        mata gp[`i'] = st_matrix("e(b)")[1]
        mata gpse[`i'] = sqrt(st_matrix("e(V)")[1,1])
}
preserve
drop _all
cap set obs `k'
qui getmata gd gdse gp gpse, double replace
qui mrmedian gd gdse gp gpse, `weighted' `penweighted'
restore
end
