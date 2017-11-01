FROM ubuntu:16.10

RUN apt -y update
RUN apt-get -y install curl python

# JAVA
RUN apt-get -y install openjdk-8-jre
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV PATH $PATH:${JAVA_HOME}/bin

# SPARK
# ARG SPARK_ARCHIVE=http://d3kbcqa49mib13.cloudfront.net/spark-2.2.0-bin-hadoop2.7.tgz
ARG SPARK_ARCHIVE=https://www.apache.org/dyn/closer.lua/spark/spark-2.2.0/spark-2.2.0-bin-hadoop2.7.tgz
ENV SPARK_HOME /usr/local/spark-2.2.0-bin-hadoop2.7

ENV PATH $PATH:${SPARK_HOME}/bin
RUN curl -L0 ${SPARK_ARCHIVE} | tar -xz -C /usr/local/

WORKDIR $SPARK_HOME

# PIP and python packages
RUN curl -L0 https://bootstrap.pypa.io/get-pip.py | python
RUN pip install numpy pandas
