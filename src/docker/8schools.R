#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
library("rstan") 
library("aws.s3")
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
new_results      <- paste(hash_run_number, ".rds", sep="")
key <- paste("results", hash, new_results, sep="/")

if (!object_exists(key, bucket_name)){
    # Run STAN
    schools_dat <- list(J = 8,
                        y = c(28,  8, -3,  7, -1,  1, 18, 12),
                        sigma = c(15, 10, 16, 11,  9, 11, 10, 18))
    fit <- stan(file = '8schools.stan', data = schools_dat,
                iter = 1000, chains = 4)
    print(fit, digits = 1)

    # Save file
    s3saveRDS(fit, object=key, bucket=bucket_name)
}
