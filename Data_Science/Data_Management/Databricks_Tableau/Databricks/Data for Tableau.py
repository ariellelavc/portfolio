# Databricks notebook source
# MAGIC %sql
# MAGIC SELECT current_catalog();

# COMMAND ----------

# MAGIC %sql
# MAGIC CREATE SCHEMA IF NOT EXISTS tableau;

# COMMAND ----------

display(dbutils.fs.ls('/databricks-datasets/nyctaxi-with-zipcodes/subsampled'))

# COMMAND ----------

zip_raw = spark.read.format('delta').option("header", "true").load("dbfs:/databricks-datasets/nyctaxi-with-zipcodes/subsampled")

# COMMAND ----------

# MAGIC %sql
# MAGIC CREATE TABLE IF NOT EXISTS tableau.tripdata_zipcodes OPTIONS (PATH '/databricks-datasets/nyctaxi-with-zipcodes/subsampled');

# COMMAND ----------

# MAGIC %sql
# MAGIC SELECT Count(*) FROM tableau.tripdata_zipcodes

# COMMAND ----------

# MAGIC %sql
# MAGIC SELECT * FROM tableau.tripdata_zipcodes LIMIT 5;
