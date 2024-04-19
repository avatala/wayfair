variable iam_roles {
  type        = list
  description = "list of services to enable on the project"
  default = ["roles/editor"]
}

variable group_email {
  type        = string
  description = "the google group to receive the iam perms"
}

variable project_id {
  type        = string
  description = "the project id"
}


resource "google_project_iam_member" "group_iam" {
  project = var.project_id
  for_each = toset(var.iam_roles)
  role    = each.key
  member  = "group:${var.group_email}"
}
