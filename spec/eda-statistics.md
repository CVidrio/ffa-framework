# EDA (Statistics)

## 1: Identification of Change Points in AMS Mean

### Pettitt Test

The **Pettitt Test** is used to identify abrupt changes in the mean of a time series.

- Null Hypothesis: There are no abrupt changes in the time series mean.
- Alternative Hypothesis: There is _one_ abrupt change in the time series mean.

Define $\text{sign} (x)$ to be $1$ if $x > 0$, $0$ if $x = 0$, and $-1$ otherwise.

Given a time series $y_{1}, \dots, y_{n}$, compute the following test statistic:

$$
U_{t} = \sum_{i=1}^{t} \sum_{j=t+1}^{n} \text{sign} (y_{j} - y_{i}), \quad K = \max_{t}|U_{t}|
$$

The value of $t$ such that  $U_{t} = K$ is a **Potential Change Point**. The $p$-value of the potential change point can be approximated using the following formula for a one-sided test:

$$
p \approx \exp \left(-\frac{6K^2}{n^3 + n^2}\right)
$$

If $p$ is less than the significance level $\alpha$, we reject the null hypothesis and conclude that there is evidence for an abrupt change in the mean at the potential change point.  

### Mann-Kendall Sneyers (MKS) Test

The **MKS Test** is used to identify the beginning of a trend in a time series: 

- Null Hypothesis: There are no change points in the time series.
- Alternative Hypothesis: There are *one or more* change points in the time series.

Define $\mathbb{I}(y_{i} > y_{j})$ to be $1$ if $y_{i} > y_{j}$ and $0$ otherwise. 

Given a time series $y_{1}, \dots, y_{n}$, we compute the following test statistic:

$$
\begin{equation}
S_{t} = \sum_{i=i}^{t} \sum_{j=1}^{i-1} \mathbb{I}(y_{i} > y_{j})
\end{equation}
$$

Then, we compute the the **Progressive Series** $UF_{t}$:

$$
UF_{t} = \frac{S_{t} - \mathbb{E}[S_{t}]}{\sqrt{\text{Var}\,(S_{t})}}
$$

Next, we reverse the time series to create a new time series $y'$ such that $y'_{i} = y_{n+1-i}$.
Then, we use formula (1) to compute $S_{t}'$ for $y'$ and reverse $S_{t}'$ to get $S_{t}''$  .

The **Regressive Series** $UB_{t}$ is defined as follows:

$$
UB_{t} = \frac{S_{t}'' - \mathbb{E}[S_{t}'']}{\sqrt{\text{Var}\,(S_{t}'')}}
$$

For both the progressive and regressive series, the expectation and variance is as follows:

$$
\mathbb{E}[S_{t}] = \mathbb{E}[S_{t}'']= \frac{t(t-1)}{4} \\[5pt]
\text{Var}(S_{t}) = \text{Var}(S_{t}'') = \frac{t(t-1)(2t+5)}{72}
$$

Finally, we plot $UF_{t}$ and $UB_{t}$ with confidence bounds at $\pm z_{1 - (\alpha/2)}$, where $\alpha$ is the chosen significance level. 
A crossing point between $UF_{t}$ and $UB_{t}$ that lies outside the confidence bounds indicates the start of the trend.

## 2: Identification of Trends in AMS Mean

### Mann-Kendall (MK) Test 

The **MK Test** is used to assess whether there is a statistically significant monotonic trend in a time series.
The test requires that when no trend is present, the data is independent and identically distributed.
In particular, the data must not be *autocorrelated*.

- Null Hypothesis: There is no monotonic trend.
- Alternative Hypothesis: There is a monotonic upwards or downwards trend.

Define $\text{sign} (x)$ to be $1$ if $x > 0$, $0$ if $x = 0$, and $-1$ otherwise.

The test statistic $S$ is defined as follows:

$$
S = \sum_{k-1}^{n-1}  \sum_{j - k + 1}^{n} \text{sign} (y_{j} - y_{k})
$$ 

Next, we need to compute $\text{Var}(S)$, which depends on the number of tied groups in the data.
Let $g$ be the number of tied groups and $t_{p}$ be the number of observations in the $p$-th group.

$$\text{Var}(S) = \frac{1}{18} \left[n(n-1)(2n + 1) - \sum_{p-1}^{g} t_{p}(t_{p} - 1)(2t_{p} + 5) \right]$$

Then, compute the MK test statistic, $Z_{MK}$, as follows:

$$
Z_{MK} = \begin{cases}
\frac{S-1}{\sqrt{\text{Var}(S)}} &\text{if} \, S > 0 \\[5pt]
0 &\text{if} \, S = 0 \\[5pt]
\frac{S+1}{\sqrt{\text{Var}(S)}} &\text{if} \, S < 0
\end{cases}
$$ 

For a two-sided test, we reject the null hypothesis if $|Z_{MK}| \geq Z_{1 - (\alpha/2) }$ and conclude that there is a statistically significant monotonic trend in the data.

---

- https://vsp.pnnl.gov/help/vsample/design_trend_mann_kendall.htm

### Spearman Test

The **Spearman Test** is used to identify autocorrelation in a time series $y_{t}$.
A **Significant Lag** is a number $i$ such that the correlation between $y_{t}$ and $y_{t-i}$ is statistically significant. The **Greatest Significant Lag** is the  largest $i$ such that all  $j \leq i$ are  significant lags.

- Null Hypothesis: The greatest significant lag is $0$.
- Alternative Hypothesis: The greatest significant lag is greater than  $0$.

To carry out the Spearman test, we use the following procedure:

1. Compute Spearman's correlation coefficient $\rho_{i}$ for $y_{t}$ and $y_{t-i}$ for all $0 \leq  i <  n$.
2. Determine the $p$-value $p_{i}$ for each correlation coefficient $\rho _{i}$.
3. Iterate through $p_{i}$ to find the largest $i$ such that $p_{j} \leq  \alpha$ for all $j \leq i$.
4. The value of $i$ found in (3) is the greatest significant lag at confidence level  $\alpha$.

**Remark**: To compute the $p$-value of a correlation coefficient $\rho _{i}$, first compute: 

$$
t_{i}= \rho_{i} \sqrt{\frac{n-2}{1 - \rho _{i}^2}}
$$ 

Then, the test statistic $t_{i}$ has the $t$-distribution with  $n-2$ degrees of freedom.


---

- https://en.wikipedia.org/wiki/Autocorrelation
- https://en.wikipedia.org/wiki/Spearman%27s_rank_correlation_coefficient

### Block-Bootstrap Mann-Kendall (BB-MK) Test

The **BB-MK Test** is used to assess whether there is a statistically significant monotonic trend in a time series. Unlike the MK test, the BB-MK test is robust under autocorrelation. 

- Null Hypothesis: There is no monotonic trend.
- Alternative Hypothesis: There is a monotonic upwards or downwards trend.

To carry out the BB-MK test, we rely on the results of the MK test and Spearman test.

1. Compute the MK test statistic.
2. Find the greatest significant lag $k$ using the Spearman test.
3. Resample from the original time series in blocks of size $k+1$, without replacement. 
4. Estimate the MK test statistic for each bootstrapped sample.
5. Derive the empirical distribution of the MK test statistic from the bootstrapped statistics.
6. Estimate the significance of the observed test statistic using the empirical distribution. 

### Phillips-Perron (PP) Test

The **PP Test** is used to identify if an autoregressive time series has a **Unit Root**.
Precisely, the autoregressive time series $y_{t} = \mu  + \alpha t + \rho y_{t-1} + \epsilon_{t}$ has a unit root if $\rho  = 1$.

- Null Hypothesis: The time series has a unit root ($\rho  = 1$).
- Alternative Hypothesis: The time series does not have a unit root ($\rho  < 1$ ).

This test is implemented using R package aTSA with the following settings:

- `lag.short = TRUE`, since AMS data has minimal autocorrelation.
- We consider `type3` results since we are assuming the presence of a trend.

---

- https://cran.r-project.org/web/packages/aTSA/index.html
- https://www.rdocumentation.org/packages/aTSA/versions/3.1.2.1/topics/pp.test
- https://www.mathworks.com/help/econ/pptest.html

### Kwiatkowski–Phillips–Schmidt–Shin (KPSS) Test

The **KPSS Test** is used to identify if an autoregressive time series has a *unit root*. 
Precisely, the autoregressive time series shown below has unit root if $\sigma ^2 > 0$:

$$
\begin{aligned}
y_{t} &= \mu_{t} + \alpha t + \epsilon _{t} \\[5pt]
\mu_{t} &= \mu _{t-1} + a_{t} \\[5pt]
a_{t} &\sim \mathcal{N}(0, \sigma ^2)
\end{aligned}
$$ 

Note that if $\sigma^2 = 0$, then $\mu_{t}$ is constant and $y_{t} = \mu_{t} + \alpha t + \epsilon _{t}$ is stationary.

- Null Hypothesis: The time series does not have a unit root ($\rho < 1$).
- Alternative Hypothesis: The time series has a unit root ($\rho = 1$).

This test is implemented using R package aTSA with the following settings:

- `lag.short = TRUE`, since AMS data has minimal autocorrelation.
- We consider `type3` results since we are assuming the presence of a trend.

---

- https://cran.r-project.org/web/packages/aTSA/index.html
- https://www.rdocumentation.org/packages/aTSA/versions/3.1.2.1/topics/kpss.test
- https://www.mathworks.com/help/econ/kpsstest.html

## 3: Identification of Trends in AMS Variance

### White Test

The **White Test** is used to detect changes in the variance of a time series.

- Null Hypothesis: The variance of the time series is constant (**Homoskedasticity**).
- Alternative Hypothesis: Not the null hypothesis (**Heteroskedasticity**).


Consider a simple linear regression model:

$$
y_{i} = \beta _{0} + \beta _{1} x_{i} + \epsilon _{i}
$$ 

Use ordinary least squares to fit the model. Then compute the squared residuals:

$$
\hat{\epsilon}_{i}^2 = (y_{i} - \hat{y}_{i})^2
$$ 

Next, fit an auxillary regression model to the squared residuals.
This model should include each regressor, the square of each regressor, and the cross products between all regressors.
Since $x$ is our only regressor,

$$
\hat{\epsilon }_{i}^2 = \alpha _{0} + \alpha _{1}x_{i} + \alpha _{2}x_{i}^2 + u_{i}
$$ 

Next, we compute the [coefficient of determination](https://en.wikipedia.org/wiki/Coefficient_of_determination) $R^2$ for the auxillary model. 
The test statistic is $nR^2 \sim \chi_{d}^2$, where $n$ is the number of observations and $d = 2$ is the number of regressors, excluding the intercept.
If $nR^2 > \chi_{1-\alpha }$, we reject the null hypothesis and conclude that the time series exhibits heteroskedasticity.

---

- https://www.numberanalytics.com/blog/white-test-deep-dive
- Marno Verbeek, A Guide to Modern Econometrics (2004)
- William H. Greene, Econometric Analysis, 5th Edition (2002)

### Moving-Window Mann-Kendall (MW-MK) Test

The **Moving-Window Mann-Kendall Test** (MW-MK) is used to detect significant trends in the variance of a time series.
First, we need to compute a time series of variances using a moving window:

1. Set the length of the moving window $w$ and the step size $s$.
2. Compute the standard deviation over indices $[1, w]$. 
3. Move the window forward by $s$. 
4. Check if the right boundary is beyond the end of the data. If not, go to (5).
5. Compute the standard deviation again. Return to (3).

Then perform the Mann-Kendall Test (see above) on the time series of variances.

## Trend Estimation

### Sen's Trend Estimator

**Sen's Trend Estimator** is used to estimate the slope of a regression line. Unlike [Least Squares](https://en.wikipedia.org/wiki/Least_squares), Sen's trend estimator is robust to outliers since it uses a non-parametric approach. To compute Sen's trend estimator we use the following procedure:

1. Iterate over all pairs of data points $(x_{i}, y_{i})$ and $(x_{j}, y_{j})$.
2. If $x_{i} \neq  x_{j}$, compute the slope $(y_{j} - y_{i})/(x_{j} - x_{i})$ and add it to a list $S$.
3. Sen's trend estimator $\hat{m}$ is the median of $S$.

After computing $\hat{m}$, we can estimate the $y$-intercept $b$ by the median of $y_{i} - \hat{m}x_{i}$ for all $i$.
