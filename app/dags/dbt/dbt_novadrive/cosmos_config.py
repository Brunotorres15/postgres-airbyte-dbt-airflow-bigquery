from cosmos.config import ProfileConfig, ProjectConfig
from pathlib import Path

PROFILE_CONFIG = ProfileConfig(
    profile_name="dbt_novadrive",
    target_name="dev",

    profiles_yml_filepath=Path('/usr/local/airflow/dags/dbt/dbt_novadrive/profiles.yml')
)


PROJECT_CONFIG = ProjectConfig(
    dbt_project_path="/usr/local/airflow/dags/dbt/dbt_novadrive/",
)