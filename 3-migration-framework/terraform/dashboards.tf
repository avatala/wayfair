
variable dashboard_files {
    default = {
        # Location of each json file for the dashboards
        dvt                ="./dashboards/dvt.json"
    }
}

resource "google_monitoring_dashboard" "dashboard" {
    depends_on = [google_logging_metric.source_agg_count, google_logging_metric.target_agg_count, google_logging_metric.difference, google_logging_metric.pct_difference ]
    for_each   = var.dashboard_files
    dashboard_json = file("${each.value}")
    project        = module.migration_project.project_id
}