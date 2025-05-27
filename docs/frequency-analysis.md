# Frequency Analysis

**Flood Frequency Analysis** (FFA) is the act of using a _fitted probability distribution_ to make predictions about the _frequency_ of extreme streamflow events (i.e. floods).
To do FFA, we require a [probability model](model-selection.md) with [suitably chosen parameters](parameter-estimation.md) based on the data.
This section will assume that these requirements are met.

Typically, we describe the severity of floods in terms of their _return period_.
Suppose we have a flood, which I will refer to as $A$.
If we expect to see a flood _at least as severe as_ $A$ every ten years, then we say that $A$ is a _ten-year flood_.
Since our framework uses _annual_ maximum streamflow data, a ten-year flood corresponds to the $0.90$ quantile of our probability distribution.
Here is a table of the return periods and corresponding quantiles used by default in the FFA framework:

| Return Period | Quantile |
| ------------- | ---------- |
| $2$ Years     | $0.50$     |
| $5$ Years     | $0.80$     |
| $10$ Years    | $0.90$     |
| $20$ Years    | $0.95$     |
| $50$ Years    | $0.98$     |
| $100$ Years   | $0.99$     |

Suppose our fitted probability distribution has cumulative distribution function $F(x)$. 
The function $F(x)$ maps annual maximum streamflow values to quantiles.
However, we want to determine the streamflow from the quantiles, so we use the inverse of the cumulative distribution $F^{-1}(x)$ instead.
The function $F^{-1}(x)$ is also known as the **Quantile Function**.
Quantile functions for the probability distributions used in the FFA framework are implemented in the [lmom](https://cran.r-project.org/web/packages/lmom/lmom.pdf) CRAN package.
