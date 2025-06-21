# Roadmap

## CRAN Package

Final changes:

- Remove `Rcpp` dependency.
- Make the `xxx` functions fast, do argument validation in the distribution functions.
- Add support for custom plot labels using an optional argument.

Then, go through each function:

- Carefully write/edit/read documentation.
- Update the website with the contents of the file.
- Add additional tests to cover edge cases.
- Ensure all tests are passing.

Preparing for CRAN:

- Ensure CRAN check is passing.
- Regenerate PDF documentation, add to website.

Issue in `rfpl-uncertainty` for the Weibull distribution:

- When finding the upper confidence interval we iteratively adjust `yp` up until `f < 0`.
- This iterative process drives `u` upwards through the reparameterization.
- Sometimes the `yp` value required to get `f < 0` causes `data > u` for a point.
- Then, the Weibull distribution has no support and it blows up.

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

Use Flask/HTML/CSS with leaflet.js

## Further Research

Read through papers on different NS metrics and possibly implement them:

- EWT: Olsen et al. 1998; Wigley, 2009
- ENE: Parey et al. 2007; 2010
- ERP: Katz et al. 2002
- R: Read & Vogel, 2015; Salas & Obeysekera, 2014; Serinaldi & Kilsby, 2015
- DLL: Rootzen & Katz, 2013
- ADLL: Yan et al. 2017


