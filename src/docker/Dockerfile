FROM jrnold/rstan
MAINTAINER Bryan Yu <bryan.yu@santecapital.com>
RUN apt-get update && apt-get install -y python python-pip curl unzip groff
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN pip install awscli
RUN Rscript -e "install.packages('devtools')"
RUN Rscript -e "library('devtools');install_github('cloudyr/aws.s3')"
ADD fetch_and_run.sh /usr/local/bin/fetch_and_run.sh

ENTRYPOINT ["/usr/local/bin/fetch_and_run.sh"]
