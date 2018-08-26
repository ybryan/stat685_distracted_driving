#!/bin/bash
date
echo "jobId: $AWS_BATCH_JOB_ID"
echo "jobQueue: $AWS_BATCH_JQ_NAME"
echo "computeEnvironment: $AWS_BATCH_CE_NAME"
echo "resultKey: $RESULT_KEY"
echo "hashValue: $HASH_VALUE"

Rscript --vanilla 8schools.R $BATCH_FILE_S3_URL

ls -l
aws s3 cp $RESULT_KEY s3://stat685-batch/results/$HASH_VALUE/

echo "bye bye!!"
