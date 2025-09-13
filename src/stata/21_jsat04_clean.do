* Load jsat04 (Eurostat SDMX-CSV saved by Python)
import delimited using "../../data/raw/lfso_21jsat04.csv", varnames(1) clear

rename time_period time
rename obs_value value
destring value, replace force
destring time, replace force
keep if inrange(time, 2015, 2024)
drop if missing(value)

* Drop low-reliability if flagged
capture confirm variable OBS_FLAG
if _rc==0 drop if strpos(lower(OBS_FLAG),"u")

* Totals for sex/age if exist
capture confirm variable sex
if _rc==0 keep if inlist(sex,"T","TOTAL","All sexes")
capture confirm variable age
if _rc==0 keep if inlist(age,"Y20-64","Y15-64","Y15-74","TOTAL","All ages")

* Group is geo x sex x age x telework frequency x flexibility category
* Eurostat names differ; here 'frequenc' and 'wtflex'
tempfile base
save `base'
preserve
collapse (sum) value, by(geo time sex age frequenc wtflex)
rename value total_group
tempfile totals
save `totals'
restore

* Keep HIGH satisfaction and compute share within the group
keep if upper(lev_satis)=="HIGH"
merge 1:1 geo time sex age frequenc wtflex using `totals', nogenerate
gen share_in_group = value/total_group

* Aggregate to geo-time (mean across sex/age/frequency/flex categories)
collapse (mean) share_in_group, by(geo time)
sort geo time
export delimited using "../../data/processed/lfso_21jsat04_2021_clean.csv", replace
save "../../data/processed/lfso_21jsat04_2021_clean.dta", replace
