variable project_id {
  type        = string
  description = "the project to create the resources"
}



variable phase_config {
  type        = map
  description = "list of pubsub topics and the destination bq datasets / tables to be created for monitoring"
  default = {
    orch-migrate    = {
        schema = "./modules/r66monitor/pubsub-raw.json"
        dataset = "raw2"
    }
    orch-startcdc    = {
        schema = "./modules/r66monitor/pubsub-raw.json"
        dataset = "raw2"
    }
  }
}


variable bq_datasets {
  type        = list
  description = "list of bq datasets to be created "
  default = ["raw2", "sheets", "transforms", "reporting"]
}

variable location {
  type        = string
  description = "bq location"
  default     = "US"
  
}