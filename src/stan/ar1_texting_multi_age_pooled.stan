data {
  int<lower=1> N_drivers;
  int<lower=1> N_time;
  int<lower=1> N;         // N = N_divers * N_time
  int<lower=1> N_age;     // # age states (2)
  int<lower=0> N_texting; // # texting states (2)
  vector<lower=1, upper=N_texting>[N] texting; 
  int<lower=1, upper=N_age> age[N_drivers];
  vector[N] y;
}
parameters {
  real<lower=0, upper=1> rho;
  real alpha;                
  real<lower=0> sigma_base;
  real<lower=0> sigma_driver[N_drivers];
  real<lower=0> sigma_driver_mu[N_age];
  real<lower=0> sigma_driver_sigma[N_age];
  
  real<lower=0> delta_base;
  real<lower=0> delta_texting_driver[N_drivers];
  real<lower=0> delta_texting_driver_mu[N_age];
  real<lower=0> delta_texting_driver_sigma[N_age];
  
}
model {
  alpha ~ normal(0, 1);
  rho ~ uniform(0, 1);
  
  sigma_base ~ normal(0, 1);
  sigma_driver ~ normal(sigma_driver_mu, sigma_driver_sigma);
  sigma_driver_mu ~ normal(0, 0.1)
  sigma_driver_sigma ~ normal(0, 0.1)
  
  delta_base ~ normal(0, 1);
  delta_texting_driver ~ normal(delta_texting_driver_mu, delta_texting_sigma);
  delta_texting_driver_mu ~ normal(0.5, 0.1);
  delta_texting_driver_sigma ~ normal(0.5, 0.1);
  
  for (i in 1:N_drivers) {
    int n_start = N_time * (i - 1) + 1;
    y[(n_start + 1):(n_start + N_time - 1)] ~ normal(
        alpha + rho * y[n_start:(n_start + N_time - 2)],
          (sigma_base + sigma_driver[i])
        + (delta_base + delta_texting_driver[i])
        * (texting[(n_start + 1):(n_start + N_time - 1)] - 1));
  }
}
generated quantities {
  vector [N_drivers] sigma_non_texting;
  vector [N_drivers] sigma_texting;
  
  for (i in 1:N_drivers) {
    sigma_non_texting[i] = sigma_base + sigma_driver[i];
    sigma_texting[i] = sigma_base + sigma_driver[i] + delta_base + delta_texting_driver[i];
  }
}
