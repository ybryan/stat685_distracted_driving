data {
  int<lower=0> N;
  int<lower=0> N_texting;              // # texting states (2)
  vector<lower=1, upper=2>[N] texting; // vector of texting indicators (1 = not texting, 2 texting)
  vector[N] y;
}
parameters {
  real<lower=0, upper=1> rho;
  real alpha;                
  real<lower=0> sigma;
  real<lower=0> delta_texting;
}
model {
  alpha ~ normal(0, 1);
  rho ~ uniform(0, 1);
  sigma ~ normal(0, 1);
  delta_texting ~ normal(0, 1);

  y[2:N] ~ normal(alpha + rho * y[1:(N - 1)], sigma + delta_texting * (texting[2:N] - 1));
}
generated quantities {
  vector[N] y_ppc = y;
  for (n in 2:N)
    y_ppc[n] = normal_rng(alpha + rho * y[n-1], sigma + delta_texting * (texting[n] - 1));
}
