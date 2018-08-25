FROM jrnold/rstan
MAINTAINER Bryan Yu <bryan.yu@santecapital.com>
RUN apt-get update && apt-get install -y python python-pip curl unzip groff
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN pip install awscli
ADD fetch_and_run.sh /usr/local/bin/fetch_and_run.sh

ENTRYPOINT ["/usr/local/bin/fetch_and_run.sh"]
