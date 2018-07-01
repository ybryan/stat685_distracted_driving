// Generate Data 2a
// fit_hetero <- stan(model_file="generate_data_2a.stan", iter=1, warmup=0, algorithm=Fixed_param)
transformed data {
  real alpha0 = 1.5;
  int N_age = 2;
  vector[2] alpha = [0.25, -0.25]';

  real beta = -2;
  
  real<lower=0> sigma = 0.5;
  int N_prime = 100;
  int age_prime[N_prime];

  for (n in 1:N_prime)
    age_prime[n] = categorical_rng([0.5, 0.5]'); // assigns category to each age_prime
}

generated quantities {
  int N = N_prime;
  int<lower=1, upper=N_age> age[N_prime] = age_prime;

  real x[N_prime];
  real log_y[N_prime];

  for (n in 1:N) {
    x[n] = normal_rng(2, 1);
    log_y[n] = normal_rng(beta * x[n] + alpha[age[n]] + alpha0, sigma);
  }
}


