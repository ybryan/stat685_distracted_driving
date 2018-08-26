#!/bin/bash
date

echo "jobId: $AWS_BATCH_JOB_ID"
echo "jobQueue: $AWS_BATCH_JQ_NAME"
echo "computeEnvironment: $AWS_BATCH_CE_NAME"

Rscript --vanilla 8schools.R $BATCH_FILE_S3_URL

date
echo "bye bye!!"
