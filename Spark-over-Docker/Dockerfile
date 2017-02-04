FROM ubuntu:16.10

RUN apt-get -y update
RUN apt-get -y install wget python

# JAVA
ARG JAVA_ARCHIVE=http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jre-8u112-linux-x64.tar.gz
ENV JAVA_HOME /usr/local/jre1.8.0_112

ENV PATH $PATH:${JAVA_HOME}/bin
RUN wget -q --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie;" ${JAVA_ARCHIVE}
RUN tar -xzf `basename ${JAVA_ARCHIVE}` -C /usr/local/ && ln -s `basename $JAVA_HOME` /usr/local/java 
RUN rm -f `basename ${JAVA_ARCHIVE}`

# SPARK
ARG SPARK_ARCHIVE=http://d3kbcqa49mib13.cloudfront.net/spark-2.1.0-bin-hadoop2.7.tgz
ENV SPARK_HOME /usr/local/spark-2.1.0-bin-hadoop2.7

ENV PATH $PATH:${SPARK_HOME}/bin
RUN wget -q ${SPARK_ARCHIVE}
RUN tar -xzf `basename ${SPARK_ARCHIVE}` -C /usr/local/
RUN rm -f `basename ${SPARK_ARCHIVE}`

WORKDIR $SPARK_HOME

# PIP and python packages
RUN wget -q https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py
RUN pip install numpy pandas
