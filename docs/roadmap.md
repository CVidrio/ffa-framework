# Roadmap

## CRAN Package

Implementing remaining functions:

- `rfpl.uncertainty`
- `rfgpl.uncertainty`
- Update `sb.uncertainty` for non-stationary distributions

Touch-ups:

- Change NS uncertainty axis label to "Effective Return Period"
- Implement a NS uncertainty plot with multiple slices
- Add support for custom plot labels using an optional argument
- Add option to run NS uncertainty quantification on 1+ time slices

Read through papers on different NS metrics and possibly implement them:

- EWT: Olsen et al. 1998; Wigley, 2009
- ENE: Parey et al. 2007; 2010
- ERP: Katz et al. 2002
- R: Read & Vogel, 2015; Salas & Obeysekera, 2014; Serinaldi & Kilsby, 2015
- DLL: Rootzen & Katz, 2013
- ADLL: Yan et al. 2017

### Preparing For CRAN

Carefully edit documentation.

### List of Functions

Helper functions:

- `mw.variance`
- `get.distributions`
- `ams.decomposition`

EDA:

- `pettitt.test`
- `mks.test`
- `mk.test`
- `spearman.test`
- `bbmk.test`
- `pp.test`
- `kpss.test`
- `runs.test`
- `white.test`
- `sens.trend`

Likelihood Functions:

- `likelihood`
- `generalized.likelihood`
- `fixed.likelihood`
- `reparameterized.likelihood`

FFA:

- `ld.selection`
- `lk.selection`
- `z.selection`
- `lmom.estimation`
- `mle.estimation`
- `gmle.estimation`
- `sb.uncertainty`
- `rfpl.uncertainty`
- `rfgpl.uncertainty`
- `model.assessment`

Plotting:

- `mks.plot`
- `bbmk.plot`
- `pettitt.plot`
- `runs.plot`
- `spearman.plot`
- `lmom.plot`
- `uncertainty.plot`
- `assessment.plot`

## Command Line Interface

**Exploratory Data Analysis**: Complete.

**Flood Frequency Analysis**: In progress.

## API Development

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

Use Flaks/HTML/CSS with leaflet.js
