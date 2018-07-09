// Model 3a: Heterogeneous population cohort with texting
data {
  int<lower=1> N;     // Number of individuals
  vector[N] x;
  vector[N] log_y;

  int<lower=1> N_age;
  int<lower=1, upper=N_age> age[N];
  int<lower=1, upper=2> texting[N];
}

parameters {
  real alpha0;
  vector[N_age] alpha_age;
  vector[2] alpha_texting;
  real beta;
  real<lower=0> sigma;
}

model {
  alpha0 ~ normal(0, 5);
  alpha_age ~ normal(0, 5);
  alpha_texting ~ normal(0, 5);
  beta ~ normal(0, 5);
  sigma ~ normal(0, 5);

  log_y ~ normal(beta * x + alpha0 + alpha_age[age] + alpha_texting[texting], sigma);
}

