# EDA (Technical Specification)

## Usage

Statistical tests can be run independently with `Rscript run-stats.R`:

- `-n`: name of the statistical test to run (required)
- `-c`: path to configuration file (defaults to `config.yml`)
- `-s`: years on which to split the data 
- `--stats = TRUE`: show statistical information (p-values, alpha, etc.)
- `--math = FALSE`: show mathematical equations for computing statistics
- `--code = FALSE`: show code used to carry out the test and generate the plot

Alternatively, the entire EDA workflow can be run with `Rscript eda.R`:

- `-c`: path to the configuration file (defaults to `config.yml`)
- `--stats = TRUE`: show statistical information (p-values, alpha, etc.)
- `--math = FALSE`: show mathematical equations for computing statistics
- `--code = FALSE`: show code used to carry out the test and generate the plot

## Style

Style guide: https://style.tidyverse.org/

## Configuration

The `config.yml` is used for all configuration related to the EDA process.

### Data Settings 

- `data_source`: The location of the data (one of `api` or `local`)
    - If `data_source = api`, use the `stations` argument.
    - If `data_source = local`, set the `data_folder` and `csv_files` arguments.
- `data_folder = ../data`: A path to a folder containing `.csv` files.
- `csv_files`: A list of `.csv` files in `data_folder`. Or use `'all'`.
- `stations`: A list of stations IDs.

### Statistical Settings

- `alpha = 0.05`: The significance level used for statistical tests.
- `bbmk_repetitions = 10000`: The number of bootstrap samples for the BBMK test.
- `window_length = 10`: The size of the window for computing AMS variances.
- `window_step = 5`: The step size for computing AMS variances.

### Other Settings

- `mode = 3`: The running mode. Must have one of the following three values:
    - `1`: Automatic. Do not split the data.
    - `2`: Automatic. Split on change points (prioritized by $p$-value).
    - `3`: Manual. The user is prompted at each change point.
- `report_folder = ../reports`: A path to a folder for writing reports. 


