* Load jsat01 (Eurostat SDMX-CSV saved by Python)
import delimited using "../../data/raw/lfso_21jsat01.csv", varnames(1) clear

* Normalize names
rename time_period time
rename obs_value value
destring value, replace force

* Keep 2015–2024 if available (most cases only 2021)
destring time, replace force
keep if inrange(time, 2015, 2024)
drop if missing(value)


* 1) If present, keep totals for sex/age so groups are not fragmented
capture confirm variable sex
if _rc==0 keep if inlist(sex,"T","TOTAL","All sexes")
capture confirm variable age
if _rc==0 keep if inlist(age,"Y20-64","Y15-64","Y15-74","TOTAL","All ages")

* 2) Define the grouping keys available in your file
local keys "geo time"
capture confirm variable c_birth
if _rc==0 local keys "`keys' c_birth"
capture confirm variable isced11
if _rc==0 local keys "`keys' isced11"

* 3) Compute group totals over those keys (denominator)
*    -> for THS_PER this is people; for PC it's the sum of category shares
bysort `keys': egen group_total = total(value)

* 4) Keep only rows with HIGH satisfaction (numerator)
keep if upper(lev_satis)=="HIGH"

* 5) Compute share = HIGH / total within each group
gen share_high = value / group_total

* 6) Collapse to country-year (average across any remaining breakdowns)
collapse (mean) share_high, by(geo time)

* 7) Save
sort geo time
export delimited using "../../data/processed/lfso_21jsat01_2015_2024_clean.csv", replace
save "../../data/processed/lfso_21jsat01_2015_2024_clean.dta", replace
