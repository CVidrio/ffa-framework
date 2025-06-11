# Roadmap

## CRAN Package

Implementing remaining functions:

- [x] `mle.estimation`
- [x] `gmle.estimation`
- [ ] Remove GPA distribution from L-moments estimation and test cases
- [ ] Split `log.likelihood` and `generalized.likelihood` into new files
    - Write unit tests (should be identical to MATLAB)
    - Ensure that invalid parameters are handled gracefully
- [ ] `rfpl.uncertainty`
- [ ] `rfgpl.uncertainty`

Touch-ups:

- [ ] Make parallelization optional (to improve reproducibility)
- [ ] Separate plotting tests into different files.
- [ ] Add more plotting tests including `vdiffr` tests.
- [ ] Remove redundant parameters in uncertainty/assessment functions.

Rewriting functions:

- [ ] `kpss.test`
- [ ] `pp.test`
- [ ] `runs.test`

List of functions:

- EDA:
    - `mw.variance`
    - `pettitt.test`
    - `mks.test`
    - `mk.test`
    - `spearman.test`
    - `bbmk.test`
    - `pp.test`+
    - `kpss.test`+
    - `runs.test`+
    - `white.test`
    - `sens.trend`
- FFA:
    - `get.distributions`
    - `ams.decomposition`
    - `ld.selection`
    - `lk.selection`
    - `z.selection`
    - `lmom.estimation`
    - `mle.estimation`*
    - `gmle.estimation`*
    - `sb.uncertainty`
    - `rfpl.uncertainty`*
    - `rfgpl.uncertainty`*
    - `model.assessment`
- Plotting:
    - `mks.plot`
    - `bbmk.plot`
    - `pettitt.plot`
    - `runs.plot`
    - `spearman.plot`
    - `lmom.plot`
    - `uncertainty.plot`
    - `assessment.plot`

**Note**: Functions with a (\*) bullet point need to be ported.

**Note**: Functions with a (\*) marker need to be written.

**Note**: Functions with a (+) need to be rewritten/tested.

## Command Line Interface

**Exploratory Data Analysis**: COMPLETE

**Flood Frequency Analysis**: TBD

Revise documentation (focus on simplicity) for FFA

- [ ] Mention manual implementation of `get-kappa-params.R`
- [ ] Mention different parameterizations for GEV/GPA
- [ ] Mention parallelization

## API Development

https://www.youtube.com/watch?v=t-Is-8Qfym0

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

Use Flaks/HTML/CSS with leaflet.js
