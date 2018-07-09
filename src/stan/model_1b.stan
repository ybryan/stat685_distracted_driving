// Model 1b with lognormal distribution and vectorized
data {
  int<lower=1> N;       // Number of individuals
  vector[N] x;          // Mean pupil dilation for each individual
  vector<lower=0>[N] y; // Standard deviation of lane position for each individual
}

parameters {
  real alpha;
  real beta;
  real<lower=0> sigma;
}

model {
  alpha ~ normal(0, 5);
  beta ~ normal(0, 5);
  sigma ~ normal(0, 5);

  y ~ lognormal(beta * x + alpha, sigma);
}

