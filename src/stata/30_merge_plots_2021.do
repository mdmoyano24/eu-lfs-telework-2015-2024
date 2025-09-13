* Load processed files
import delimited using "../../data/processed/lfsa_ehomp_2015_2024_clean.csv", varnames(1) clear
keep if time==2021
tempfile tele
save `tele'

import delimited using "../../data/processed/lfso_21jsat01_2015_2024_clean.csv", varnames(1) clear
tempfile js1
save `js1'

import delimited using "../../data/processed/lfso_21jsat04_2021_clean.csv", varnames(1) clear
tempfile js4
save `js4'

use `tele', clear
merge 1:1 geo time using `js1', keep(match) nogenerate
merge 1:1 geo time using `js4', keep(match master) nogenerate

rename telework_any telework_2021
rename share_high share_high_jsat01
rename share_in_group share_high_jsat04

* Correlations
pwcorr telework_2021 share_high_jsat01, sig
pwcorr telework_2021 share_high_jsat04, sig

* Scatterplots
twoway ///
 (scatter share_high_jsat01 telework_2021, msize(small) mcolor(blue)) ///
 , ///
 title("Telework vs High Job Satisfaction (2021)") ///
 ytitle("Share 'high satisfaction' (baseline)") ///
 xtitle("Telework (% of employees)") ///
 name(scatter_js01, replace)

graph export "../../paper/figs/telework_vs_jsat01_2021.png", width(1600) replace

twoway ///
 (scatter share_high_jsat04 telework_2021, msize(small) mcolor(navy)) ///
 , ///
 title("Telework vs High Satisfaction (WFH & Flex module, 2021)") ///
 ytitle("Share 'high satisfaction' (module)") ///
 xtitle("Telework (% of employees)") ///
 name(scatter_js04, replace)

graph export "../../paper/figs/telework_vs_jsat04_2021.png", width(1600) replace
