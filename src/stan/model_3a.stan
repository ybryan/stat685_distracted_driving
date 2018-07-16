// Model 3a: Homogeneous population cohort with texting
data {
  int<lower=1> N;
  vector[N] x;
  vector[N] log_y;
  int<lower=1> N_texting;
  int<lower=1, upper=2> texting[N];
}

parameters {
  real alpha0;
  vector[2] alpha_texting;
  real beta;
  real<lower=0> sigma;
}

model {
  alpha0 ~ normal(1.825, .2);
  alpha_texting ~ normal(0, 5);
  beta ~ normal(0, 5);
  sigma ~ normal(0, 5);

  log_y ~ normal(beta * x + alpha0 + alpha_texting[texting], sigma);
}

generated quantities {
  real ave_log_y_ppc = 0;
  vector[N_texting] ave_log_y_text_ppc = rep_vector(0, N_texting);
  {
    vector[N_texting] M_text = rep_vector(0, N_texting);
    for (n in 1:N) {
      real log_y_ppc = normal_rng(beta * x[n] + alpha0 + alpha_texting[texting[n]], sigma);

      ave_log_y_ppc = ave_log_y_ppc + log_y_ppc;
      ave_log_y_text_ppc[texting[n]] = ave_log_y_text_ppc[texting[n]] + log_y_ppc;
      M_text[texting[n]] = M_text[texting[n]] + 1;
    }

    ave_log_y_ppc = ave_log_y_ppc / N;
    ave_log_y_text_ppc = ave_log_y_text_ppc ./ M_text;
  }
}
