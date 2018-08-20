data {
  int<lower=0> N;           // # distance points
  vector[N] x;              // vector of texting indicators (1 = not texting, 2 texting)
}
transformed data {
  int<lower=0> N_texting;   // # texting states (2)
  vector[2] alpha_texting = [-0.5, 0.5]';
 }

generated quantities {
  real mu = normal_rng(0, 1);                       // mean log volatility
  real<lower=-1, upper=1> phi = uniform_rng(-1, 1); // persistence of volatility
  real<lower=0> sigma = fabs(normal_rng(0, 1));     // white noise shock scale
  vector[N] h;                                      // log volatility at distance n
  vector[N] y;                                      // mean corrected return at time n

  h[1] = normal_rng(mu, sigma / sqrt(1 - phi * phi));
  for (n in 2:N) {
    h[n] = normal_rng(mu + alpha_texting[n] + phi * (h[n - 1] - mu), sigma);
  }
  for (n in 1:N) {
    y[n] = normal_rng(0, exp(h[n] / 2));
  }
}

