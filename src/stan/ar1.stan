data {
  int<lower=0> N;
  real y[N];
}

parameters {
  real<lower=1.7, upper=1.9> alpha;
  real<lower=0> rho;
  real<lower=0> sigma;
}

model {
  alpha ~ normal(1.825, .05);
  rho ~ normal(0, .329);
  sigma ~ normal(0.2, 0.1);

  for (n in 2:N)
    y[n] ~ normal(alpha + rho * y[n-1], sigma);
}

generated quantities {
  real y_ppc[N] = y;

  for (n in 2:N) {
    real mu = alpha;
    mu = mu + rho * y[n - 1];
    y_ppc[n] = normal_rng(mu, sigma);
  }
}
