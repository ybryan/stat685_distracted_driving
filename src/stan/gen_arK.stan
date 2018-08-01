data {
  int<lower=0> N;
}

generated quantities {
  real alpha = 1.825;
  real<lower=0> rho = fabs(normal_rng(0, 0.324));
  real<lower=0> sigma = fabs(normal_rng(0.2, 0.1));
  real y_ppc[N];

  y_ppc[1] = alpha;
  for (n in 2:N) {
    y_ppc[n] = normal_rng(alpha + rho * y_ppc[n - 1], sigma);
  }
}
