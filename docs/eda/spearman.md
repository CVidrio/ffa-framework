# Spearman Test

The **Spearman Test** is used to identify autocorrelation in a time series $y_{t}$.
A *significant lag* is a number $i$ such that the correlation between $y_{t}$ and $y_{t-i}$ is statistically significant.
The *least insignificant lag* is the largest $i$ such that all $j < i$ are significant lags.

- Null hypothesis: The least insignificant lag is $0$.
- Alternative hypothesis: The least insignificant lag is greater than $0$.

To carry out the Spearman test, we use the following procedure:

1. Compute Spearman's correlation coefficient $\rho_{i}$ for $y_{t}$ and $y_{t-i}$ for all $0 \leq  i <  n$.
2. Determine the $p$-value $p_{i}$ for each correlation coefficient $\rho _{i}$.
3. Iterate through $p_{i}$ to find the largest $i$ such that $p_{j} \leq  \alpha$ for all $j \leq i$.
4. The value of $i$ found in (3) is the least insignificant lag at confidence level $\alpha$.

**Remark**: To compute the $p$-value of a correlation coefficient $\rho _{i}$, first compute:

$$
t_{i}= \rho_{i} \sqrt{\frac{n-2}{1 - \rho _{i}^2}}
$$

Then, the test statistic $t_{i}$ has the $t$-distribution with $n-2$ degrees of freedom.

For more information, see the Wikipedia pages on [Autocorrelation](https://en.wikipedia.org/wiki/Autocorrelation) and [Spearman's Correlation Coefficient](https://en.wikipedia.org/wiki/Spearman%27s_rank_correlation_coefficient).

