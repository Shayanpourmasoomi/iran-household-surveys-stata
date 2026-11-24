* Years in the current job and total work experience, by sector and gender

use "$data/LFS1402.dta", clear

gen female = F2_D04 == "2"
gen isic = real(strtrim(F3_D10))    // two-digit ISIC; codes like X0000 become missing
gen tenure = real(F3_D14SAL)
gen experience = real(F3_D15SAL)

gen sector = 1 if inrange(isic, 1, 3)
replace sector = 2 if inrange(isic, 5, 43)
replace sector = 3 if inrange(isic, 45, 99)
label define sector 1 "Agriculture" 2 "Industry" 3 "Services"
label values sector sector
keep if !missing(sector)

expand 2, generate(copy)
replace female = 2 if copy
label define gender 0 "Men" 1 "Women" 2 "Total"
label values female gender

collapse (mean) tenure experience, by(sector female)
format tenure experience %6.2f
list, sepby(sector) noobs

decode sector, generate(Sector)
decode female, generate(Group)
gen Tenure = string(tenure, "%5.2f")
gen Experience = string(experience, "%5.2f")

putdocx clear
putdocx begin
putdocx paragraph, style(Heading1)
putdocx text ("Years in Current Job and Total Experience by Sector")
putdocx table tab4 = data(Sector Group Tenure Experience), varnames border(all)
putdocx save "$output/work_experience.docx", replace
