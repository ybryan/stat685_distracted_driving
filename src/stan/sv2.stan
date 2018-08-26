data {
  int<lower=0> N;                   // # distance points (equally spaced)
  int<lower=0> N_texting;           // # texting states (2)
  int<lower=1, upper=2> texting[N]; // vector of texting indicators (1 = not texting, 2 texting)
  vector[N] y;                      // mean corrected return at time n
}
parameters {
  real mu;                          // mean log volatility: not texting is baseline
  real<lower=-1,upper=1> phi;       // persistence of volatility
  real<lower=0> sigma;              // white noise shock scale
  real delta_texting;               // effect of texting
  vector[N] h_std;                  // std log volatility at time
}
model {
  vector[N] h = h_std * sigma;      // now h ~ normal(0, sigma)
  h[1] /= sqrt(1 - phi * phi);      // rescale h[1]
  for (n in 2:N)
    h[n] += mu + delta_texting * (texting[n] - 1) + phi * (h[n - 1] - mu);
    
  mu ~ normal(-2, 0.5);
  sigma ~ normal(0, 1);
  h_std ~ normal(0, 1);
  delta_texting ~ normal(0, 0.5);
  y ~ normal(0, exp(h / 2));
}
