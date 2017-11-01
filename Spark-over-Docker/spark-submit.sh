#!/bin/sh
curl -X POST http://spark-master:6066/v1/submissions/create \
--header "Content-Type:application/json;charset=UTF-8" --data '{
  "action" : "CreateSubmissionRequest",
  "appArgs" : [ "/usr/local/spark-2.2.0-bin-hadoop2.7/data/mllib/kmeans_data.txt" ],
  "appResource" : "file:/usr/local/spark-2.2.0-bin-hadoop2.7/examples/jars/spark-examples_2.11-2.2.0.jar",
  "clientSparkVersion" : "2.2.0",
  "environmentVariables" : {
    "SPARK_ENV_LOADED" : "1"
  },
  "mainClass" : "org.apache.spark.examples.mllib.KMeansExample",
  "sparkProperties" : {
    "spark.jars" : "file:/usr/local/spark-2.2.0-bin-hadoop2.7/examples/jars/*",
    "spark.driver.supervise" : "false",
    "spark.app.name" : "MyJob",
    "spark.eventLog.enabled": "true",
    "spark.submit.deployMode" : "cluster",
    "spark.master" : "spark://spark-master:6066"
  }
}'
