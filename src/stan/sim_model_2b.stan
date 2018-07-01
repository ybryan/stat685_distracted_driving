// Generate Data 2b
// fit_hetero <- stan(model_file="generate_data_2b.stan", iter=100, warmup=0, algorithm='Fixed_param')
transformed data {
  real alpha0 = 1.5;
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

