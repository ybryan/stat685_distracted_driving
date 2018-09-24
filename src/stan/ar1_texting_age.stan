data {
  int<lower=1> N_drivers;
  int<lower=1> N_time;    // N_time:    data points per driver
  int<lower=1> N_age;     // N_age:     number of age groups
  int<lower=0> N_texting; // N_texting: number of texting states
  int<lower=1> N;         // N = N_divers * N_time
  int age[N_drivers];     // array of ages
  vector<lower=1, upper=N_texting>[N] texting;
  vector[N] y;
}
parameters {
  real<lower=0, upper=1> rho;
  real alpha;

  real<lower=0> sigma_base;
  real log_delta_sigma_age[N_age];
  real log_delta_sigma_texting[N_age];

}
model {
  alpha ~ normal(0, 1);
  rho ~ uniform(0, 1);

  sigma_base ~ normal(0, 1);
  log_delta_sigma_age ~ normal(0, 1);
  log_delta_sigma_texting ~ normal(0, 1);

  for (i in 1:N_drivers) {
    int n_start = N_time * (i - 1) + 1;
    vector[N_time - 1] mu = alpha + rho * y[n_start:(n_start + N_time - 2)];
    vector[N_time - 1] sigma = sigma_base
      * exp(log_delta_sigma_age[age[i]]
            + log_delta_sigma_texting[age[i]]
            * (texting[(n_start + 1):(n_start + N_time - 1)] - 1));
    y[(n_start + 1):(n_start + N_time - 1)] ~ normal(mu, sigma);
  }
}
generated quantities {
  real sigma_texting[N_age];
  real sigma_non_texting[N_age];
  vector [N] y_ppc = y;

  int n_start;
  int n_end;
    
  for (k in 1:N_age) {
    sigma_texting[k] = sigma_base * exp(log_delta_sigma_age[k] 
                                        + log_delta_sigma_texting[k]);
    sigma_non_texting[k] = sigma_base * exp(log_delta_sigma_age[k]);
  }
  
  for (j in 1:N_drivers) {
    n_start = N_time * (j - 1) + 1;
    n_end = N_time * j;
    for (n in n_start:n_end) {
      y_ppc[n] = normal_rng(
        alpha + rho * y_ppc[n - 1],
        (sigma_base * exp(log_delta_sigma_age[j]
                          + (log_delta_sigma_texting[j])
        * (texting[n - 1]))));
    }
  }
}
