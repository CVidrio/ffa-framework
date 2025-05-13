# Unit Root Tests

> "However, while all processes with a unit root will exhibit serial correlation, not all serially correlated time series will have a unit root."

---

Resource: https://web.archive.org/web/20161130133316/http://www.econ.ku.dk/metrics/Econometrics2_05_II/Slides/08_unitroottests_2pp.pdf

Our goal is to distinguish between two important cases:

1. A stationary process with a **Deterministic Trend**.
2. A process with a **Stochastic Trend** (or **Unit Root**).

For all tests, our implicit assumption is that the time series $Y_{t}$ is an [autoregressive model](https://en.wikipedia.org/wiki/Autoregressive_model) (the model for $y_{t}$ shown below is $AR(1)$) with linear deterministic terms $\delta t + \mu$:

$$
\begin{aligned}
y_{t} &= \theta y_{t-1} + \epsilon_{t} \\[5pt]
Y_{t} &= \delta t + \mu + y_{t}
\end{aligned}
$$ 

Here is what each term in the series represents:

- $\delta  t$ is a deterministic **Linear** term.
- $\mu$ is a deterministic **Drift** term.
- $\theta y_{t-1}$ is the stochastic component.
- $\epsilon_{t}$ are IID $\mathcal{N}(0, \sigma ^2)$ error terms.

If $|\theta| < 1$, the process is **Trend-Stationary** (Case 1).  To see this, observe that:

$$
\begin{aligned}
Y_{0} &= \mu  + y_{0} \\[5pt]
Y_{1} &= \delta  + \mu  + \theta y_{0} + \epsilon _{1} \\[5pt]
Y_{2} &= 2\delta  + \mu  + \theta ^2y_{0} + \epsilon_{2} + \theta \epsilon _{1} \\[5pt]
\dots  &= \dots  \\[5pt]
Y_{t} &= \delta t + \mu  + \theta^{t} y_{0} + \epsilon _{t} + \theta \epsilon _{t-1} + \theta^2 \epsilon _{t-2}   + \dots 
\end{aligned}
$$ 

Therefore, the expectation of $Y_{t}$ is:

$$
\mathbb{E}[Y_{t}] = \delta t + \mu  + \theta ^{t}y_{0} \Rightarrow \lim_{t \rightarrow  \infty }  \mathbb{E}[Y_{t}] = \delta  t + \mu 
$$ 

And the variance of $Y_{t}$ is:

$$
\text{Var}\,(Y_{t}) = \text{Var}\,(\epsilon _{t} + \theta \epsilon_{t-1} + \theta ^2\epsilon _{t-2} + \dots ) = \sigma ^2 + \theta ^2\sigma ^2 + \theta ^{4}\sigma ^2 + \dots  = \frac{\sigma^2}{1 - \theta ^2}
$$ 

Conversely, the process is **Non-Stationary** if $\theta  = 1$ (where $\theta$ is the **Unit Root**).

## KPSS Test

The KPSS test assumes **Trend-Stationarity** as the null hypothesis and uses **Non-Stationarity** as the alternative hypothesis. Our autoregressive model is as follows:

$$
\begin{aligned}
Y_{t} &= \delta t + \mu_{t} + \epsilon _{t} \\[5pt]
\mu_{t} &= \mu_{t-1} + v_{t} \\[5pt]
\end{aligned}
$$ 

In this model, $\epsilon_{t}$ is the IID error term, and $v_{t} \sim \mathcal{N}(0, \sigma _{v}^2)$ is the stochastic error term. Under the null hypothesis, $\sigma _{v}^2 = 0$ so that $\mu _{t}$ is constant and $Y_{t}$ is stationary. Under the alternative hypothesis, $\sigma _{v}^2 > 0$, which introduces non-stationarity.
