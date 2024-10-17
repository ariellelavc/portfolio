# Databricks notebook source
# MAGIC %md
# MAGIC #### Install Databricks SDK

# COMMAND ----------

# MAGIC %pip install databricks-sdk --upgrade

# COMMAND ----------

dbutils.library.restartPython()

# COMMAND ----------

# MAGIC %pip show databricks-sdk | grep -oP '(?<=Version: )\S+'

# COMMAND ----------

# MAGIC %md
# MAGIC #### Create a Databricks job

# COMMAND ----------

from databricks.sdk import WorkspaceClient
from databricks.sdk.service.jobs import Task, NotebookTask, Source

w = WorkspaceClient()

job_name = "Databricks SDK Job"
description = "Databricks SDK Job to Run a Delta Live Tables Data Pipeline"
existing_cluster_id = "dlt"
notebook_path = "/Users/xxx@xxxxx.xxx/Delta Live Tables - Python"
task_key = "dlt_task"

print("Attempting to create the job. Please wait...\n")

j = w.jobs.create(
    name = job_name,
    tasks = [
        Task(
            description = description,
            existing_cluster_id = existing_cluster_id,
            notebook_task = NotebookTask(
                base_parameters=dict(""),
                notebook_path=notebook_path,
                source=Source("WORKSPACE")
            ),
            task_key = task_key
        )
    ]
)

print(f"View the job at {w.config.host}/#job/{j.job_id}\n")

# COMMAND ----------

# MAGIC %md
# MAGIC #### Run, cancel, and delete the job

# COMMAND ----------

run_now_response = w.jobs.run_now(job_id=j.job_id)

cancelled_run = w.jobs.cancel_run(run_id=run_now_response.response.run_id).result()

# cleanup
w.jobs.delete(job_id=j.job_id)
