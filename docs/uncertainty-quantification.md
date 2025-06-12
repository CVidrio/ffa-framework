# Uncertainty Quantification

The FFA framework implements three methods for uncertainty quantification: 

1. Sample bootstrap
2. Regula-Falsi profile likelihood (RFPL)
2. Regula-Falsi generalized profile likelihood (RFGPL)

## Sample Bootstrap

The sample bootstrap is a flexible method for uncertainty quantification that works with all probability models and parameter estimation methods. Let $n$ be the size of the original dataset.

1. Draw $N_{\text{sim}}$ bootstrap samples of size $n$ from the selected probability distribution.
2. Fit a probability distribution to each bootstrap sample. For consistency, we use the same [model selection method](model-selection.md) and [parameter estimation method](parameter-estimation.md) as before.
3. Compute the quantiles for each of the bootstrapped distributions. 
4. Generate confidence intervals using the mean and variance of the bootstrapped quantiles .

## Regula-Falsi Profile Likelihood (RFPL)

Consider a statistical model with parameters $(\theta, \psi_{1}, \dots, \psi_{n})$.
The **Profile Likelihood** for the scalar parameter $\theta$ and vector of nuisance parameters $\psi$ is defined as:

$$
\ell_{p}(\theta) = \max_{\psi } \ell(\theta , \psi)
$$ 

Let $\hat{\theta}$ be MLE of $\theta$.
To find a confidence interval with significance $1-\alpha$, we find the two solutions to the following equation (where $\chi_{1;1-\alpha}^2$ is the $1-\alpha$ quantile of the [Chi-squared distribution](https://en.wikipedia.org/wiki/Chi-squared_distribution)):

$$
2[\ell_{p}(\hat{\theta }) - \ell_{p}(\theta )] = \chi_{1;1-\alpha }^2
$$ 

This is equivalent to finding the two points $\theta_{L} < \hat{\theta} < \theta_{U}$ such that the profile log-likelihood has dropped by $\chi _{1;1-\alpha }^2 / 2$.
To find $\theta_{L}$ and $\theta_{U}$ we find the roots of $f(\theta)$ using a secant-based algorithm.

$$
f(\theta) = \ell_{p}(\theta) - \left[\ell_{p}(\hat{\theta}) - \frac{\chi_{1;1-\alpha }^2}{2}\right]
$$ 

In the FFA framework, we compute the profile likelihood of each quantile $y$ by reparameterizing the location parameter $\mu$.
Let $q(p, \mu, \psi)$ be a function that takes an exceedance probability $p$, location parameter $\mu$ and nuisance parameters $\psi$ and returns a quantile $y$.
All quantile functions satisfy: 

$$
y = q(p, \mu, \psi) = \mu + q(p, 0, \psi)
$$

Therefore, we can define $\mu$ as a function of $(p, y, \psi)$ as shown below:

$$
\mu = y - q(p, 0, \psi)
$$ 

Then, we compute the profile likelihood $\ell_{p}(y)$ by evaluating $\mu(p, y, \psi)$ using the formula shown above and substituting $\mu$ into the log-likelihood functions listed [here](parameter-estimation.md#maximum-likelihood-mle).

### Initialization Algorithm

### Iteration Algorithm

Compute the following:

$$
c = \frac{af(b) - bf(a)}{f(b) - f(a)}
$$ 

Evaluate $\ell_{p}(c)$ by maximizing over the nuisance parameters $\psi$, then find $f(c)$.

If $|f(c)| < \epsilon$ (where $\epsilon$ is small), then stop. $c$ is the confidence interval bound.

Otherwise, assign $a = c$ if $f(c) < 0$ and $b = c$ if $f(c) > 0$.

## Regula-Falsi Generalized Profile Likelihood (RFGPL)
