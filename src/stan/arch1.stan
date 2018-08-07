data {
  int<lower=0> T;
  real y[T];
}
parameters {
  real mu;                       // average lane position
  real<lower=0> alpha0;          // noise intercept
  real<lower=0,upper=1> alpha1;  // noise slope
}
model {
  for (t in 2:T)
    y[t] ~ normal(mu, sqrt(alpha0 + alpha1 * pow(y[t-1] - mu, 2)));
}
generated quantities {
  real y_ppc[T] = y;
  for (t in 2:T)
    y_ppc[t] = normal_rng(mu, sqrt(alpha0 + alpha1 * pow(y_ppc[t-1] - mu, 2)));
}
