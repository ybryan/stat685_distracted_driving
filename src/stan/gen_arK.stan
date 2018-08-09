data {
  int<lower=0> N;
}

generated quantities {
  real alpha = normal_rng(0, 1);
  real<lower=0, upper=1> rho = uniform_rng(0, 1);
  real<lower=0> sigma = fabs(normal_rng(0, 1));
  
  real y_ppc[N];

  y_ppc[1] = 1.825;
  for (n in 2:N) {
    y_ppc[n] = normal_rng(alpha + rho * y_ppc[n - 1], sigma);
  }
}
