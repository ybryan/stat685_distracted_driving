// Generate Data 2b
transformed data {
  real alpha0 = 1.825;
  int N_age = 2;
  vector[2] alpha = [0.25, -0.25]';
  real beta = -2;
  real<lower=0> sigma = 0.5;
 }

generated quantities {
  int<lower=1, upper=N_age> age = categorical_rng([0.5, 0.5]');
  real x = normal_rng(2, 1);
  real log_y = normal_rng(beta * x + alpha[age] + alpha0, sigma);
}

