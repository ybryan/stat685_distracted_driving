// Homogeneous population between two age cohorts
// fit_homo <- stan(model_file="sim_model_1a.stan", iter=1, warmup=0, algorithm="Fixed_param")
transformed data {
  int N_prime = 50;
  real alpha = -1.5;
  real beta = 0.25;
  real<lower=0> sigma = 0.5;
}

generated quantities {
  int N = N_prime;
  real x[N_prime];
  real log_y[N_prime];

  for (n in 1:N) {
    x[n] = normal_rng(5, 1);
    log_y[n] = normal_rng(beta * x[n] + alpha, sigma);
  }
}