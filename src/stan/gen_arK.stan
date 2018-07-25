// AR(K)

data {
  int<lower=0> K;
  int<lower=0> T;
  real y[T];
}

transformed data {
  real alpha = 1.825;
}

generated quantities {
  real beta[K];
  real<lower=0> sigma = fabs(normal_rng(0, 2));
  real y_ppc[T] = y;

  for (k in 1:K) {
    beta[k] = fabs(normal_rng(0, 0.5));
  }

  for (t in (K + 1):T) {
    real mu = alpha;

    for (k in 1:K)
      mu = mu + beta[k] * y[t - k];
    y_ppc[t] = normal_rng(mu, sigma);
  }
}
