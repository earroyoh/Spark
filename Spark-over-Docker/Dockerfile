FROM ubuntu:latest

RUN apt -y update
RUN apt-get -y install curl

# JAVA
RUN apt-get -y install openjdk-8-jre
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV PATH $PATH:${JAVA_HOME}/bin

# SPARK
ARG SPARK_ARCHIVE=https://apache.rediris.es/spark/spark-2.4.3/spark-2.4.3-bin-hadoop2.7.tgz
#ARG SPARK_ARCHIVE=https://www.apache.org/dyn/closer.lua/spark/spark-2.4.3/spark-2.4.3-bin-hadoop2.7.tgz
#ARG SPARK_ARCHIVE=https://d3kbcqa49mib13.cloudfront.net/spark-2.4.3-bin-hadoop2.7.tgz
ENV SPARK_HOME /usr/local/spark-2.4.3-bin-hadoop2.7

ENV PATH $PATH:${SPARK_HOME}/bin
RUN curl -L0 ${SPARK_ARCHIVE} | tar xz -C /usr/local/
RUN mkdir -p /tmp/spark-events

WORKDIR $SPARK_HOME

# PIP and python packages
#RUN curl -L0 https://bootstrap.pypa.io/get-pip.py | python
#RUN pip install numpy pandas
RUN apt-get -y install python-pip python-pip-whl
#RUN pip install --upgrade pip && pip install jupyter matplotlib seaborn xgboost
RUN pip install jupyter matplotlib seaborn xgboost scikit-learn
RUN apt-get -y install r-base

# MySQL and PostgreSQL drivers
RUN curl -L0 https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.12/mysql-connector-java-8.0.12.jar > ${SPARK_HOME}/jars/mysql-connector-java-8.0.12.jar
RUN curl -L0 https://repo1.maven.org/maven2/postgresql/postgresql/9.1-901.jdbc4/postgresql-9.1-901.jdbc4.jar > ${SPARK_HOME}/jars/postgresql-9.1-901.jdbc4.jar

ENV PYSPARK_DRIVER_PYTHON=jupyter
ENV PYSPARK_DRIVER_PYTHON_OPTS="notebook --allow-root --ip=0.0.0.0"
EXPOSE 8080 4040 6066 18080 8888
