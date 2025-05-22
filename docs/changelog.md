# Changelog

## v0.0.3

May 22nd, 2025

- Return information about non-stationary structure(s) at the end of EDA
- Use the `/data` and `/reports` directories as defaults in `config.yml`
- Refactor code for batching EDA in `stats.R`, `eda.R`
- Implement support for PDF reports using a custom $\LaTeX$ template

## v0.0.2
 
May 21st, 2025

- Host documentation at https://rileywheadon.github.io/ffa-framework/
- Implement splitting (for change points) in `stats.R` and `eda.R`
- Run EDA on multiple files by setting `csv_files` to a list in `config.yml`

## v0.0.1 

May 16th, 2025

- Execute individual statistical tests using `stats.R`
- Run a suite of unit tests using `tests.R`
- Run the entire EDA pipeline (without data spliting) using `eda.R`
