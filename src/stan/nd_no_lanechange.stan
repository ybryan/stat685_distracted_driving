data {
    int<lower=1> J;             // number of age cohorts
    real y[J];                  // mean lane position of each driver
    real<lower=0> sigma[J];     // sd lane position of each driver
}

parameters {
    real mu;                // population lane position
    real<lower=0> tau;      // population sd lane position
    vector[J] eta;          // age-level errors
}

transformed parameters {
    vector[J] theta;        // age effect
    theta = mu + tau*eta;
}

model {
    eta ~ normal(0, 1);
    sigma ~ cauchy(0, 10);

    for (j in 1:j)
        y[j] ~ normal(theta[j], sigma[j]);
}
