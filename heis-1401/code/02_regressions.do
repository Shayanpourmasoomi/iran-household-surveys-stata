* Education spending and household income

use "$data/heis1401_household.dta", clear

* urban-rural comparison
tabstat edu income, by(urban) statistics(mean median n) format(%9.1f)

gen ln_income = ln(income)    // zero and negative incomes drop out here
histogram ln_income, width(0.25) fcolor(navy%70) lcolor(white) ///
    by(urban, total note("") title("Log labour income by area")) ///
    xtitle("Log annual labour income (million rials)")
graph export "$output/log_income_by_area.png", replace width(1600)

* income only, urban dummy, interaction, age of head, robust SE, province FE
eststo clear
eststo: regress edu income
eststo: regress edu income i.urban
eststo: regress edu c.income##i.urban
eststo: regress edu c.income##i.urban age_head
eststo: regress edu c.income##i.urban age_head, vce(robust)
eststo: regress edu c.income##i.urban age_head i.province, vce(robust)

esttab, se b(%9.4f) se(%9.4f) r2 label nobase noomitted ///
    interaction(" x ") star(* 0.10 ** 0.05 *** 0.01) ///
    indicate("Province FE = *.province") ///
    nomtitles

esttab using "$output/regressions.rtf", replace ///
    se b(%9.4f) se(%9.4f) r2 label nobase noomitted ///
    interaction(" x ") star(* 0.10 ** 0.05 *** 0.01) ///
    indicate("Province FE = *.province") ///
    nomtitles ///
    title("Education spending and labour income, HEIS 1401") ///
    addnotes("Columns 5-6: heteroskedasticity-robust standard errors.")
