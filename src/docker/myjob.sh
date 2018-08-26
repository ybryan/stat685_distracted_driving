#!/bin/bash
date
echo "jobId: $AWS_BATCH_JOB_ID"
echo "jobQueue: $AWS_BATCH_JQ_NAME"
echo "computeEnvironment: $AWS_BATCH_CE_NAME"
echo "resultKey: $RESULT_KEY"
echo "hashValue: $HASH_VALUE"
echo "rScriptFile: $RSCRIPT_FILE"
echo "stanFile: $STAN_FILE"

Rscript --vanilla $RSCRIPT_FILE $BATCH_FILE_S3_URL $STAN_FILE

ls -l
aws s3 cp $RESULT_KEY s3://stat685-batch/results/$STAN_FILE/$HASH_VALUE/

echo "bye bye!!"
