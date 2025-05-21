# EDA Framework

The exploratory data analysis (EDA) module of the flood frequency analysis (FFA) framework allows users to run statistical tests on annual maximum streamflow (AMS) data.
These statistical tests have four purposes:

1. Identify change points ("jumps" or "kinks") in the AMS data.
2. Identify [serial correlation](https://en.wikipedia.org/wiki/Autocorrelation) in the AMS data.
3. Identify trends in the mean value of the AMS data.
4. Identify trends in the variability of the AMS data.

![Diagram showing current EDA framework.](img/fig-eda-current.png)

## Change Point Detection

- [Pettitt Test](eda/pettitt.md)
- [Mann-Kendall-Sneyers Test](eda/mks.md)

## Trend Identification

### AMS Means

- [Mann-Kendall Test](eda/mk.md)
- [Spearman Test](eda/spearman.md)
- [Block Bootstrap Mann-Kendall Test](eda/bbmk.md)
- [Phillips-Perron Test](eda/pp.md)
- [KPSS Test](eda/kpss.md)
- [Sen's Trend Estimator](eda/sens.md)

### AMS Variance

- [White Test](eda/white.md)
- [Moving Window Mann-Kendall Test](eda/mwmk.md)
- [Sen's Trend Estimator](eda/sens.md)
