# Roadmap

Preparing for CRAN:

- Ensure CRAN check is passing.
- Regenerate PDF documentation, add to website.
- Commit package and documentation to Github.

Package Installation:

- Run a test install of the package, write documentation.
- Write CLI configuration documentation.
- Test and build the rest of the CLI.

## CRAN Package

| File                | Roxygen2 | Website | Tested | Validated | Covered |
| ------------------- | -------- | ------- | ------ | --------- | ------- |
| ams-decomposition.R | x        | x       | x      |           |         |
| assessment-plot.R   | x        | x       | x      |           |         |
| bbmk-plot.R         | x        | x       | x      |           |         |
| bbmk-test.R         | x        | x       | x      |           |         |
| gll-functions.R     | x        | x       | x      | x         |         |
| kpss-test.R         | x        | x       | x      |           |         |
| ld-selection.R      | x        | x       | x      |           |         |
| lk-selection.R      | x        | x       | x      |           |         |
| llv-functions.R     | x        | x       | x      | x         |         |
| lmom-plot.R         | x        | x       | x      |           |         |
| lmom-sample.R       | x        | x       | x      |           |         |
| lmr-functions.R     | x        | x       | x      |           |         |
| mks-plot.R          | x        | x       | x      |           |         |
| mks-test.R          | x        | x       | x      |           |         |
| mk-test.R           | x        | x       | x      |           |         |
| mle-estimation.R    | x        | x       | x      |           |         |
| model-assessment.R  | x        | x       | x      |           |         |
| mw-variance.R       | x        | x       | x      |           |         |
| pel-functions.R     | x        | x       | x      |           |         |
| pelkap.R            | x        | x       | x      |           |         |
| pettitt-plot.R      | x        | x       | x      |           |         |
| pettitt-test.R      | x        | x       | x      |           |         |
| pp-test.R           | x        | x       | x      |           |         |
| qnt-functions.R     | x        | x       | x      |           |         |
| rfpl-uncertainty.R  | x        | x       | x      |           |         |
| runs-plot.R         | x        | x       | x      |           |         |
| runs-test.R         | x        | x       | x      |           |         |
| sb-uncertainty.R    | x        | x       | x      |           |         |
| sens-plot.R         | x        | x       | x      |           |         |
| sens-trend.R        | x        | x       | x      |           |         |
| spearman-plot.R     | x        | x       | x      |           |         |
| spearman-test.R     | x        | x       | x      |           |         |
| uncertainty-plot.R  | x        | x       | x      |           |         |
| white-test.R        | x        | x       | x      |           |         |
| z-selection.R       | x        | x       | x      |           |         |

Features:

- Add support for custom plot labels using an optional argument.
- Implement models with variance-only trends.
- Use 2-parameter Weibull for `rfpl-uncertainty`, reparamaterized on $\sigma$.

Touch-ups:

- Replace `nlminb` with `optim`, update documentation.
- Ensure that all references are to Hosking, 1997 (not 1996).
- Add parameter validation to _every_ function.
- Achieve 100% code coverage using the `covr` library.

### Notes

Package checking:

- `devtools::check()`
- `devtools::check(cran = TRUE)`

Documentation:

- `devtools::document()`: generate docmentation
- `devtools::build_manual(path = "~/Code/ffa-package")`: generate manual

Unit testing:

- `devtools::test()`: run all unit tests
- `devtools::test_file("tests/testthat/...")`: run a specific unit test

Generating a coverage report:

```
cov <- covr::package_coverage()
covr::report(cov, file = "coverage.html")
```

## Command Line Interface

**Exploratory Data Analysis**: Complete.

**Flood Frequency Analysis**: In progress.

## API Development

Talk to Kasra about cloud hosting for API.

- Finish CRAN/CLI/GeoMet by July 10th
  Link: [Building APIs with R](https://www.youtube.com/watch?v=t-Is-8Qfym0)

Need to learn:

- OpenAPI
- Swagger
- Docker

For the web app, use Flask/HTMX/Alpine.

https://api.weather.gc.ca/collections/hydrometric-annual-statistics

Sites used for the paper:

- `Application_1`: 07BE001 (Athabasca River at Athabasca)
- `Application_2`: 08NH021 (Kootenai River at Porthill)
- `Application_3_1`: 05BB001 (Bow River at Banff)
- `Application_3_2`: 08MH016 (Chilliwack River at Chilliwack Lake)
- `Application_3_3`: 08NM050 (Okanagan River at Penticton)

Query for getting a station (`hydrometric-annual-statistics/items`)

- `limit = 200` to get all the annual data
- `skipGeometry = TRUE` to ignore geographical data
- `DATA_TYPE_EN = Discharge` to get flows
- `STATION_NUMBER` set to the station number

Get a list of stations with (`hydrometric-stations/items`)

## Web App

Use Flask/HTML/CSS with leaflet.js

## Further Research

Read through papers on different NS metrics and possibly implement them:

- EWT: Olsen et al. 1998; Wigley, 2009
- ENE: Parey et al. 2007; 2010
- ERP: Katz et al. 2002
- R: Read & Vogel, 2015; Salas & Obeysekera, 2014; Serinaldi & Kilsby, 2015
- DLL: Rootzen & Katz, 2013
- ADLL: Yan et al. 2017

Outreach:

- Run workshops in August/September
- Write 10-page report by end of summer
- Develop training material
