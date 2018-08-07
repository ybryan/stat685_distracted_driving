data {
  int T;
  int<lower=1, upper=2> texting[T]; 
}
generated quantities {
  real mu = normal_rng(1.825, 0.25);
  real alpha0 = exponential_rng(1.273);
  vector[2] alpha_texting = [-0.5, 0.5]';
  real<lower=0,upper=1> alpha1 = beta_rng(2, 2);
  real y[T];
  
  if (alpha0 + alpha_texting[1] < 0 || alpha0 + alpha_texting[2] < 0) {
    reject("Not positive intercept")
  }
    
  y[1] = 2;
  for (t in 2:T) {
    y[t] = normal_rng(mu, sqrt(alpha0 + alpha_texting[texting[t]] + alpha1 * pow(y[t-1] - mu, 2)));
  }
}
