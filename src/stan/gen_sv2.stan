data {
  int<lower=0> N;           // # distance points
  int<lower=0> N_texting; // # texting states (2)
  int<lower=1, upper=2> texting[N]; // vector of texting indicators (1 = not texting, 2 texting)
}
generated quantities {
  real mu = normal_rng(0, 1);                       // mean log volatility
  real<lower=-1, upper=1> phi = uniform_rng(-1, 1); // persistence of volatility
  real<lower=0> sigma = fabs(normal_rng(0, 1));     // white noise shock scale
  vector[N_texting] alpha_texting;                  // effect of normal driving vs texting driving
  vector[N] h;                                      // log volatility at distance n
  vector[N] y;                                      // mean corrected return at time n
  alpha_texting[1] = normal_rng(0, 1);
  alpha_texting[2] = normal_rng(0, 1);

  h[1] = normal_rng(mu, sigma / sqrt(1 - phi * phi));
  for (n in 2:N) {
    h[n] = normal_rng(mu + alpha_texting[texting[n]] + phi * (h[n - 1] - mu), sigma);
  }
  for (n in 1:N) {
    y[n] = normal_rng(0, exp(h[n] / 2));
  }
}