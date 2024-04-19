# log based metrics for the dashboards
resource "google_logging_metric" "source_agg_count" {
    
    project = module.migration_project.project_id
    name   = "source-agg-count"
    filter = "resource.type=cloud_run_revision"
    metric_descriptor {
        metric_kind = "DELTA"
        value_type  = "DISTRIBUTION"
        unit        = "1"
        display_name = "source-agg-count"
    
        labels {
          key         = "source_table_name"
          value_type  = "STRING"
          description = "source table name"
        }
        labels {
          key         = "source_database"
          value_type  = "STRING"
          description = "Sorce database"
        }
        labels {
          key         = "environment"
          value_type  = "STRING"
          description = "environment"
        }
        labels {
          key         = "aggregation_type"
          value_type  = "STRING"
          description = "agrregation type"
        }

    }
    
    value_extractor = "REGEXP_EXTRACT(jsonPayload.source_agg_value, \"(-?[0-9.]+)\")"
    label_extractors = {
        source_table_name = "EXTRACT(jsonPayload.source_table_name)"
        source_database = "EXTRACT(jsonPayload.source_database)"
        environment = "EXTRACT(jsonPayload.environment)"
        aggregation_type = "EXTRACT(jsonPayload.aggregation_type)"
    }

    bucket_options {
        exponential_buckets {
            num_finite_buckets = 64
            growth_factor      = 2.0
            scale                 = 0.01
        }
    }
}

resource "google_logging_metric" "target_agg_count" {
   
    project = module.migration_project.project_id
    name   = "target-agg-count"
    filter = "resource.type=cloud_run_revision"
    metric_descriptor {
        metric_kind = "DELTA"
        value_type  = "DISTRIBUTION"
        unit        = "1"
        display_name = "target-agg-count"

        labels {
          key         = "source_table_name"
          value_type  = "STRING"
          description = "source table name"
        }
        labels {
          key         = "source_database"
          value_type  = "STRING"
          description = "Sorce database"
        }
        labels {
          key         = "environment"
          value_type  = "STRING"
          description = "environment"
        }
        labels {
          key         = "aggregation_type"
          value_type  = "STRING"
          description = "agrregation type"
        }
    }
    value_extractor = "REGEXP_EXTRACT(jsonPayload.target_agg_value, \"(-?[0-9.]+)\")"
    label_extractors = {
        source_table_name = "EXTRACT(jsonPayload.source_table_name)"
        source_database = "EXTRACT(jsonPayload.source_database)"
        environment = "EXTRACT(jsonPayload.environment)"
        aggregation_type = "EXTRACT(jsonPayload.aggregation_type)"
    }

    bucket_options {
        exponential_buckets {
            num_finite_buckets = 64
            growth_factor      = 2.0
            scale              = 0.01
        }
    }

}

resource "google_logging_metric" "pct_difference" {
    project = module.migration_project.project_id
    name   = "pct-difference"
    filter = "resource.type=cloud_run_revision"
    metric_descriptor {
        metric_kind = "DELTA"
        value_type  = "DISTRIBUTION"
        unit        = "1"
        display_name = "pct-difference"
        labels {
          key         = "source_table_name"
          value_type  = "STRING"
          description = "source table name"
        }
        labels {
          key         = "source_database"
          value_type  = "STRING"
          description = "Sorce database"
        }
        labels {
          key         = "environment"
          value_type  = "STRING"
          description = "environment"
        }
        labels {
          key         = "aggregation_type"
          value_type  = "STRING"
          description = "agrregation type"
        }
    }
    value_extractor = "REGEXP_EXTRACT(jsonPayload.pct_difference, \"(-?[0-9.]+)\")"
    label_extractors = {
        source_table_name = "EXTRACT(jsonPayload.source_table_name)"
        source_database = "EXTRACT(jsonPayload.source_database)"
        environment = "EXTRACT(jsonPayload.environment)"
        aggregation_type = "EXTRACT(jsonPayload.aggregation_type)"
    }

    bucket_options {
        exponential_buckets {
            num_finite_buckets = 64
            growth_factor      = 2.0
            scale              = 0.01
        }
    }

}

resource "google_logging_metric" "difference" {
   
    project = module.migration_project.project_id
    name   = "difference"
    filter = "resource.type=cloud_run_revision"
    metric_descriptor {
        metric_kind = "DELTA"
        value_type  = "DISTRIBUTION"
        unit        = "1"
        display_name = "difference"

       
        labels {
          key         = "source_table_name"
          value_type  = "STRING"
          description = "source table name"
        }
        labels {
          key         = "source_database"
          value_type  = "STRING"
          description = "Sorce database"
        }
        labels {
          key         = "environment"
          value_type  = "STRING"
          description = "environment"
        }
        labels {
          key         = "aggregation_type"
          value_type  = "STRING"
          description = "agrregation type"
        }
    }
    value_extractor = "REGEXP_EXTRACT(jsonPayload.difference, \"(-?[0-9.]+)\")"
    label_extractors = {
        source_table_name = "EXTRACT(jsonPayload.source_table_name)"
        source_database = "EXTRACT(jsonPayload.source_database)"
        environment = "EXTRACT(jsonPayload.environment)"
        aggregation_type = "EXTRACT(jsonPayload.aggregation_type)"
    }

    bucket_options {
        exponential_buckets {
            num_finite_buckets = 64
            growth_factor      = 2.0
            scale              = 0.01
        }
    }

}


