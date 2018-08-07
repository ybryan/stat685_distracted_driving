data {
  int<lower=0> T;                   // number of data points
  int<lower=1, upper=2> texting[T]; // indication of texting
  real y[T];                        // lane position
}
parameters {
  real mu;                       // average lane position
  real<lower=0> alpha0;          // noise intercept
  vector[2] alpha_texting;       // intercept of texting effect
  real<lower=0,upper=1> alpha1;  // noise slope
}
model {
  mu ~ normal(1.825, 0.5);
  alpha0 ~ exponential(1.273);
  alpha1 ~ beta(2, 2);
  alpha_texting ~ normal(0, 0.5);
  
  for (t in 2:T)
    y[t] ~ normal(mu, sqrt(alpha0 + alpha_texting[texting[t]] + alpha1 * pow(y[t-1] - mu, 2)));
}
generated quantities {
  real y_ppc[T] = y;
  for (t in 2:T)
    y_ppc[t] = normal_rng(mu, sqrt(alpha0 + alpha_texting[texting[t]] + alpha1 * pow(y[t-1] - mu, 2)));
}
