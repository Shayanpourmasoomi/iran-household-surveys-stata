* Q2: non-employed population by activity status, and the mean age of each group

use "$data/LFS1402.dta", clear

gen status = real(F3_D36)
gen age = real(F2_D07)

* F3_D36 is asked only of people without a job; codes 2-6 are compared here
keep if inrange(status, 2, 6)
label define status 2 "Student" 3 "Housewife" 4 "Retired" 5 "Income, not retired" 6 "Other"
label values status status

graph pie, over(status) plabel(_all percent, format(%4.1f)) ///
    title("Distribution of Non-Employed Population")
graph export "$output/employment_status_pie.png", replace width(1600)

tabstat age, by(status) statistics(mean n) format(%9.1f)

graph bar (mean) age, over(status) bar(1, color(navy)) ///
    blabel(bar, format(%4.1f)) ylabel(0(10)60) ///
    ytitle("Mean age") title("Mean Age by Activity Status")
graph export "$output/age_by_status.png", replace width(1600)

putdocx clear
putdocx begin
putdocx paragraph, style(Heading1)
putdocx text ("Mean Age of the Non-Employed Population")

putdocx table tab2 = (6, 3)
putdocx table tab2(1, 1) = ("Status")
putdocx table tab2(1, 2) = ("Mean age")
putdocx table tab2(1, 3) = ("N")

local row = 2
levelsof status, local(groups)
foreach g of local groups {
    quietly summarize age if status == `g'
    local m = r(mean)
    local n = r(N)
    putdocx table tab2(`row', 1) = ("`: label status `g''")
    putdocx table tab2(`row', 2) = (string(`m', "%4.1f"))
    putdocx table tab2(`row', 3) = (string(`n', "%12.0fc"))
    local ++row
}

putdocx table tab2(1, .), bold
putdocx table tab2(., .), border(all) halign(center)
putdocx save "$output/age_by_status.docx", replace
