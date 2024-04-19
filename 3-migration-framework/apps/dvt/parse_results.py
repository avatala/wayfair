import json

filename = "parse_results.json"
with open(filename, "r") as file:
    results_json = json.loads(file.read())
# print(results_json)

output = {}
output["validation_name"] = results_json.get("validation_name").get("0")
output["validation_type"] = results_json.get("validation_type").get("0")
output["aggregation_type"] = results_json.get("aggregation_type").get("0")
output["group_by_columns"] = results_json.get("group_by_columns").get("0")
output["primary_keys"] = results_json.get("primary_keys").get("0")
output["difference"] = results_json.get("difference").get("0")
output["pct_difference"] = results_json.get("pct_difference").get("0")
output["validation_status"] = results_json.get("validation_status").get("0")
output["run_id"] = results_json.get("run_id").get("0")

output["source_table_name"] = results_json.get("source_table_name").get("0")
output["source_column_name"] = results_json.get("source_column_name").get("0")
output["source_agg_value"] = results_json.get("source_agg_value").get("0")

output["target_table_name"] = results_json.get("target_table_name").get("0")
output["target_column_name"] = results_json.get("target_column_name").get("0")
output["target_agg_value"] = results_json.get("target_agg_value").get("0")

print(output)
