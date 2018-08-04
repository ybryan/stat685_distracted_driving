// AR(1) Model
data {
  int<lower=0> N;
  real y[N];
}
parameters {
  real<lower=-1,upper=1> rho;
  real alpha;                
  real<lower=0> sigma;
}
model {
  // ** New **
  alpha ~ normal(1.8, 0.5);
  rho ~ normal(0, 0.5);
  sigma ~ normal(0, 0.5);

  for (n in 2:N)
    y[n] ~ normal(alpha + rho * y[n - 1], sigma);
  // ** Old **
  /*
  // likelihood
  for (n in 2:N)
    target+= normal_lpdf(y[n] | alpha + rho * y[n-1], sigma);
  // priors
  target+= normal_lpdf(rho | 0 , 0.5);
  target+= normal_lpdf(alpha | 0 , 1);
  */
}
generated quantities {
  real y_ppc[N] = y;
  
  for (n in 2:N)
    y_ppc[n] = normal_rng(alpha + rho * y[n-1], sigma);
}
