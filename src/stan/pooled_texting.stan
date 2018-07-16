// Model 4a: Pooled texting
data {
  int<lower=1> N;
  vector[N] x;
  vector[N] log_y;
  int<lower=1> N_texting;
  int<lower=1, upper=2> texting[N];
}

parameters {
  real alpha0;
  vector[N_texting] alpha_texting;
  real beta;
  real<lower=0> sigma;
}

model {
  alpha0 ~ normal(1.825, .2);
  alpha_texting ~ normal(0, 5);
  beta ~ normal(0, 5);
  sigma ~ normal(0, 5);

  for (l in 1:N_texting) {
    alpha_texting[l] ~ normal(-1, 5); // draw from hierarchical prior?
  }
  for (n in 1:N)
    log_y ~ normal(beta * x[n] + alpha0 + alpha_texting[texting[n]], sigma);
}
