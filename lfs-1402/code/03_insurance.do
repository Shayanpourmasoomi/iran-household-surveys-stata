* Q3: insurance coverage of employed university graduates, by gender

use "$data/LFS1402.dta", clear

keep if inlist(F2_D17, "6", "7", "8")

* F3_D13 is answered only by the employed: 1 = insured, 2 = not insured
gen insured = real(F3_D13)
keep if inlist(insured, 1, 2)
replace insured = 100 * (insured == 1)

* stack a copy of the sample to get the total as a third group
gen group = F2_D04 == "2"
expand 2, generate(copy)
replace group = 2 if copy
label define group 0 "Men" 1 "Women" 2 "Total"
label values group group

collapse (mean) insured (count) n = insured, by(group)
gen uninsured = 100 - insured
list group n insured uninsured, noobs

graph bar insured uninsured, over(group) stack ///
    bar(1, color("0 110 182")) bar(2, color("217 37 37")) ///
    blabel(bar, position(center) format(%4.1f) color(white)) ///
    legend(order(1 "Insured" 2 "Uninsured") rows(1)) ///
    ytitle("Percent") ylabel(0(20)100) ///
    title("Insurance Status of Employed University Graduates")
graph export "$output/insurance_status.png", replace width(1600)
