FROM ubuntu:latest

RUN apt -y update
RUN apt-get -y install curl python

# JAVA
apt-get -y install openjdk-9-jre
ENV JAVA_HOME /usr/lib/jvm/java-9-openjdk-amd64
ENV PATH $PATH:${JAVA_HOME}/bin

# SPARK
ARG SPARK_ARCHIVE=http://d3kbcqa49mib13.cloudfront.net/spark-2.2.0-bin-hadoop2.7.tgz
ENV SPARK_HOME /usr/local/spark-2.2.0-bin-hadoop2.7

ENV PATH $PATH:${SPARK_HOME}/bin
RUN curl -s -L0 ${SPARK_ARCHIVE} | tar -xzf `basename ${SPARK_ARCHIVE}` -C /usr/local/

WORKDIR $SPARK_HOME

# PIP and python packages
RUN curl -s -L0 https://bootstrap.pypa.io/get-pip.py | python
RUN pip install numpy pandas