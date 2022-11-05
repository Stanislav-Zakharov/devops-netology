FROM centos:7

ENV ES_PKG_NAME elasticsearch-8.4.3

RUN curl -O https://artifacts.elastic.co/downloads/elasticsearch/$ES_PKG_NAME-linux-x86_64.tar.gz && \
    tar -xvzf $ES_PKG_NAME-linux-x86_64.tar.gz && \
    rm $ES_PKG_NAME-linux-x86_64.tar.gz && \
    mv /$ES_PKG_NAME /elasticsearch

COPY elasticsearch.yml /elasticsearch/config/

RUN groupadd -r elasticsearch
RUN useradd -rm elasticsearch -g elasticsearch
RUN chown -R elasticsearch:elasticsearch /elasticsearch
RUN mkdir -p /var/lib/elasticsearch/logs && \
    mkdir -p /var/lib/elasticsearch/data &&  \
    chown -R elasticsearch:elasticsearch /var/lib/elasticsearch/

USER elasticsearch
WORKDIR /elasticsearch

ENTRYPOINT ["bin/elasticsearch"]
