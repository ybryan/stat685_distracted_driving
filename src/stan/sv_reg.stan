data {
  int<lower=0> N;   // # time points (equally spaced)
  vector[N] y;      // mean corrected return at time t
}
parameters {
  real mu;                     // mean log volatility
  real<lower=-1,upper=1> phi;  // persistence of volatility
  real<lower=0> sigma;         // white noise shock scale
  vector[N] h;                 // log volatility at time
}
model {
  phi ~ uniform(-1, 1);
  sigma ~ normal(0, 1);
  mu ~ normal(0, 1);
  h[1] ~ normal(mu, sigma / sqrt(1 - phi * phi));
  for (t in 2:T)
    h[t] ~ normal(mu + phi * (h[t - 1] -  mu), sigma);
  y ~ normal(0, exp(h / 2));
}

