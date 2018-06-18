// Multivariate normal linear regression
data {
    int<lower=0> N;      // Number of samples
    vector[N] x;
    vector[N] y;
}

parameters {
    real alpha;
    real beta;
    real<lower=0> sigma; // log sigma
}

model {
    beta ~ normal(0, 10);   // prior for beta
    alpha ~ normal(0, 10);  // prior for alpha
    sigma ~ cauchy(0, 10);  // prior for sigma: can be better to use half-Cauchy to be less informative

    y ~ normal(alpha + beta * x, sigma);
}
