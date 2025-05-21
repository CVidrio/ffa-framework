# KPSS Test

The **KPSS Test** is used to identify if an autoregressive time series has a _unit root_.

- Null hypothesis: The time series has does not have a unit root.
- Alternative hypothesis: The time series has a unit root.

Precisely, the autoregressive time series shown below has unit root if $\sigma ^2 > 0$:

$$
\begin{align}
y_{t} &= \mu_{t} + \alpha t + \epsilon_{t} \\
\mu_{t} &= \mu_{t-1} + v_{t} \\
\end{align}
$$

Here's what each term in this formulation represents:

- $\mu_{t}$ is the *drift*, or the deviation of $y_{t}$ from $0$. 
  - Under the null hypothesis, $\mu_{t}$ is constant (since $v_{t}$ is constant). 
  - Under the alternative hypothesis, $\mu_t$ is a stochastic process with unit root.
- $\alpha t$ is a *linear trend*, which represents deterministic non-stationarity (i.e. climate  change).
- $\epsilon_{t}$ is *stationary noise*, corresponding to reversible fluctuations in $y_{t}$. 
  - In hydrology, $\epsilon_{t}$ represents fluctuations in streamflow due to random events (i.e. weather).
- $v_{t}$ is *random walk innovation*, or irreversible fluctuations in $\mu_{t}$.
  - In hydrology, $v_{t}$ could represent randomness in industrial activity causing climate change.

This test is implemented using R package [aTSA](https://cran.r-project.org/web/packages/aTSA/index.html) with the following settings:

- `lag.short = TRUE`, since AMS data has minimal autocorrelation.
- We consider `type3` results since we are assuming the presence of a trend.

For more information, see the [documentation](https://www.rdocumentation.org/packages/aTSA/versions/3.1.2.1/topics/kpss.test).

**Warning**: The implementation of the KPSS test in the aTSA package interpolates the p-value using a table from [Hobjin et al. (2004)](https://doi.org/10.1111/j.1467-9574.2004.00272.x).
This table only contains significance thresholds for $0.01$, $0.05$ and $0.10$. 
Therefore, p-values below $0.01$ and above $0.10$ will be truncated.

