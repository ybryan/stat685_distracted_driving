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
  alpha0 ~ normal(1.825, .2);
  alpha_age ~ normal(0, 5);
  alpha_texting ~ normal(0, 5);
  beta ~ normal(0, 5);
  sigma ~ normal(0, 5);

  log_y ~ normal(beta * x + alpha0 + alpha_age[age] + alpha_texting[texting], sigma);
}

generated quantities {
  real ave_log_y_ppc = 0;
  vector[N_age] ave_log_y_age_ppc = rep_vector(0, N_age);
  vector[2]     ave_log_y_text_ppc = rep_vector(0, 2);

  {
    vector[N_age] M_age = rep_vector(0, N_age);
    vector[2]     M_text = rep_vector(0, 2);

    for (n in 1:N) {
      real log_y_ppc = normal_rng(beta * x[n] + alpha0 + alpha_age[age[n]], sigma);

      ave_log_y_ppc = ave_log_y_ppc + log_y_ppc;
      ave_log_y_age_ppc[age[n]]      = ave_log_y_age_ppc[age[n]] + log_y_ppc;
      ave_log_y_text_ppc[texting[n]] = ave_log_y_text_ppc[texting[n]] + log_y_ppc;

      M_age[age[n]] = M_age[age[n]] + 1;
      M_text[texting[n]] = M_text[texting[n]] + 1;
    }

    ave_log_y_ppc = ave_log_y_ppc / N;
    ave_log_y_age_ppc = ave_log_y_age_ppc ./ M_age;
    ave_log_y_text_ppc = ave_log_y_text_ppc ./ M_text;
  }
}

