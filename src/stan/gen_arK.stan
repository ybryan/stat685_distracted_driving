data {
  int<lower=0> N;
}

generated quantities {
  real alpha = 1.825;
  real rho = 0.8;
  real<lower=0> sigma = .2;
  
  real y_ppc[N];

  y_ppc[1] = 1.825;
  for (n in 2:N) {
    y_ppc[n] = normal_rng(alpha + rho * y_ppc[n - 1], sigma);
  }
}
