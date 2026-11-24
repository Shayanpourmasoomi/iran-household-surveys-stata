* Q1: gender composition of university graduates, urban vs rural

use "$data/LFS1402.dta", clear

* the 5th digit of pkey marks the area
gen area = real(substr(pkey, 5, 1))
label define area 1 "City" 2 "Rural"
label values area area

gen female = F2_D04 == "2"
keep if inlist(F2_D17, "6", "7", "8")    // bachelor, master, doctorate

tab area female, row

putdocx clear
putdocx begin
putdocx paragraph, style(Heading1)
putdocx text ("Gender Ratio of University-Educated Individuals by Area")

putdocx table tab1 = (5, 4)
putdocx table tab1(1, 1) = ("Area")
putdocx table tab1(1, 2) = ("Gender")
putdocx table tab1(1, 3) = ("Count")
putdocx table tab1(1, 4) = ("Percent")

local row = 2
forvalues a = 1/2 {
    quietly count if area == `a'
    local total = r(N)
    forvalues f = 0/1 {
        quietly count if area == `a' & female == `f'
        local n = r(N)
        local gender = cond(`f', "Women", "Men")
        putdocx table tab1(`row', 1) = ("`: label area `a''")
        putdocx table tab1(`row', 2) = ("`gender'")
        putdocx table tab1(`row', 3) = (string(`n', "%12.0fc"))
        putdocx table tab1(`row', 4) = (string(100 * `n' / `total', "%4.1f") + "%")
        local ++row
    }
}

putdocx table tab1(1, .), bold
putdocx table tab1(., .), border(all) halign(center)
putdocx save "$output/gender_ratio.docx", replace
