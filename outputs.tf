output "instance_connection_name" {
  description = "Connection name for the Cloud SQL Auth Proxy and language connectors."
  value       = google_sql_database_instance.this.connection_name
}

output "instance_id" {
  description = "Cloud SQL instance resource ID."
  value       = google_sql_database_instance.this.id
}

output "database_name" {
  description = "Name of the provisioned PostgreSQL database."
  value       = google_sql_database.this.name
}
