# Parameter Estimation

The FFA framework implements three methods for parameter estimation:

1. L-moments
2. Maximum likelihood (MLE)
3. Generalized maximum likelihood (GMLE)

**Note**: The parameterization used for the GEV distributions is different from the parameterization used by the `lmom` library. 
In particular, the sign of the shape parameter is inverted for consistency with "Regional Frequency Analysis" (Hosking, 1997).

## L-Moments

The method estimates parameter values based on the sample L-moments $l_{1}$, $l_{2}$ and the sample L-moment ratios $t_{3}$, $t_{4}$.
For more information about L-moments, see [here](model-selection.md#an-introduction-to-l-moments).
The parameter estimation methods are based on [these](https://lib.stat.cmu.edu/general/lmoments) Fortran routines by J.R.M. Hosking.
In particular, we use the [lmom](https://cran.r-project.org/web/packages/lmom/lmom.pdf) CRAN package, which implements the aformentioned Fotran routines.

**Warning**: L-moments parameter estimation can yield distributions which do not have support at small values.
This is generally not an issue, since we are only interested in the higher quantiles of the distrbution.
However, it is important to remember that the probability distributions produced by L-moments *should not* be used to predict future streamflow data in general.

## Maximum Likelihood (MLE)

For all distributions below, let $x$ be a vector of data with elements $x_{1}, \dots, x_{n}$.

### Two Parameter Distributions

For a two-parameter distribution `XXX`, we use three different models:

1. `XXX` is the standard model with no non-stationarity.
2. `XXX10` has a trend in the location parameter $\mu$.
3. `XXX11` has a trend in the location $\mu$ and the scale $\sigma$.

Shown below is a table summarizing these three models:

| Feature              | `XXX`    | `XXX10`          | `XXX11`                |
| -------------------- | -------- | ---------------- | ---------------------- |
| Location $\mu$       | constant | $\mu_0 + \mu_1z$ | $\mu_0 + \mu_1z$       |
| Scale $\sigma$       | constant | constant         | $\sigma_0 + \sigma_1z$ |
| Number of Parameters | 2        | 3                | 4                      |

#### Gumbel (GUM) Distribution

The probability density function (PDF) of the Gumbel distribution is as follows:

$$
f(x_{i} : \mu, \sigma) = \frac{1}{\sigma} \exp \left(-z_{i} - e^{-z_{i}}\right) , \quad
z_{i} = \frac{x_{i} - \mu}{\sigma }
$$

Therefore, the Log-likelihood function is defined as follows:

$$
\ell(x:\mu, \sigma) = \sum_{i=1}^{n} \left[-\ln \sigma - z_{i} - e^{-z_{i}} \right]
$$

#### Normal (NOR) Distribution

The probability density function (PDF) of the Normal distribution is as follows:

$$
f(x_{i} : \mu, \sigma) = \frac{1}{\sigma \sqrt{2\pi }}e^{-z_{i}^2/2} , \quad
z_{i} = \frac{x_{i} - \mu}{\sigma }
$$

Therefore, the Log-likelihood function is defined as follows:

$$
\ell(x:\mu, \sigma) = \sum_{i=1}^{n} \left[-\ln (\sigma \sqrt{2\pi }) - \frac{z_{i}^2}{2} \right]
$$

#### Log-Normal (LNO) Distribution

To perform MLE using the LNO distribution, we use the fact that:

$$
\text{Data} \sim \text{LNO} \Leftrightarrow \ln (\text{Data}) \sim \text{NOR}
$$

Precisely, we require the change of variables formula, which states that:

$$
\ell_{\text{LNO}}(x ; \mu, \sigma) 
= \ell_{\text{NOR}}(\ln x ; \mu , \sigma) \left|\frac{d}{dx} \ln  x\right| 
= \frac{\ell_{\text{NOR}}(\ln x ; \mu , \sigma)}{x}  
$$ 


### Three Parameter Distributions

For a three-parameter distribution `XXX`, we use three different models:

1. `XXX` is the standard model with no non-stationarity.
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

The probability density function (PDF) of the GEV distribution is as follows (assume $t_{i} > 0)$:

$$
f(x_{i} : \mu, \sigma, \kappa) = \frac{1}{\sigma}t_{i}^{-1 - (1/\kappa)} \exp (-t_{i}^{-1/\kappa}), \quad
t_{i} = 1 + \kappa \left(\frac{x_{i} - \mu }{\sigma } \right)
$$

Therefore, the Log-likelihood function is defined as follows:

$$
\ell(x:\mu, \sigma, \kappa) = \sum_{i=1}^{n} \left[-\ln \sigma - \left(1 + \frac{1}{\kappa }\right) \ln t_{i} - t_{i}^{-1/\kappa}\right]
$$

#### Generalized Logistic (GLO) Distribution

The probability density function (PDF) of the GLO distribution is as follows (assume $t_{i} > 0)$:

$$
f(x_{i} : \mu , \sigma , \kappa ) = \frac{1}{\sigma }t_{i}^{(1/\kappa) - 1} \left[1 + t_{i}^{1/\kappa}\right]^{-2}, \quad
t_{i} = 1 - \kappa \left(\frac{x_{i} - \mu }{\sigma }\right)
$$

Therefore, the Log-likelihood function is defined as follows:

$$
\ell(x:\mu, \sigma, \kappa) = \sum_{i=1}^{n} \left[-\ln \sigma + \left(\frac{1}{\kappa }-1\right) \ln t_{i} - 2 \ln \left(1 + t_{i}^{1/\kappa }\right) \right]
$$

#### Generalized Normal (GNO) Distribution

The probability density function (PDF) of the GNO distribution is as follows (assume $t_{i} > 0)$:

$$
f(x_{i} : \mu , \sigma , \kappa ) = \frac{1}{\sigma \sqrt{2\pi }} t_{i}^{-1} \exp \left[-\frac{(\ln t_{i})^2}{2\kappa ^2}\right], \quad
t_{i} = 1 - \kappa \left(\frac{x - \mu }{\sigma }\right)
$$

Therefore, the Log-likelihood function is defined as follows:

$$
\ell(x:\mu, \sigma, \kappa) = \sum_{i=1}^{n} \left[- \ln (\sigma \sqrt{2\pi }) - \ln t_{i} - \frac{(\ln t_{i})^2}{2\kappa ^2}\right]
$$

#### Pearson Type III (PE3) Distribution

The probability density function (PDF) of the PE3 distribution is as follows:

$$
\begin{aligned}
f(x_{i} : \mu , \sigma , \kappa ) = \frac{(x_{i} - \xi)^{\alpha  - 1}e^{-(x_{i} - \xi )/\beta }}{\beta ^{\alpha } \Gamma (\alpha )} \\[5pt]
\alpha = \frac{4}{\kappa^2}, \quad
\beta = \frac{\sigma |\kappa|}{2}, \quad
\xi  = \mu  - \frac{2\sigma }{\kappa }
\end{aligned}
$$

Therefore, the Log-likelihood function is defined as follows:

$$
\ell(x:\mu, \sigma, \kappa) = \sum_{i=1}^{n} \left[(\alpha  - 1) \ln |x_{i} - \xi | - \frac{|x_{i} - \xi  |}{\beta } - \alpha \ln\beta  - \ln \Gamma (\alpha )\right]
$$

#### Log-Pearson Type III (LP3) Distribution

To perform MLE using the LP3 distribution, we use the fact that:

$$
\text{Data} \sim \text{LP3}  \Leftrightarrow \ln (\text{Data}) \sim \text{PE3}
$$

Precisely, we require the change of variables formula, which states that:

$$
\ell_{\text{LP3}}(x ; \mu, \sigma, \kappa) 
= \ell_{\text{PE3}}(\ln x ; \mu , \sigma, \kappa ) \left|\frac{d}{dx} \ln  x\right| 
= \frac{\ell_{\text{PE3}}(\ln x ; \mu , \sigma, \kappa )}{x}  
$$ 

#### Weibull (WEI) Distribution

The probability density function (PDF) of the Weibull distribution is as follows for $x_{i} > \mu$:

$$
f(x_{i} : \mu, \sigma, \kappa) = \frac{\kappa}{\sigma }\left(\frac{x_{i} - \mu}{\sigma }\right)^{\kappa -1} \exp \left( - \left(\frac{x_{i} - \mu}{\sigma }\right)^{\kappa } \right)
$$

Therefore, the Log-likelihood function is defined as follows:

$$
\ell(x:\mu, \sigma, \kappa) = \sum_{i=1}^{n} \left[\ln \kappa - \kappa \ln \sigma +(\kappa -1)\ln (x_{i}-\mu ) - \left(\frac{x_{i} - \mu }{\sigma }\right) ^{\kappa } \right]
$$

## Generalized Maximum Likelihood (GMLE)

The generalized maximum likelihood (GMLE) parameter estimation method is used to determine the parameters of the generalized extreme value (GEV) distribution given a prior distribution for the shape parameter $\kappa$.
This method uses [maximum a posteriori estimation](https://en.wikipedia.org/wiki/Maximum_a_posteriori_estimation), which maximizes the product of the likelihood and the prior distribution.

Suppose that $\kappa$ is drawn from a random variable $K \sim \text{Beta}(p, q)$ where $p$ and $q$ are determined using prior knowledge. 
The prior PDF $f_{K}(\kappa)$ is shown below, where $B(p, q)$ is the [Beta function](https://en.wikipedia.org/wiki/Beta_function).

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
