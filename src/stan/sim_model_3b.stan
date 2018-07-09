// Generate Data 3b
transformed data {
  real alpha0 = 1.825;
  int N_age = 2;
  vector[2] alpha_age = [0.25, -0.25]';
  vector[2] alpha_texting = [0.5, -.5]';
  real beta = -2;
  real<lower=0> sigma = 0.5;
 }

generated quantities {
  int<lower=1, upper=N_age> age = categorical_rng([0.5, 0.5]');
  int<lower=1, upper=2> texting = categorical_rng([0.5, 0.5]');
  real x = normal_rng(2, 1);
  real log_y = normal_rng(beta * x + alpha_age[age] + alpha_texting[texting] + alpha0, sigma);
}
