data {
    int<lower=1> N;             // number of drivers
    int<lower=1> J;             // number of age cohorts
    int<lower=1> I;             // number of distance data points
    real y[N];                  // mean lane position by driver
    vector[I] x;                // eye pupil diameter
}

parameters {
    real alpha;             // population lane position
    real<lower=0> sigma;    // population sd of lane position
    real beta;              // eye pupil effect
    vector[J] mu;           // age cohort effect
}

model {
    alpha ~ normal(1.825, 1);
    sigma ~ cauchy(0, 4);
    beta ~ normal(0, 2.5);

    for (n in 1:N)
        for (j in 1:J)
            for (i in 1:I)
                y[n] ~ normal(alpha + mu[j] + beta * x[i], sigma);
}
