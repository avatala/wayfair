#!/bin/bash

# Just Tom
# Validate BigQuery dataset

# create BQ connections for source and target
for project in $1 $3; do
  conn_name="my_bq_conn_$(echo $project | tr -d ' ')"
  data-validation connections add --connection-name $conn_name BigQuery --project-id $project
done

# get all tables from source dataset
# perform both column and schema validation for every table in the given dataset
bq ls --max_results 100 $1:$2 | tail -n +3 | tr -s ' ' | cut -d' ' -f2 | while read -r line; dothank
  tbls="$1.$2.$line=$3.$4.$line"
  data-validation validate column -sc my_bq_conn_source -tc my_bq_conn_target -bqrh $5 -tbls $tbls ${@:6}
  data-validation validate schema -sc my_bq_conn_source -tc my_bq_conn_target -bqrh $5 -tbls $tbls
done
