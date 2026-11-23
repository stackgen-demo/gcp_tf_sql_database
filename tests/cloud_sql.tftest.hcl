mock_provider "google" {}

variables {
  project_id      = "example-platform-project"
  region          = "us-central1"
  instance_name   = "demo-postgres"
  database_name   = "app"
  private_network = "projects/example-platform-project/global/networks/demo"
  labels          = { environment = "demo" }
}

run "enterprise_defaults" {
  command = plan

  assert {
    condition = (
      !google_sql_database_instance.this.settings[0].ip_configuration[0].ipv4_enabled &&
      google_sql_database_instance.this.settings[0].ip_configuration[0].private_network == var.private_network &&
      google_sql_database_instance.this.settings[0].ip_configuration[0].ssl_mode == "ENCRYPTED_ONLY"
    )
    error_message = "Cloud SQL must use private networking and require encrypted connections."
  }

  assert {
    condition     = google_sql_database_instance.this.settings[0].availability_type == "REGIONAL"
    error_message = "Cloud SQL must have regional HA."
  }

  assert {
    condition = (
      google_sql_database_instance.this.settings[0].backup_configuration[0].enabled &&
      google_sql_database_instance.this.settings[0].backup_configuration[0].backup_retention_settings[0].retained_backups == 14
    )
    error_message = "Cloud SQL must retain the expected number of automated backups."
  }

  assert {
    condition = (
      google_sql_database_instance.this.settings[0].backup_configuration[0].point_in_time_recovery_enabled
      ? google_sql_database_instance.this.settings[0].backup_configuration[0].transaction_log_retention_days == 7
      : false
    )
    error_message = "Cloud SQL must enable point-in-time recovery with seven days of transaction logs."
  }

  assert {
    condition = (
      google_sql_database_instance.this.deletion_protection &&
      google_sql_database_instance.this.settings[0].deletion_protection_enabled &&
      google_sql_database.this.deletion_policy == "ABANDON"
    )
    error_message = "Protect the instance and preserve the logical database on module removal."
  }

  assert {
    condition = (
      google_sql_database_instance.this.settings[0].user_labels == var.labels &&
      anytrue([for flag in google_sql_database_instance.this.settings[0].database_flags :
      flag.name == "cloudsql.iam_authentication" && flag.value == "on"])
    )
    error_message = "The instance must apply workload labels and enable IAM database authentication."
  }
}

run "reject_invalid_network" {
  command = plan

  variables {
    private_network = "demo"
  }

  expect_failures = [var.private_network]
}
