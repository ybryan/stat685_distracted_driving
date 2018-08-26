data {
  int<lower=0> N;                   // # distance points (equally spaced)
  int<lower=0> N_texting;           // # texting states (2)
  int<lower=1, upper=2> texting[N]; // vector of texting indicators (1 = not texting, 2 texting)
}
generated quantities {
  real mu = normal_rng(-2, 0.5);                    // mean log volatility: not texting is baseline
  real<lower=-1, upper=1> phi = uniform_rng(-1, 1); // persistence of volatility
  real<lower=0> sigma = fabs(normal_rng(0, 1));     // white noise shock scale
  real delta_texting = fabs(normal_rng(0, 0.5));    // effect of texting
  vector[N] h;                                      // log volatility at distance n
  vector[N] y;                                      // mean corrected return at time n
  
  h[1] = normal_rng(mu, sigma / sqrt(1 - phi * phi));
  for (n in 2:N) {
    h[n] = normal_rng(mu + delta_texting * (texting[n] - 1) 
            + phi * (h[n - 1] - mu), 
            sigma);
  }
  for (n in 1:N) {
    y[n] = normal_rng(0, exp(h[n] / 2));
  }
}
