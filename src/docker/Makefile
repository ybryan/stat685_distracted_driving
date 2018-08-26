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

test:
	zip fakesha1_1.zip myjob.sh 8schools.R 8schools.stan 8schools.rds
	aws s3 cp fakesha1_1.zip s3://stat685-batch/test/
	docker run -it --rm \
    -e AWS_DEFAULT_REGION \
	-e AWS_ACCESS_KEY_ID \
	-e AWS_SECRET_ACCESS_KEY \
	-e BATCH_FILE_TYPE=zip \
	-e BATCH_FILE_S3_URL=s3://stat685-batch/test/fakesha1_1.zip \
	-e RESULT_KEY=fakesha1_1.Rdata \
	-e HASH_VALUE=fakesha1 \
	-e STAN_FILE=8schools.stan \
	-e RSCRIPT_FILE=8schools.R \
	byu/rstan myjob.sh 
	rm fakesha1_1.zip

prod_test:
	zip fakesha1_1.zip myjob.sh 8schools.R 8schools.stan 8schools.rds
	aws s3 cp fakesha1_1.zip s3://stat685-batch/stan_runs/8schools.stan/
	rm fakesha1_1.zip
