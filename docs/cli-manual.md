# User Manual

All configuration is done through YAML files. The default configuration file is `source/config.yml`, although it is possible to create additional configuration files and pass them to the scripts using the `--config` command line argument.

## Folder Configuration

`data_folder`: This argument should be an _absolute path_ to a directory containing the CSV files you would like to run the framework on. _The framework may not work if you use a relative path_.

- Alternatively, `data_folder: null` will use the default `ffa-framework/data` folder.

`csv_files`: A list of 1 or more CSV files located in `data_folder`.

- Alternatively, `csv_files: null` will run the framework on every file in `data_folder`.

`report_folder`: An _absolute path_ to a directory which will be used to store EDA and FFA reports. The directory must exist. Again, _the framework may not work if you use a relative path_.

- Alternatively, `report_folder: null` will use the default `ffa-framework/reports` folder.

**Example Configuration (1)**

```yaml
data_folder: "~/Desktop/ffa-data"

csv_files:
  - "dataset-1.csv"
  - "dataset-2.csv"

report_folder: "~/Desktop/ffa-reports"
```

**Example Configuration (2)**

```yaml
data_folder: null

csv_files: null

report_folder: null
```

## Exploratory Data Analysis (EDA)

For more information about the statistical tests used for EDA, see [here](eda.md).

The configuration options for the EDA portion of the framework are as follows:

- `mode`: The mode in which to run EDA (complete framework only). Must be one of:
    - `"preset"`: Specify split points ahead of time using the `split_points` option.
    - `"automatic"`: Automatically determine split points using change point tests.
    - `"manual"`: Manually confirm the split points identified using change point tests.
- `split_points`: Used with `mode: "preset"` to set split points ahead of time (as a list of years).
    - Alternatively, `split_points: null` will disable splitting entirely.
- `alpha`: The confidence level used for statistical tests (must be between $0.01$ and $0.10$).
- `bbmk_repetitions`: The number of boostrap samples to use for the [BB-MK Test](eda.md/#bb-mk-test).
- `window_length`: The size of the moving window used to compute the streamflow variance.
- `window_step`: The size of the steps used to compute the streamflow variance.
- `show_trend`: Whether or not to draw a trend line between data points (`true` or `false`).
- `generate_report`: Whether or not to generate a report (`true` or `false`).
- `report_format`: A list of report formats (`"md_document"`, `"html_document"`, or `"pdf_document"`).

**Example Configuration**

```yaml
mode: "manual"

split_points: null

alpha: 0.05

bbmk_repetitions: 10000

window_length: 10

window_step: 5

show_trend: false

generate_report: true

report_format: "html_document"
```

**Example (Disable Splitting)**

```yaml
mode: "preset"

split_points: null
```

**Example (Preset Split Points)**

```yaml
mode: "preset"

split_points:
  - 1950
  - 1980
```

### Running the Complete EDA Framework

The `source/eda.R` script is used to run the complete EDA framework. The optional command line argument `--config` can be used to specify a custom configuration file. If `--config` is not specified, the framework will use `config.yml` as a default.

**Example Usage (1)**

```
Rscript eda.R
```

**Example Usage (2)**

```
Rscript eda.R --config='custom-config.yml'
```

### Running Individual Statistical Tests

The `source/stats.R` script is used to run individual statistical tests.

- `--name` (required) is used to configure the name of the statistical test. It must be one of "bbmk", "kpss", "mk", "mks", "mwmk", "pettitt", "pp", "sens-mean", "sens-variance", "spearman", and "white".
- `--config` (optional) can be used to specify a custom configuration file.

**Example Usage (1)**

```
Rscript stats.R --name='mks'
```

**Example Usage (2)**

```
Rscript stats.R --name='white' --config='custom-config.yml'
```

## Frequency Analysis

TBD
