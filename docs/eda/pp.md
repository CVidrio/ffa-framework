# Phillips-Perron Test

The **Phillips-Perron (PP) Test** is used to identify if an autoregressive time series $y_t$ has a unit root.

- Null hypothesis: $y_{t}$ has a *unit root* and is thus *non-stationary*.
- Alternative hypothesis: $y_{t}$ does not have a unit root and is *trend-stationary*.

Precisely, let $x_{t}$ be an [AR(1)](https://en.wikipedia.org/wiki/Autoregressive_model) model.
Let $y_{t}$ be a function of $x_{t}$ with drift $\mu$ and trend $\alpha t$.

$$
\begin{align}
y_{t} &= \mu + \alpha t + x_{t} \\
x_{t} &= \rho x_{t-1} + \epsilon_{t}
\end{align}
$$

- If $\rho = 1$, then $x_t$ and hence $y_t$ has a *unit root* (null hypothesis).
- If $\rho < 1$, then $y_t$ is *trend stationary* (alternative hypothesis).

This test is implemented using R package [aTSA](https://cran.r-project.org/web/packages/aTSA/index.html) with the following settings:

- `lag.short = TRUE`, since AMS data has minimal autocorrelation.
- We consider `type3` results since we are assuming the presence of drift and trend.

For more information, see the [documentation](https://www.rdocumentation.org/packages/aTSA/versions/3.1.2.1/topics/pp.test).

**Warning**: The implementation of the PP test in the aTSA package interpolates the p-value using a table from Fuller, W. A. (1996).
This table only contains significance thresholds for $0.01$, $0.05$ and $0.10$. 
Therefore, p-values below $0.01$ and above $0.10$ will be truncated.

