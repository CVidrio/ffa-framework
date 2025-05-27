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

## Regula-Falsi Generalized Profile Likelihood (RFGPL)
