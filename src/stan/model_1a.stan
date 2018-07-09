// Model 1a: Using log y with iteration
data {
  int<lower=1> N;     // Number of individuals
  vector[N] x;
  vector[N] log_y;
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

  log_y ~ normal(beta * x + alpha, sigma);
}

generated quantities {
  real log_y_ppc[N];
  for (n in 1:N)
    log_y_ppc[n] = normal_rng(beta * x[n] + alpha, sigma);
}
