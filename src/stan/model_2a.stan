// Model 2a: Heterogeneous population cohort
data {
  int<lower=1> N;     // Number of individuals
  vector[N] x;
  vector[N] log_y;

  int<lower=1> N_age;
  int<lower=1, upper=N_age> age[N];
}

parameters {
  real alpha0;
  vector[N_age] alpha_age;
  real beta;
  real<lower=0> sigma;
}

model {
  alpha0 ~ normal(1.825, .2);
  alpha_age ~ normal(0, 5);

  beta ~ normal(0, 5);
  sigma ~ normal(0, 5);

  log_y ~ normal(beta * x + alpha0 + alpha_age[age], sigma);
}

generated quantities {
  real ave_log_y_ppc = 0;
  vector[N_age] ave_log_y_age_ppc = rep_vector(0, N_age);

  {
    vector[N_age] M = rep_vector(0, N_age);

    for (n in 1:N) {
      real log_y_ppc = normal_rng(beta * x[n] + alpha0 + alpha_age[age[n]], sigma);
      ave_log_y_ppc = ave_log_y_ppc + log_y_ppc;
      ave_log_y_age_ppc[age[n]] = ave_log_y_age_ppc[age[n]] + log_y_ppc;
      M[age[n]] = M[age[n]] + 1;
    }

    ave_log_y_ppc = ave_log_y_ppc / N;
    ave_log_y_age_ppc = ave_log_y_age_ppc ./ M;
  }
}

