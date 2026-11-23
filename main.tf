resource "google_sql_database_instance" "this" {
  project             = var.project_id
  region              = var.region
  name                = var.instance_name
  database_version    = "POSTGRES_16"
  deletion_protection = true

  settings {
    edition                     = "ENTERPRISE"
    tier                        = var.tier
    availability_type           = "REGIONAL"
    deletion_protection_enabled = true
    disk_autoresize             = true
    user_labels                 = var.labels

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.private_network
      ssl_mode        = "ENCRYPTED_ONLY"
    }

    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = true
      transaction_log_retention_days = 7

      backup_retention_settings {
        retained_backups = var.retained_backups
        retention_unit   = "COUNT"
      }
    }

    database_flags {
      name  = "cloudsql.iam_authentication"
      value = "on"
    }
  }
}

resource "google_sql_database" "this" {
  project         = var.project_id
  instance        = google_sql_database_instance.this.name
  name            = var.database_name
  deletion_policy = "ABANDON"
}
