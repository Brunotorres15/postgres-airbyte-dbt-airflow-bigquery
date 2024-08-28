from dags.dbt.dbt_novadrive.cosmos_config import PROFILE_CONFIG, PROJECT_CONFIG

from airflow.operators.dummy import DummyOperator
from airflow.decorators import dag, task
from airflow.providers.airbyte.operators.airbyte import AirbyteTriggerSyncOperator
from airflow.models.baseoperator import chain

from cosmos import DbtTaskGroup, LoadMode, RenderConfig

from pendulum import datetime

CONN_ID = "<sync-airbyte-connection>" # local airbyte connection
AIRFLOW_AIRBYTE_CONN_ID = "airflow_airbyte_conn"


@dag(
    schedule='@hourly',
    catchup=False,
    start_date=datetime(2024, 8, 24),
)

def novadrive_dag():

    start_tasks = DummyOperator(
        task_id = "start_tasks"
    )

    from_source_to_bronze = AirbyteTriggerSyncOperator(
        task_id="from_source_to_bronze",
        connection_id = CONN_ID, # Airbyte UI Connection ID
        airbyte_conn_id = AIRFLOW_AIRBYTE_CONN_ID , # Connection between airflow and airbyte
        asynchronous=False,
    )

    silver_modeling = DbtTaskGroup(
        group_id="silver_modeling",
        project_config=PROJECT_CONFIG,
        profile_config=PROFILE_CONFIG,
        render_config=RenderConfig(
        load_method=LoadMode.DBT_LS,
        select=["path:models/silver"]
    )
    )

    gold_modeling = DbtTaskGroup(
        group_id="gold_modeling",
        project_config=PROJECT_CONFIG,
        profile_config=PROFILE_CONFIG,
        render_config=RenderConfig(
        load_method=LoadMode.DBT_LS,
        select=["path:models/gold"]
    )
    )

    end_tasks = DummyOperator(
        task_id = "end_tasks"
    )


    chain(start_tasks, from_source_to_bronze, silver_modeling, gold_modeling, end_tasks)

novadrive_dag()