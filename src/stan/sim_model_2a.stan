// Generate Data 2a
transformed data {
  real alpha0 = 1.5
  int N_age = 2;
  vector alpha = [0.25, -0.25]';

  real beta = -2;
  
  real<lower=0> sigma = 0.5;
  int N_prime = 100;
  int age_prime[N_prime];

  for (n in 1:N_prime)
    age_prime[n] = categorical_rng([0.5, 0.5]');
}

