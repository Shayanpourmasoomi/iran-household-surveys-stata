# Iran household surveys in Stata

Stata code for two projects from my Econometrics course at Sharif University of Technology (Fall 2024). Both use microdata from the Statistical Centre of Iran.

| Folder | Survey | What it does |
|---|---|---|
| [`lfs-1402`](lfs-1402) | Labour Force Survey 1402 | Cleans the individual file and builds descriptive tables and figures on education, gender, insurance and work experience |
| [`heis-1401`](heis-1401) | Household Expenditure and Income Survey 1401 | Merges the rural and urban tables into a household file and estimates how education spending varies with labour income |

## Running the code

Each folder has a `master.do` that runs everything in order. Set the working directory to the project folder, put the data in `data/` and run:

```stata
cd "path/to/lfs-1402"
do master.do
```

Requirements: Stata 16 or later. The HEIS regression tables use `esttab` (`ssc install estout`).

## Data

The microdata are not included in this repository. Both surveys can be requested from the [Statistical Centre of Iran](https://www.amar.org.ir). The file names the code expects are listed in each project's README.
