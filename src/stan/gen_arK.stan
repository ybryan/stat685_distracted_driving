data {
  int<lower=0> N;
}

generated quantities {
  real alpha = 0.25;
  real<lower=0, upper=1> rho = beta_rng(1.5, 1.5);
  real<lower=0> sigma = 0.2;
  
  real y_ppc[N];

  y_ppc[1] = 1.825;
  for (n in 2:N) {
    y_ppc[n] = normal_rng(alpha + rho * y_ppc[n - 1], sigma);
  }
}
