// Generate Data 1b
transformed data {
  real alpha = 1;
  real beta = -2;
  real<lower=0> sigma = 0.5;
}

generated quantities {
  real x = normal_rng(2, 1);
  real log_y = normal_rng(beta * x + alpha, sigma);
}

// fit <- stan(model_file="generate_data_1b.stan", iter=100, warmup=0, algorithm=Fixed_param)

// Generate Data 2a
transformed data {
  real alpha0 = 1.5

  int N_age = 2;
  vector alpha = [0.25, -0.25]';

  real beta = -2;
  real<lower=0> sigma = 0.5;

  int N_prime = 100;
  int age_prime[N_prime];

  for (n in 1:N_prime)
    age_prime[n] = categorical_rng([0.5, 0.5]');
}

generated quantities {
  int N = N_prime;
  int<lower=1, upper=N_age> age = age_prime;

  real x[N_prime];
  real log_y[N_prime];

  for (n in 1:N) {
    x[n] = normal_rng(2, 1);
    log_y[n] = normal_rng(beta * x[n] + alpha[age[n]] + alpha0, sigma);
  }
}

// fit_hetero <- stan(model_file="generate_data_2a.stan", iter=1, warmup=0, algorithm=Fixed_param)



// Model 1a
data {
  int<lower=1> N;     // Number of individuals
  real x[N];          // Mean log pupil dilation for each individual
  real log_y[N];      // Log standard deviation of lane position for each individual
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
  real log_y_ppc[N];
  for (n in 1:N)
    log_y_ppc[n] = normal_rng(beta * x + alpha, sigma);
}

// Model 1b
data {
  int<lower=1> N;     // Number of individuals
  real x[N];          // Mean pupil dilation for each individual
  real<lower=0> y[N]; // Standard deviation of lane position for each individual
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

  y ~ lognormal(beta * x + alpha, sigma);
}

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

// Model 2a
data {
  int<lower=1> N;     // Number of individuals
  real x[N];          // Mean pupil dilation for each individual
  real log_y[N];      // Log standard deviation of lane position for each individual

  int<lower=1> N_age;
  int<lower=1, upper=N_age> age[N];
}

parameters {
  real alpha0;
  real alpha_age[N_age];
  real beta;
  real<lower=0> sigma;
}

model {
  alpha0 ~ normal(0, ?);
  alpha_age ~ normal(0, ?);

  beta ~ normal(0, ?);
  sigma ~ normal(0, ?);

  log_y ~ normal(beta * x + alpha0 + alpha_age[age], sigma);
}

generated quantities {
  real ave_log_y_ppc = 0;
  real ave_log_y_age_ppc[N_age] = rep_vector(0, N_age);

  {
    int M[N_age] = rep_array(0, N_age);

    for (n in 1:N) {
      real log_y_ppc = normal_rng(beta * x + alpha0 + alpha_age[age[n]], sigma);
      ave_log_y_ppc = ave_log_y_ppc + log_y_ppc;
      ave_log_y_age_ppc[age[n]] = ave_log_y_age_ppc[age[n]] + log_y_ppc;
      M[age[n]] = M[age[n]] + 1;
    }

    ave_log_y_ppc = ave_log_y_ppc / N;
    ave_log_y_age_ppc = ave_log_y_age_ppc ./ M;
  }
}
