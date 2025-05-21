# EDA Framework

The exploratory data analysis (EDA) module of the flood frequency analysis (FFA) framework allows users to run statistical tests on annual maximum streamflow (AMS) data.
These statistical tests have four purposes:

1. Identify change points ("jumps" or "kinks") in the AMS data.
2. Identify [serial correlation](https://en.wikipedia.org/wiki/Autocorrelation) in the AMS data.
3. Identify trends in the mean value of the AMS data.
4. Identify trends in the variability of the AMS data.

A diagram showing the current EDA framework is shown below:

![Diagram showing current EDA framework.](img/fig-eda-current.png)

## List of Statistical Tests

### Change Point Detection

- [Pettitt Test](eda/pettitt.md)
- [Mann-Kendall-Sneyers (MKS) Test](eda/mks.md)

### Trend Identification (AMS Means)

- [Mann-Kendall (MK) Test](eda/mk.md)
- [Spearman Test](eda/spearman.md)
- [Block Bootstrap Mann-Kendall (BB-MK) Test](eda/bbmk.md)
- [Phillips-Perron (PP) Test](eda/pp.md)
- [KPSS Test](eda/kpss.md)

### Trend Identification (AMS Variance) 

- [White Test](eda/white.md)
- [Moving Window Mann-Kendall (MW-MK) Test](eda/mwmk.md)

### Trend Estimation

- [Sen's Trend Estimator](eda/sens.md)
