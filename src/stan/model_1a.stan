// Model 1a
data {
  int<lower=1> N;     // Number of individuals
  real x[N];          // Mean log pupil dilation for each individual
  real log_y[N];      // Log standard deviation of lane position for each individual
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

  log_y ~ normal(beta * x + alpha, sigma);
}

generated quantities {
  real log_y_ppc[N];
  for (n in 1:N)
    log_y_ppc[n] = normal_rng(beta * x + alpha, sigma);
}

