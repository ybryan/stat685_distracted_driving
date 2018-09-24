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
  real<lower=0> sigma_driver_sigma;
  real<lower=0> delta_base;
  real<lower=0> delta_texting_driver[N_drivers];
  real<lower=0> delta_texting_driver_sigma;
}
model {
  alpha ~ normal(0, 1);
  rho ~ uniform(0, 1);
  
  sigma_base ~ normal(0, 1);
  sigma_driver ~ normal(0, sigma_driver_sigma);
  sigma_driver_sigma ~ normal(0, 0.1);
  
  delta_base ~ normal(0, 1);
  delta_texting_driver ~ normal(0, delta_texting_driver_sigma);
  delta_texting_driver_sigma ~ normal(0, 0.1);
  
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
  vector [N] y_ppc = y;
  
  int n_start;
  int n_end;
    
  for (i in 1:N_drivers) {
    sigma_non_texting[i] = sigma_base + sigma_driver[i];
    sigma_texting[i]     = sigma_base + sigma_driver[i] 
                           + delta_base + delta_texting_driver[i];
                           
    n_start = N_time * (i - 1) + 1;
    n_end = N_time * i;
    for (n in (n_start + 1):n_end)
      y_ppc[n] = normal_rng(
        alpha + rho * y_ppc[n - 1],
        (sigma_base + sigma_driver[i])
        + (delta_base + delta_texting_driver[i])
        * (texting[n - 1]));
              
  }
}
