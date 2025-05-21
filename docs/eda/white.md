# White Test

The **White Test** is used to detect changes in the variance of a time series.

- Null hypothesis: The variance of the time series is constant (homoskedasticity).
- Alternative hypothesis: The variance of the time series is time-dependent (heteroskedasticity).

Consider a simple linear regression model:

$$y_{i} = \beta_{0} + \beta_{1} x_{i} + \epsilon_{i}$$

Use ordinary least squares to fit the model. Then compute the squared residuals:

$${\hat{\epsilon}}_{i}^{2} = (y_{i} - \hat{y}_{i})^{2}$$

Next, fit an auxillary regression model to the squared residuals.
This model should include each regressor, the square of each regressor, and the cross products between all regressors.
Since $x$ is our only regressor,

$${\hat{\epsilon}}_{i}^{2} = \alpha_{0} + \alpha_{1}x_{i} + \alpha_{2}x_{i}^{2} + u_{i}$$

Next, we compute the [coefficient of determination](https://en.wikipedia.org/wiki/Coefficient_of_determination) $R^2$ for the auxillary model.
The test statistic is $nR^2 \sim \chi_{d}^2$, where $n$ is the number of observations and $d = 2$ is the number of regressors, excluding the intercept.
If $nR^2 > \chi_{1-\alpha }$, we reject the null hypothesis and conclude that the time series exhibits heteroskedasticity.

For more information, the following sources may be useful:

- [White Test Deep Dive](https://www.numberanalytics.com/blog/white-test-deep-dive)
- Marno Verbeek, A Guide to Modern Econometrics (2004)
- William H. Greene, Econometric Analysis, 5th Edition (2002)
