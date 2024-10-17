

"""

### DAG ETL

This DAG is demonstrating an Extract -> Transform -> Load pipeline

"""


from __future__ import annotations


# [START import_module]

import json

from datetime import datetime

import textwrap


# The DAG object - needed to instantiate a DAG

from airflow import DAG

# Operators - needed to operate

from airflow.operators.python import PythonOperator

# Utils

from airflow.utils.dates import days_ago


# [END import_module]


# [START instantiate_dag]

with DAG(

    "etl_dag_airflow",

    # [START default_args]

    # args passed on to each operator

    default_args={"owner": "airflow", "retries": 2},

    # [END default_args]

    description="DAG ETL",

    schedule=None,  #"@daily"

    start_date=days_ago(2),

    catchup=False,

    tags=["etl_dag_airflow"],

) as dag:

    # [END instantiate_dag]

    # [START documentation]

    dag.doc_md = __doc__

    # [END documentation]


    # [START extract_function]

    def extract(**kwargs):

        ti = kwargs["ti"]
                
        marketing_data = {
            "marketing_campaign": {
                "name": "Summer Sale",
                "start_date": "2024-08-15",
                "end_date": "2024-08-18",
                "budget": 10000,
                "spend": [
                    {"date": "2024-08-15",
                    "amount": 1500
                    },
                    {"date": "2024-08-16",
                    "amount": 1200
                    },
                    {"date": "2024-08-17",
                    "amount": 2000
                    },
                    {"date": "2024-08-18",
                    "amount": 3000
                    },                    
                ],
                "conversions": [
                    {"date": "2024-08-15",
                    "number": 75
                    },
                    {"date": "2024-08-16",
                    "number": 50
                    },
                    {"date": "2024-08-17",
                    "number": 100
                    },
                    {"date": "2024-08-18",
                    "number": 200
                    },                    
                ],
                "clicks": [
                    {"date": "2024-08-15",
                    "number": 100
                    },
                    {"date": "2024-08-16",
                    "number": 60
                    },
                    {"date": "2024-08-17",
                    "number": 150
                    },
                    {"date": "2024-08-18",
                    "number": 225
                    },                    
                ],
            }
        }
        

        ti.xcom_push("marketing_data", json.dumps(marketing_data))


    # [END extract_function]


    # [START transform_function]

    def transform(**kwargs):

        ti = kwargs["ti"]

        extract_data = ti.xcom_pull(task_ids="extract", key="marketing_data")

        marketing_data = json.loads(extract_data)['marketing_campaign']

        # calculate KPIs
        total_spend = sum([spend['amount'] for spend in marketing_data['spend']])
        
        date_format = '%Y-%m-%d'
        end_date = datetime.strptime(marketing_data['end_date'], date_format)
        start_date = datetime.strptime(marketing_data['start_date'], date_format)
        num_days = (end_date - start_date).days + 1
        avg_spend_per_day = total_spend / num_days
                     
        total_conversions = sum([conversion['number'] for conversion in marketing_data['conversions']]) 
        
        total_clicks = sum([click['number'] for click in marketing_data['clicks']]) 
        conversion_rate = total_conversions / total_clicks
                           
        kpis = {"total_spend": total_spend, "average_spend_per_day": avg_spend_per_day, "total_conversions": total_conversions, "conversion_rate": conversion_rate}        

        ti.xcom_push("kpis", json.dumps(kpis))


    # [END transform_function]


    # [START load_function]

    def load(**kwargs):

        ti = kwargs["ti"]

        transform_data = ti.xcom_pull(task_ids="transform", key="kpis")

        kpis = json.loads(transform_data)
        
        print(f"Total spend: {kpis['total_spend']}.")
        print(f"Average spend per day: {kpis['average_spend_per_day']}.")
        print(f"Total conversions: {kpis['total_conversions']}.")
        print(f"Conversion rate: {kpis['conversion_rate']}.")
        

    # [END load_function]


    # [START main_flow]

    extract_task = PythonOperator(

        task_id="extract",

        python_callable=extract,

    )

    extract_task.doc_md = textwrap.dedent(

        """\

    #### Extract task

    A simple Extract task to get data for the rest of the data pipeline.

    In this case, getting data is simulated by reading from a hardcoded JSON string.

    This data is then put into xcom, so that it can be processed by the next task.

    """

    )


    transform_task = PythonOperator(

        task_id="transform",

        python_callable=transform,

    )

    transform_task.doc_md = textwrap.dedent(

        """\

    #### Transform task

    A simple Transform task which takes in the collection of marketing data from xcom

    and computes Key Performance Indicators, including spend and conversions per campaign.

    These computed values are then put into xcom, so the data can be processed by the next task.

    """

    )


    load_task = PythonOperator(

        task_id="load",

        python_callable=load,

    )

    load_task.doc_md = textwrap.dedent(

        """\

    #### Load task

    A simple Load task which takes in the result of the Transform task, by reading it

    from xcom and instead of saving it to database, just prints it out.

    """

    )


    extract_task >> transform_task >> load_task


# [END main_flow]



