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
sbc_rank_alpha <- sum(simu_alpha < extract(fit)$mu[seq(1, 4000 - 8, 8)])
sbc_rank_sigma <- sum(simu_sigma < extract(fit)$phi[seq(1, 4000 - 8, 8)])
sbc_rank_rho <- sum(simu_rho < extract(fit)$sigma[seq(1, 4000 - 8, 8)])
sbc_rank_delta_texting <- sum(simu_delta_texting < extract(fit)$delta_texting[seq(1, 4000 - 8, 8)])

# Compute posterior sensitivities
s <- summary(fit, probs = c(), pars='alpha')$summary
post_mean_alpha <- s[,1]
post_sd_alpha <- s[,3]
prior_sd_alpha <- 1
z_score_alpha <- abs((post_mean_alpha - simu_alpha) / post_sd_alpha)
shrinkage_alpha <- 1 - (post_sd_alpha / prior_sd_alpha)**2

s <- summary(fit, probs = c(), pars='sigma')$summary
post_mean_sigma <- s[,1]
post_sd_sigma <- s[,3]
prior_sd_sigma <- sqrt(1^2 * (1 - 2 / pi))
z_score_sigma <- abs((post_mean_sigma- simu_sigma) / post_sd_sigma)
shrinkage_sigma <- 1 - (post_sd_sigma / prior_sd_sigma)**2

s <- summary(fit, probs = c(), pars='rho')$summary
post_mean_rho <- s[,1]
post_sd_rho <- s[,3]
prior_sd_rho <- sqrt(1/12 * (1 - 0)^2)
z_score_rho <- abs((post_mean_rho - simu_rho) / post_sd_rho)
shrinkage_rho <- 1 - (post_sd_rho / prior_sd_rho)**2

s <- summary(fit, probs = c(), pars='delta_texting')$summary
post_mean_delta_texting <- s[,1]
post_sd_delta_texting <- s[,3]
prior_sd_delta_texting <- sqrt(1^2 * (1 - 2 / pi))
z_score_delta_texting <- abs((post_mean_delta_texting - simu_delta_texting) /
                             post_sd_delta_texting)
shrinkage_delta_texting <- 1 - (post_sd_delta_texting/ prior_sd_delta_texting)**2

output <- c(warning_code,
  sbc_rank_alpha, z_score_alpha, shrinkage_alpha,
  sbc_rank_rho, z_score_rho, shrinkage_rho,
  sbc_rank_sigma, z_score_sigma, shrinkage_sigma,
  sbc_rank_delta_texting, z_score_delta_texting, shrinkage_delta_texting)
print(c("warning_code", 
        "sbc_rank_alpha",  "z_score_alpha",  "shrinkage_alpha",
        "sbc_rank_rho", "z_score_rho", "shrinkage_rho",
        "sbc_rank_sigma", "z_score_sigma", "shrinkage_sigma",
        "sbc_rank_delta_texting", "z_score_delta_texting", "shrinkage_delta_texting"))
print(output)
# Save file
saveRDS(output, file=paste(hash_run_number, ".Rdata", sep=""))