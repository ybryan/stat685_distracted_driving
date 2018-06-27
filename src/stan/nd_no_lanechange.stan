data {
    int<lower=1> N;             // number of drivers
    int<lower=1> J;             // number of age cohorts
    int<lower=1> I;             // number of distance data points
    real y[N];                  // mean lane position by driver
    vector[I] eta;                // eye pupil diameter
    /*
        distracted -> higher sd
        y_n <- sd(ts)
        y_n <- alpha + age_cohort + beta * mean(x) (eta)

        1. Filter out missing eye tracking day :: Why?
            * Histogram (sd) of eye tracking vs non-eye tracking
        2. Summary statistic for acf
    */
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

    for (j in 1:J)
        for (n in 1:N)
            for (i in 1:I)
                y[n] ~ normal(alpha + mu[j] + beta * x[i], sigma);
}
