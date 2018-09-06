data {
  int<lower=1> N_drivers;
  int<lower=1> N_time;
  int<lower=1> N;         // N = N_divers * N_time
  int<lower=0> N_texting; // # texting states (2)
  vector<lower=1, upper=N_texting>[N] texting; 
  vector[N] y;
}
parameters {
  real<lower=0, upper=1> rho;
  real alpha;                
  real<lower=0> sigma_base;
  real<lower=0> sigma_driver[N_drivers];
  real<lower=0> delta_texting;
  real<lower=0> delta_texting_driver[N_drivers];
}
model {
  alpha ~ normal(0, 1);
  rho ~ uniform(0, 1);
  sigma_base ~ normal(0, 1);
  sigma_driver ~ normal(0, 0.1);
  delta_texting ~ normal(0, 0.1);
  delta_texting_driver ~ normal(0, 0.01);
  
  for (i in 1:N_drivers) {
    int n_start = N_time * (i - 1) + 1;
    y[(n_start + 1):(n_start + N_time - 1)] ~ normal(
        alpha + rho * y[n_start:(n_start + N_time - 2)],
        (sigma_base + sigma_driver[i])
      + (delta_texting + delta_texting_driver[i])
      * (texting[(n_start + 1):(n_start + N_time - 1)] - 1));
  }
}
