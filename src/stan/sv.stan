data {
  int<lower=0> N;   // # time points (equally spaced)
  vector[N] y;      // mean corrected return at time t
}
parameters {
  real mu;                     // mean log volatility
  real<lower=-1,upper=1> phi;  // persistence of volatility
  real<lower=0> sigma;         // white noise shock scale
  vector[N] h_std;             // std log volatility at time n
}
transformed parameters {
  vector[N] h = h_std * sigma; // now h ~ normal(0, sigma)
  h[1] = h[1] / sqrt(1 - phi * phi); // rescale h[1]
  for (n in 2:N)
    h[n] = mu + phi * (h[n - 1] - mu);
}
model {
  mu ~ normal(0, 1);
  sigma ~ normal(0, 1);
  h_std ~ normal(0, 1);
  y ~ normal(0, exp(h / 2));
}

