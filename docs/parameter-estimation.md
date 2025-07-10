# Parameter Estimation

This sub-module estimates parameters for both S-FFA and NS-FFA models. In NS-FFA, it involves estimating regression coefficients for time-varying parameters and constants.

The framework supports three estimation methods:

1. L-moments
2. Maximum Likelihood (MLE)
3. Generalized Maximum Likelihood (GMLE)

> **Note**: We adopt the GEV distribution convention from Coles (2001)[^1], where a **positive** shape parameter $\kappa$ indicates a heavy tail. This differs from the sign convention in the `lmom` R package, so $\kappa$ is sometimes inverted for consistency.

[^1]: Coles, S. (2001). *An introduction to statistical modeling of extreme values*. Springer.

## L-Moments

The L-moments method is implemented for parameter estimation for all distributions in S-FFA.

This method uses the sample L-moments ($l_1$, $l_2$) and L-moment ratios ($t_3$, $t_4$) to estimate parameters. For more information about L-moments, see [here](model-selection.md#an-introduction-to-l-moments).

We use the [**lmom** R CRAN package](https://cran.r-project.org/web/packages/lmom/lmom.pdf), which wraps classic Fortran routines by J.R.M. Hosking[^2].

> **Warning**: L-moment-based estimates can yield distributions which do not have support at small values, although this is typically not an issue for quantile estimation in the range of mid- to high-return periods.

[^2]: https://lib.stat.cmu.edu/general/lmoments

## Maximum Likelihood Estimation (MLE)

MLE is implemented for all statistical models in S-FFA (for all distributions) and NS-FFA (for all distributions with time-varying location and/or scale parameters).

### Two-Parameter Distributions --> This goes to Model selection

For a two-parameter distribution `XXX`, we use three different models:

1. `XXX` is the stationary model.
2. `XXX10` has a trend in the location parameter $\mu$.
3. `XXX11` has a trend in the location $\mu$ and the scale $\sigma$.

Shown below is a table summarizing these three models:

| Feature              | `XXX`    | `XXX10`          | `XXX11`                |
| -------------------- | -------- | ---------------- | ---------------------- |
| Location $\mu$       | constant | $\mu_0 + \mu_1z$ | $\mu_0 + \mu_1z$       |
| Scale $\sigma$       | constant | constant         | $\sigma_0 + \sigma_1z$ |
| Number of Parameters | 2        | 3                | 4                      |

For all distributions below, let $x$ be a vector of data with elements $x_{1}, \dots, x_{n}$.

#### Gumbel (GUM) Distribution

Its probability density function (PDF) is:

$$
f(x_{i} : \mu, \sigma) = \frac{1}{\sigma} \exp \left(-z_{i} - e^{-z_{i}}\right) , \quad
z_{i} = \frac{x_{i} - \mu}{\sigma }
$$

Therefore, its Log-likelihood function is defined as follows:

$$
\ell(x:\mu, \sigma) = \sum_{i=1}^{n} \left[-\ln \sigma - z_{i} - e^{-z_{i}} \right]
$$

#### Normal (NOR) Distribution

Its probability density function (PDF) is:

$$
f(x_{i} : \mu, \sigma) = \frac{1}{\sigma \sqrt{2\pi }}e^{-z_{i}^2/2} , \quad
z_{i} = \frac{x_{i} - \mu}{\sigma }
$$

Therefore, its Log-likelihood function is defined as follows:

$$
\ell(x:\mu, \sigma) = \sum_{i=1}^{n} \left[-\ln (\sigma \sqrt{2\pi }) - \frac{z_{i}^2}{2} \right]
$$

#### Log-Normal (LNO) Distribution

Since:

$$
\text{Data} \sim \text{LNO} \Leftrightarrow \ln (\text{Data}) \sim \text{NOR}
$$

We use the change of variables formula, which states that:

$$
\ell_{\text{LNO}}(x ; \mu, \sigma) 
= \ell_{\text{NOR}}(\ln x ; \mu , \sigma) \left|\frac{d}{dx} \ln  x\right| 
= \frac{\ell_{\text{NOR}}(\ln x ; \mu , \sigma)}{x}  
$$ 


### Three Parameter Distributions

For a three-parameter distribution `XXX`, we use three different models:

1. `XXX` is the stationary model.
2. `XXX100` has a trend in the location parameter $\mu$.
3. `XXX110` has a trend in the location $\mu$ and the scale $\sigma$.

Shown below is a table summarizing these three models:

| Feature              | `XXX`    | `XXX100`         | `XXX110`               |
| -------------------- | -------- | ---------------- | ---------------------- |
| Location $\mu$       | constant | $\mu_0 + \mu_1z$ | $\mu_0 + \mu_1z$       |
| Scale $\sigma$       | constant | constant         | $\sigma_0 + \sigma_1z$ |
| Shape $\kappa$       | constant | constant         | constant               |
| Number of Parameters | 3        | 4                | 5                      |

#### Generalized Extreme Value (GEV) Distribution

Its probability density function (PDF) is as follows (assume $t_{i} > 0)$:

$$
f(x_{i} : \mu, \sigma, \kappa) = \frac{1}{\sigma}t_{i}^{-1 - (1/\kappa)} \exp (-t_{i}^{-1/\kappa}), \quad
t_{i} = 1 + \kappa \left(\frac{x_{i} - \mu }{\sigma } \right)
$$

Therefore, its Log-likelihood function is defined as follows:

$$
\ell(x:\mu, \sigma, \kappa) = \sum_{i=1}^{n} \left[-\ln \sigma - \left(1 + \frac{1}{\kappa }\right) \ln t_{i} - t_{i}^{-1/\kappa}\right]
$$

#### Generalized Logistic (GLO) Distribution

Its probability density function (PDF) is as follows (assume $t_{i} > 0)$:

$$
f(x_{i} : \mu , \sigma , \kappa ) = \frac{1}{\sigma }t_{i}^{(1/\kappa) - 1} \left[1 + t_{i}^{1/\kappa}\right]^{-2}, \quad
t_{i} = 1 - \kappa \left(\frac{x_{i} - \mu }{\sigma }\right)
$$

Therefore, its Log-likelihood function is defined as follows:

$$
\ell(x:\mu, \sigma, \kappa) = \sum_{i=1}^{n} \left[-\ln \sigma + \left(\frac{1}{\kappa }-1\right) \ln t_{i} - 2 \ln \left(1 + t_{i}^{1/\kappa }\right) \right]
$$

#### Generalized Normal (GNO) Distribution

Its probability density function (PDF) is as follows (assume $t_{i} > 0)$:

$$
f(x_{i} : \mu , \sigma , \kappa ) = \frac{1}{\sigma \sqrt{2\pi }} t_{i}^{-1} \exp \left[-\frac{(\ln t_{i})^2}{2\kappa ^2}\right], \quad
t_{i} = 1 - \kappa \left(\frac{x - \mu }{\sigma }\right)
$$

Therefore, its Log-likelihood function is defined as follows:

$$
\ell(x:\mu, \sigma, \kappa) = \sum_{i=1}^{n} \left[- \ln (\sigma \sqrt{2\pi }) - \ln t_{i} - \frac{(\ln t_{i})^2}{2\kappa ^2}\right]
$$

#### Pearson Type III (PE3) Distribution

Its probability density function (PDF) is as follows:

$$
\begin{aligned}
f(x_{i} : \mu , \sigma , \kappa ) = \frac{(x_{i} - \xi)^{\alpha  - 1}e^{-(x_{i} - \xi )/\beta }}{\beta ^{\alpha } \Gamma (\alpha )} \\[5pt]
\alpha = \frac{4}{\kappa^2}, \quad
\beta = \frac{\sigma |\kappa|}{2}, \quad
\xi  = \mu  - \frac{2\sigma }{\kappa }
\end{aligned}
$$

Therefore, its Log-likelihood function is:

$$
\ell(x:\mu, \sigma, \kappa) = \sum_{i=1}^{n} \left[(\alpha  - 1) \ln |x_{i} - \xi | - \frac{|x_{i} - \xi  |}{\beta } - \alpha \ln\beta  - \ln \Gamma (\alpha )\right]
$$

#### Log-Pearson Type III (LP3) Distribution

Since:

$$
\text{Data} \sim \text{LP3}  \Leftrightarrow \ln (\text{Data}) \sim \text{PE3}
$$

We use the change of variables formula, which states that:

$$
\ell_{\text{LP3}}(x ; \mu, \sigma, \kappa) 
= \ell_{\text{PE3}}(\ln x ; \mu , \sigma, \kappa ) \left|\frac{d}{dx} \ln  x\right| 
= \frac{\ell_{\text{PE3}}(\ln x ; \mu , \sigma, \kappa )}{x}  
$$ 

#### Weibull (WEI) Distribution

Its probability density function (PDF) is as follows for $x_{i} > \mu$:

$$
f(x_{i} : \mu, \sigma, \kappa) = \frac{\kappa}{\sigma }\left(\frac{x_{i} - \mu}{\sigma }\right)^{\kappa -1} \exp \left( - \left(\frac{x_{i} - \mu}{\sigma }\right)^{\kappa } \right)
$$

Therefore, its Log-likelihood function is defined as follows:

$$
\ell(x:\mu, \sigma, \kappa) = \sum_{i=1}^{n} \left[\ln \kappa - \kappa \ln \sigma +(\kappa -1)\ln (x_{i}-\mu ) - \left(\frac{x_{i} - \mu }{\sigma }\right) ^{\kappa } \right]
$$

## Generalized Maximum Likelihood (GMLE)

GMLE is used for GEV models when incorporating **prior knowledge** of the shape parameter $\kappa$ using Bayesian reasoning via [maximum a posteriori estimation](https://en.wikipedia.org/wiki/Maximum_a_posteriori_estimation), which maximizes the product of the likelihood and the prior distribution.

Suppose that $\kappa$ is drawn from $K \sim \text{Beta}(p, q)$ where $p$ and $q$ are determined using prior knowledge. The prior PDF $f_{K}(\kappa)$ is shown below, where $B(p, q)$ is the [Beta function](https://en.wikipedia.org/wiki/Beta_function).

$$
f_{K}(\kappa) = \frac{\kappa ^{p - 1}(1 - \kappa)^{q-1}}{B(p, q)}
$$ 

As in the case of regular maximum likelihood estimation, the likelihood function is:

$$
f_{X}(x : \mu, \sigma, \kappa) =\prod_{i=1}^{n} \frac{1}{\sigma}t_{i}^{-1 - (1/\kappa)} \exp (-t_{i}^{-1/\kappa}), \quad
t_{i} = 1 + \kappa \left(\frac{x_{i} - \mu }{\sigma } \right)
$$

As mentioned previously, we want to maximize the product $\mathcal{L} = f_{K}(\kappa)f_{X}(x:\mu ,\sigma ,\kappa)$. 
To ensure numerical stability, we will maximize $\ln  (\mathcal{L})$ instead, which has the following form:

$$
\begin{aligned}
\ln(\mathcal{L}) &= \ln(f_{K}(\kappa)) + \ln(f_{X}(x:\mu ,\sigma ,\kappa )) \\[10pt]
\ln(f_{K}(\kappa)) &= (p - 1)\ln \kappa + (q-1) \ln (1 - \kappa)  - \ln (B(p, q)) \\[5pt]
\ln(f_{X}(x:\mu ,\sigma ,\kappa )) &= \sum_{i=1}^{n} \left[-\ln \sigma - \left(1 + \frac{1}{\kappa }\right) \ln t_{i} - t_{i}^{-1/\kappa}\right]
\end{aligned}
$$
