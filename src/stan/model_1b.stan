// Model 1b
data {
  int<lower=1> N;     // Number of individuals
  real x[N];          // Mean pupil dilation for each individual
  real<lower=0> y[N]; // Standard deviation of lane position for each individual
}

parameters {
  real alpha;
  real beta;
  real<lower=0> sigma;
}

model {
  alpha ~ normal(0, ?);
  beta ~ normal(0, ?);
  sigma ~ normal(0, ?);

  y ~ lognormal(beta * x + alpha, sigma);
}

