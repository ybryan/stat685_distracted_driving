data {
  int<lower=0> T;   // # distance points
}
generated quantities {
  real mu = cauchy_rng(0, 10);                      // mean log volatility
  real<lower=-1, upper=1> phi = uniform_rng(-1, 1); // persistence of volatility
  real<lower=0> sigma = fabs(cauchy_rng(0, 5));     // white noise shock scale
  vector[T] h;                                      // log volatility at distance t
  vector[T] y;                                      // mean corrected return at time t
  
  h[1] = normal_rng(mu, sigma / sqrt(1 - phi * phi)); 
  for (t in 2:T) {
    h[t] = normal_rng(mu + phi * (h[t - 1] - mu), sigma);
  }
  
  for (t in 1:T) {
    y[T] = normal_rng(0, exp(h[T] / 2));
  }
}
