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
fit <- stan(file = args[2], data = simu_data,
            iter = 1000, chains = 4)
print(fit, digits = 1)

# Save file
print(new_results)
saveRDS(fit, file=paste(hash_run_number, ".Rdata", sep=""))

