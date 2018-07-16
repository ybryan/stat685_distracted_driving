// Model 1a: Using log y with iteration
data {
  int<lower=1> N;     // Number of individuals
  vector[N] x;
  vector[N] log_y;
}

parameters {
  real<lower=1.8, upper=1.9>alpha0;
  real beta;
  real<lower=0> sigma;
}

model {
  alpha0 ~ normal(1.825, .1);
  beta ~ normal(0, 5);
  sigma ~ normal(0, 5);

  log_y ~ normal(beta * x + alpha0, sigma);
}

generated quantities {
  real ave_log_y_ppc = 0;
  {
    for (n in 1:N) {
      real log_y_ppc = normal_rng(beta * x[n] + alpha0, sigma);
      ave_log_y_ppc = ave_log_y_ppc + log_y_ppc;
    }

  ave_log_y_ppc = ave_log_y_ppc / N;
  }
}
