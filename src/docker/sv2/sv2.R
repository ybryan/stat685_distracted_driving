#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
library("rstan") 
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

# Make sure args available
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).zip", call.=FALSE)
} 

# AWS S3 file and keys
bucket_name      <- "stat685-batch"
source_file_name <- tail(strsplit(args[1], "/")[[1]], n=1)
hash_run_number  <- strsplit(source_file_name, "[.]")[[1]][1]
hash             <- strsplit(hash_run_number, "_")[[1]][1]
run_number       <- strsplit(hash_run_number, "_")[[1]][2]
new_results      <- paste("results/", hash, "/", hash_run_number, ".Rdata", sep="")

# Run STAN
load("simu_data.Rdata")
fit <- stan(file = args[2], data = simu_data, seed=4938483)
print(fit, digits = 1)

# Run diagnostics
util <- new.env()
source('stan_utility.R', local=util)

warning_code <- util$check_all_diagnostics(fit, quiet=TRUE)

# Compute rank of prior draw with respect to thinned posterior draws
sbc_rank_mu <- sum(simu_mu < extract(fit)$mu[seq(1, 4000 - 8, 8)])
sbc_rank_phi <- sum(simu_phi < extract(fit)$phi[seq(1, 4000 - 8, 8)])
sbc_rank_sigma <- sum(simu_sigma < extract(fit)$sigma[seq(1, 4000 - 8, 8)])
sbc_rank_delta <- sum(simu_delta < extract(fit)$delta_texting[seq(1, 4000 - 8, 8)])

# Compute posterior sensitivities
s <- summary(fit, probs = c(), pars='mu')$summary
post_mean_mu <- s[,1]
post_sd_mu <- s[,3]
prior_sd_mu <- 1
z_score_mu <- abs((post_mean_mu - simu_mu) / post_sd_mu)
shrinkage_mu <- 1 - (post_sd_mu / prior_sd_mu)**2

s <- summary(fit, probs = c(), pars='phi')$summary
post_mean_phi <- s[,1]
post_sd_phi <- s[,3]
prior_sd_phi <- sqrt(1/12 * (1 - -1)^2)
z_score_phi <- abs((post_mean_phi - simu_phi) / post_sd_phi)
shrinkage_phi <- 1 - (post_sd_phi / prior_sd_phi)**2

s <- summary(fit, probs = c(), pars='sigma')$summary
post_mean_sigma <- s[,1]
post_sd_sigma <- s[,3]
prior_sd_sigma <- 1 * (1 - 2 / pi)
z_score_sigma <- abs((post_mean_sigma- simu_sigma) / post_sd_sigma)
shrinkage_sigma <- 1 - (post_sd_sigma / prior_sd_sigma)**2

s <- summary(fit, probs = c(), pars='delta_texting')$summary
post_mean_delta <- s[,1]
post_sd_delta <- s[,3]
prior_sd_delta <- 0.05
z_score_delta <- abs((post_mean_delta - simu_delta) / post_sd_delta)
shrinkage_delta <- 1 - (post_sd_delta/ prior_sd_delta)**2

output <- c(warning_code,
  sbc_rank_mu, z_score_mu, shrinkage_mu,
  sbc_rank_phi, z_score_phi, shrinkage_phi,
  sbc_rank_sigma, z_score_sigma, shrinkage_sigma,
  sbc_rank_delta, z_score_delta, shrinkage_delta)
print(c("warning_code", 
        "sbc_rank_mu",  "z_score_mu",  "shrinkage_mu",
        "sbc_rank_phi", "z_score_phi", "shrinkage_phi",
        "sbc_rank_sigma", "z_score_sigma", "shrinkage_sigma",
        "sbc_rank_delta", "z_score_delta", "shrinkage_delta"))
print(output)
# Save file
saveRDS(output, file=paste(hash_run_number, ".Rdata", sep=""))