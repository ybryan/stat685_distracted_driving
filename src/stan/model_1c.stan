// Model 1c
data {
  int<lower=1> N;     // Number of individuals
  real x[N];          // Mean pupil dilation for each individual
  real log_y[N];      // Log standard deviation of lane position for each individual

  int<lower=1> N_age;
  int<lower=1, upper=N_age> age[N];
}

parameters {
  real alpha;
  real beta;
  real<lower=0> sigma;
}

model {
  alpha ~ normal(0, ?);
  beta ~ normal(0, ?);
  sigma ~ normal(0, ?);

  log_y ~ normal(beta * x + alpha, sigma);
}

generated quantities {
  real ave_log_y_ppc = 0;
  real ave_log_y_age_ppc[N_age] = rep_vector(0, N_age);

  {
    int M[N_age] = rep_array(0, N_age);

    for (n in 1:N) {
      real log_y_ppc = normal_rng(beta * x + alpha, sigma);
      ave_log_y_ppc = ave_log_y_ppc + log_y_ppc;
      ave_log_y_age_ppc[age[n]] = ave_log_y_age_ppc[age[n]] + log_y_ppc;
      M[age[n]] = M[age[n]] + 1;
    }

    ave_log_y_ppc = ave_log_y_ppc / N;
    ave_log_y_age_ppc = ave_log_y_age_ppc ./ M;
  }
}

