* Build one row per household from the HEIS 1401 tables
* R = rural, U = urban. P1: members, P3S13: annual expenditure items,
* P4S01: wage jobs, P4S02: self-employment

foreach t in P1 P3S13 P4S01 P4S02 {
    use "$raw/R1401`t'.dta", clear
    append using "$raw/U1401`t'.dta"
    tempfile `t'
    save ``t''
}

* age of the household head
use `P1', clear
keep if strtrim(DYCOL03) == "1"
gen age_head = real(DYCOL05)
keep Address age_head
tempfile heads
save `heads'

* education spending: items whose code starts with 10
use `P3S13', clear
keep if substr(DYCOL01, 1, 2) == "10"
gen double edu = real(DYCOL05)
collapse (sum) edu, by(Address)
tempfile edu
save `edu'

* annual net income from wage jobs and self-employment
use `P4S01', clear
append using `P4S02'
gen double income = real(DYCOL15)
drop if missing(income)
collapse (sum) income, by(Address)

merge 1:1 Address using `heads', keep(match) nogenerate
merge 1:1 Address using `edu', keep(master match)
replace edu = 0 if _merge == 1
drop _merge

gen urban = substr(Address, 1, 1) == "1"
gen province = real(substr(Address, 2, 2))
label define urban 0 "Rural" 1 "Urban"
label values urban urban

* million rials
replace edu = edu / 1e6
replace income = income / 1e6

label var edu "Education spending"
label var income "Labour income"
label var age_head "Age of head"
label var urban "Urban"
label var province "Province"

compress
save "$data/heis1401_household.dta", replace
