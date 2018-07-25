transformed data {
  real alpha = 1.825;
  real beta = -2;
  real<lower=0> sigma = 0.5;
}

generated quantities {
  real x = normal_rng(5, 2);
  real log_y = normal_rng(beta * x + alpha, sigma);
}

