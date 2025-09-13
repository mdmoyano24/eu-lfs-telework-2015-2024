* Load Eurostat SDMX-CSV exported by Python
import delimited using "../../data/raw/lfsa_ehomp.csv", varnames(1) clear

* Normalize names
rename time_period time
rename obs_value value

* Keep years 2015–2024 and non-missing values
destring time, replace force
keep if inrange(time, 2015, 2024)
destring value, replace force
drop if missing(value)

* Normalize EU aggregate if present
replace geo = "EU27_2020" if geo=="EU28"

* Keep "totals" in dimensions:
* - sex: T or TOTAL
keep if inlist(sex, "T", "TOTAL")

* - age: prefer Y20-64, else Y15-64, else Y15-74 (pick best available)
preserve
keep if age=="Y20-64"
count
local n = r(N)
restore
if `n' > 0 {
    keep if age=="Y20-64"
}
else {
    preserve
    keep if age=="Y15-64"
    count
    local n2 = r(N)
    restore
    if `n2' > 0 keep if age=="Y15-64"
    else keep if age=="Y15-74"
}

* - wstatus: prefer EMP, else TOTAL
preserve
keep if wstatus=="EMP"
count
local nw = r(N)
restore
if `nw' > 0 keep if wstatus=="EMP"
else keep if wstatus=="TOTAL"

* Keep frequency categories USU / SMT (usually/sometimes)
keep if inlist(frequenc, "USU", "SMT")

* Build wide: one row per geo-time with USU, SMT, telework_any
collapse (mean) value, by(geo time frequenc)
reshape wide value, i(geo time) j(frequenc) string
rename valueUSU USU
rename valueSMT SMT
gen telework_any = USU + SMT

sort geo time
order geo time USU SMT telework_any
export delimited using "../../data/processed/lfsa_ehomp_2015_2024_clean.csv", replace
save "../../data/processed/lfsa_ehomp_2015_2024_clean.dta", replace
