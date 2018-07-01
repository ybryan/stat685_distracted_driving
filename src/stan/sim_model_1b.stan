// Generate Data 1b
// fit <- stan(model_file="generate_data_1b.stan", iter=100, warmup=0, algorithm="Fixed_param")
transformed data {
  real alpha = 1.825;
  real beta = -2;
  real<lower=0> sigma = 0.5;
}

generated quantities {
  real x = normal_rng(2, 1);
  real log_y = normal_rng(beta * x + alpha, sigma);
}

