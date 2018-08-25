data {
  int<lower=0> T;                   // # distance points (equally spaced)
  int<lower=0> N_texting;           // # texting states (2)
  int<lower=1, upper=2> texting[T]; // vector of texting indicators (1 = not texting, 2 texting)
}
generated quantities {
  real mu = normal_rng(-2, 0.5);                       // mean log volatility: not texting is baseline
  real<lower=-1, upper=1> phi = uniform_rng(-1, 1); // persistence of volatility
  real<lower=0> sigma = fabs(normal_rng(0, 1));     // white noise shock scale
  real delta_texting = fabs(normal_rng(0.5, 0.1));   // effect of texting
  vector[T] h;                                      // log volatility at distance t
  vector[T] y;                                      // mean corrected return at time t
  
  h[1] = normal_rng(mu, sigma / sqrt(1 - phi * phi));
  for (t in 2:T) {
    h[t] = normal_rng(mu + delta_texting * (texting[t] - 1) 
            + phi * (h[t - 1] - mu), 
            sigma);
  }
  for (t in 1:T) {
    y[t] = normal_rng(0, exp(h[t] / 2));
  }
}
