* Iran Labour Force Survey 1402 - Econometrics course project 1
* Shayan Pourmasoomi, Sharif University of Technology, Fall 2024
*
* Put LFS1402.dta in data/ and run this file from the lfs-1402 folder.

clear all
set more off
version 16

global data   "data"
global output "output"

do "code/01_gender_ratio.do"
do "code/02_age_by_status.do"
do "code/03_insurance.do"
do "code/04_experience.do"
