data {
  int<lower=0> N;   // number of observations
  real y[N];        // time series data
}
parameters {
  real<lower=-1,upper=1> rho;   // parameter on lag term
  real alpha;                   // constant term
  real<lower=0> sigma;          // sd of error
}
model {
  // priors
  rho ~ normal(0, 0.5);
  alpha ~ normal(0, 1);

  // likelihood
  for (n in 2:N)
    y[n] ~ normal(alpha + rho * y[n-1], sigma);
}
