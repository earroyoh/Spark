NYPD = spark.read.option("inferSchema", "true").option("header", "true").csv("NYPD_Complaint_Data_Historic.csv")
NYPD.take(3)
spark.conf.set("spark.sql.shuffle.partitions", "5")
NYPD.createOrReplaceTempView("NYPD-complaint-data")
spark.sql("SELECT count(*) FROM NYPD_complaint_data").show()
sqlofns = spark.sql("SELECT OFNS_DESC, count(1) FROM NYPD_complaint_data GROUP BY OFNS_DESC")
sqlofns.show()
histofns = spark.sql("SELECT CMPLNT_FR_DT,count(OFNS_DESC) FROM NYPD-comlaint-data WHERE CMPLNT_FR_DT<>'' GROUP BY CMPLNT_FR_DT ORDER BY to_date(CMPLNT_FR_DT)")