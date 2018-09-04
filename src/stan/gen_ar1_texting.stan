data {
  int<lower=0> N;
  int<lower=0> N_texting;           // # texting states (2)
  int<lower=1, upper=2> texting[N]; // vector of texting indicators (1 = not texting, 2 texting)
}

generated quantities {
  real alpha = normal_rng(1.825, 0.25);
  real<lower=0, upper=1> rho = uniform_rng(-1, 1);
  real<lower=0> sigma = fabs(normal_rng(0, 1));
  real delta_texting = normal_rng(0, 0.5);
  
  real y_ppc[N];

  y_ppc[1] = 1.825;
  for (n in 2:N) {
    y_ppc[n] = normal_rng(alpha + rho * y_ppc[n - 1], sigma + delta_texting * (texting[n] - 1));
  }
}
