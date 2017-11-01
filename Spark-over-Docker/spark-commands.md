val sqlWay = spark.sql("""SELECT DEST_COUNTRY_NAME, count(1) FROM flight_data_2015 GROUP BY DEST_COUNTRY_NAME""")
val maxSql = spark.sql("""SELECT DEST_COUNTRY_NAME, sum(count) as destination_total FROM flight_data_2015 GROUP BY DEST_COUNTRY_NAME ORDER BY sum(count) DESC LIMIT 5""")

case class Flight(DEST_COUNTRY_NAME: String, ORIGIN_COUNTRY_NAME: String, count:BigInt)
val flightsDF = spark.read.parquet("/tmp/data/flight-data/parquet/2010-summary.parquet/")
val flights = flightsDF.as[Flight]

flights.filter(flight_row => flight_row.ORIGIN_COUNTRY_NAME != "Canada").take(5)

val staticDataFrame = spark.read.format("csv").option("header", "true").option("inferSchema", "true").load("/tmp/data/retail-data/by-day/*.csv")
staticDataFrame.createOrReplaceTempView("retail_data")
val staticSchema = staticDataFrame.schema

import org.apache.spark.sql.functions.{window, column, desc, col}
staticDataFrame
.selectExpr(
"CustomerId",
"(UnitPrice * Quantity) as total_cost",
"InvoiceDate")
.groupBy(
col("CustomerId"), window(col("InvoiceDate"), "1 day"))
.sum("total_cost")
.orderBy(desc("sum(total_cost)"))

val streamingDataFrame = spark.readStream.schema(staticSchema).option("maxFilesPerTrigger", 1).format("csv").option("header", "true").load("/tmp/data/retail-data/by-day/*.csv")
val purchaseByCustomerPerHour = streamingDataFrame.selectExpr("CustomerId","(UnitPrice * Quantity) as total_cost","InvoiceDate").groupBy($"CustomerId", window($"InvoiceDate", "1 day")).sum("total_cost")
spark.conf.set("spark.sql.shuffle.partitions", "5")

purchaseByCustomerPerHour.writeStream.format("memory").queryName("customer_purchases").outputMode("complete").start()
purchaseByCustomerPerHour.writeStream.format("console").queryName("customer_purchases").outputMode("complete").start()
spark.sql("""SELECT * FROM customer_purchases ORDER BY `sum(total_cost)` DESC""").take(5)

staticDataFrame.printSchema()
import org.apache.spark.sql.functions.date_format
val preppedDataFrame = staticDataFrame.na.fill(0).withColumn("day_of_week", date_format($"InvoiceDate", "EEEE")).coalesce(5)
val trainDataFrame = preppedDataFrame.where("InvoiceDate < '2011-07-01'")
val testDataFrame = preppedDataFrame.where("InvoiceDate >= '2011-07-01'")
trainDataFrame.count()
testDataFrame.count()
import org.apache.spark.ml.feature.StringIndexer
val indexer = new StringIndexer().setInputCol("day_of_week").setOutputCol("day_of_week_index")
import org.apache.spark.ml.feature.OneHotEncoder
val encoder = new OneHotEncoder().setInputCol("day_of_week_index").setOutputCol("day_of_week_encoded")
val encoder = new OneHotEncoder().setInputCol("day_of_week_index").setOutputCol("day_of_week_encoded")
import org.apache.spark.ml.feature.VectorAssembler
val vectorAssembler = new VectorAssembler().setInputCols(Array("UnitPrice", "Quantity", "day_of_week_encoded")).setOutputCol("features")
import org.apache.spark.ml.Pipeline
val transformationPipeline = new Pipeline().setStages(Array(indexer, encoder, vectorAssembler))
val fittedPipeline = transformationPipeline.fit(trainDataFrame)
val transformedTraining = fittedPipeline.transform(trainDataFrame)
transformedTraining.cache()
import org.apache.spark.ml.clustering.KMeans
val kmeans = new KMeans().setK(20).setSeed(1L)
val kmModel = kmeans.fit(transformedTraining)
kmModel.computeCost(transformedTraining)

val transformedTest = fittedPipeline.transform(testDataFrame)
