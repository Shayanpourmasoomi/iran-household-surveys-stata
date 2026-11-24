* Iran Household Expenditure and Income Survey 1401 - Econometrics course project 2
* Shayan Pourmasoomi, Sharif University of Technology, Fall 2024
*
* Put the raw R1401* and U1401* tables in data/raw and run this file
* from the heis-1401 folder. The tables use esttab: ssc install estout

clear all
set more off
version 16

global raw    "data/raw"
global data   "data"
global output "output"

do "code/01_build_household.do"
do "code/02_regressions.do"
