data {
    int<lower=0> N;     // number of drivers

    vector[N] y;        // vector of lane position std deviation
}

parameters {
    real alpha;
    real beta;
    real<lower=0> sigma;
}

model {
    sigma ~ cauchy(0, 10)

    y ~ normal(mu, sigma);
}
