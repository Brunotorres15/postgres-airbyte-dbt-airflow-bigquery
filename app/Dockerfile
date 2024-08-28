FROM quay.io/astronomer/astro-runtime:12.0.0

RUN python -m pip install \
  dbt-core \
  dbt-postgres \
  dbt-bigquery

COPY requirements.txt /requirements.txt

RUN pip install -r requirements.txt


