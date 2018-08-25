latest:
	docker build -t byu/rstan .

push:
	$(aws ecr get-login --no-include-email --region us-east-1)
	docker tag byu/rstan 901488327662.dkr.ecr.us-east-1.amazonaws.com/rstan:latest
	docker push 901488327662.dkr.ecr.us-east-1.amazonaws.com/rstan:latest

test:
	docker run -it --rm -w  /home/rstudio/work/ \
    -v "`pwd`":/home/rstudio/work \
    -e AWS_DEFAULT_REGION -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY \
	-e BATCH_FILE_TYPE=script -e BATCH_FILE_S3_URL=s3://stat685-batch/simple_job.sh byu/rstan
