# Model Selection

Model selection takes place in three steps:

1. Select a _metric_ for comparing distributions.
2. Select a probability distribution using the metric chosen in (1).
3. Incorporate the non-stationary structure to obtain a model for FFA.

We use the CRAN package [lmom](https://cran.r-project.org/web/packages/lmom/index.html) to compute the sample L-moments.

## An Introduction to L-Moments

**Definition**: The **$k$-th Order Statistic** of a statistical sample is its $k$-th smallest value.

**Definition**: The **$r$-th Population L-moment** $\lambda_{r}$ is a linear combination of the expectation of the order statistics. Let $X_{k:n}$ be the $k$-th order statistic from a sample of size $n$. Then,

$$
\lambda_{r} = \frac{1}{r} \sum_{k=0}^{r-1} (-1)^{k} \binom{r-1}{k} \mathbb{E}[X_{r-k:r}]
$$

**Definition**: A **Probability Weighted Moment** (PWM) encodes information about a value's position on the cumulative distribution function. The $r$-th PWM, denoted $\beta_{r}$, is:

$$
\beta_{r} = \mathbb{E}[X \cdot  F(X)^{r}]
$$

For an ordered sample $x_{1:n} \leq  \dots  \leq  x_{n:n}$, the sample PWM is often estimated as:

$$
b_{r} = \frac{1}{n} \sum_{i=1}^{r} x_{i:n} \left(\frac{i-1}{n-1}\right) ^{r}
$$

**Remark**: The first four L-moments can be computed as linear combinations of the PWMs:

$$
\begin{aligned}
l_{1} &= b_{0} \\
l_{2} &= 2b_{1} - b_{0} \\
l_{3} &= 6b_{2} - 6b_{1} + b_{0} \\
l_{4} &= 20b_{3} - 30b_{2} + 12b_{1} - b_{0}
\end{aligned}
$$

The L-moments are used to compute the **L-skewness** $t_{3} = l_{3} / l_{2}$ and the **L-kurtosis** $t_{4} = l_{4} / l_{2}$. We can use these two statistics to select a distribution by comparing them to their theoretical values.

## List of Candidate Distributions

Based on the selection metric, we choose a distribution from the following list:

| Distribution              | Abbreviation | Number of Parameters |
| ------------------------- | ------------ | -------------------- |
| Generalized Extreme Value | GEV          | 3                    |
| Generalized Logistic      | GLO          | 3                    |
| Generalized Normal        | GNO          | 3                    |
| (Log) Pearson Type III    | PE3/LP3      | 3                    |
| (Log) Normal              | NOR/LNO      | 2                    |
| Gumbel[^1]                | GUM          | 2                    |
| Logistic                  | LOG          | 2                    |
| Exponential               | EXP          | 1                    |

[^1]: The Gumbel distribution is equivalent to the GEV distribution with $\xi = 0$.

The four-parameter kappa distribution (K4D), generalizes all eight of the distributions above.

**Note**: Probability distributions with less than $3$ parameters have constant L-skewness and L-kurtosis regardless of their parameters. Probability distributions with $3$ parameters have 

## (1) Selection Metrics

### L-Distance

Select the probability distribution by comparing the euclidean distance between the sample L-skewness and sample L-kurtosis $(t_{3}, t_{4})$ and the L-moment ratios for each candidate distribution.

### L-Kurtosis

Select the probability distribution by comparing the sample L-kurtosis $t_{4}$ with the theoretical value for each probability distribution. This method only works with 3-parameter candidate distributions.

### Z-statistic

The Z-statistic selection metric is calculated as follows:

1. Fit the K4D distribution to the sample AMS with sample size $n$, considering its sample L-moment ratios (denoted herein as $t_{r}^{s}$) and $l_{1} = 1$.
2. Generate $N_{\text{sim}}$ synthetic series from the fitted K4D distribution of size $n$.
3. Calculate the L-skewness $t_{3}^{[i]}$ and L-kurtosis $t_{4}^{[i]}$ of each synthetic dataset.
4. Calculate the bias and standard deviation of $t_{4}^{s}$:

$$
B_{4} = N_{\text{sim} }^{-1} \sum_{i = 1}^{N_{\text{sim} }} \left(t_{4}^{[i]} - t_{4}^{s}\right)
$$

$$
\sigma _{4} = \left[(N_{\text{sim} } - 1)^{-1} \left\{\sum_{i - 1}^{N_{\text{sim} }} \left(t_{4}^{[i]} - t_{4}^{s}\right)^2 - N_{\text{sim} } B_{4}^2\right\} \right] ^{\frac{1}{2}}
$$

This method only works with 3-parameter candidate distributions.

## (3) FFA Model
