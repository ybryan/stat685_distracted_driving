// AR(K)

data {
  int<lower=0> K;
  int<lower=0> T;
  real y[T];
}

parameters {
  real<lower=1.8, upper=1.9> alpha;
  real beta[K];
  real<lower=0> sigma;
}

model {
  vector[T] mu = rep_vector(alpha, T);
  for (t in (K + 1):T)
    for (k in 1:K) mu[t] = mu[t] + beta[k] * y[t - k];

  alpha ~ normal(1.825, .05);
  beta ~ normal(0, 1);
  sigma ~ normal(0, 2);

  y[1:K] ~ normal(0, 10);
  y[(K + 1):T] ~ normal(mu[(K + 1):T], sigma);
}

generated quantities {
  real y_ppc[T] = y;

  for (t in (K + 1):T) {
    real mu = alpha;

    // Note the use of actual data as we just want
    // to check the one-step prediction here
    for (k in 1:K)
      mu = mu + beta[k] * y[t - k];

    y_ppc[t] = normal_rng(mu, sigma);
  }
}
