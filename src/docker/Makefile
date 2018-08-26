latest:
	docker build -t byu/rstan .

CMD_REPOLOGIN := "eval $$\( aws ecr"
ifdef AWS_CLI_PROFILE
CMD_REPOLOGIN += " --profile $(AWS_CLI_PROFILE)"
endif
ifdef AWS_CLI_REGION
CMD_REPOLOGIN += " --region $(AWS_CLI_REGION)"
endif
CMD_REPOLOGIN += " get-login --no-include-email \)"

login:
	@eval $(CMD_REPOLOGIN)

push:
	docker tag byu/rstan 901488327662.dkr.ecr.us-east-1.amazonaws.com/rstan:latest
	docker push 901488327662.dkr.ecr.us-east-1.amazonaws.com/rstan:latest
	aws s3 cp simple_job.sh s3://stat685-batch/simple_job.sh

test:
	docker run -it --rm -w  /home/rstudio/work/ \
    -v "`pwd`":/home/rstudio/work \
    -e AWS_DEFAULT_REGION -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY \
	-e BATCH_FILE_TYPE=script -e BATCH_FILE_S3_URL=s3://stat685-batch/simple_job.sh byu/rstan
