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
  alpha ~ normal(0, 1);
  rho ~ uniform(0, 1);
  sigma ~ normal(0, 1);

  for (n in 2:N)
    y[n] ~ normal(alpha + rho * y[n - 1], sigma);
}
generated quantities {
  real y_ppc[N] = y;
  for (n in 2:N)
    y_ppc[n] = normal_rng(alpha + rho * y[n-1], sigma);
}
