variable "project_id" {
  description = "Google Cloud project ID for the instance."
  type        = string
  nullable    = false
}

variable "region" {
  description = "Google Cloud region for the primary instance and standby."
  type        = string
  nullable    = false
}

variable "instance_name" {
  description = "Cloud SQL instance name, unique within the project."
  type        = string
  nullable    = false
}

variable "database_name" {
  description = "Name of the PostgreSQL database within the instance."
  type        = string
  nullable    = false
}

variable "private_network" {
  description = "VPC resource name in projects/PROJECT/global/networks/NETWORK form, with Private Services Access configured."
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^projects/[^/]+/global/networks/[^/]+$", var.private_network))
    error_message = "Use projects/PROJECT/global/networks/NETWORK for private_network."
  }
}

variable "tier" {
  description = "Cloud SQL Enterprise machine tier that supports regional availability."
  type        = string
  default     = "db-custom-2-7680"
  nullable    = false
}

variable "labels" {
  description = "Labels applied to the Cloud SQL instance."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "retained_backups" {
  description = "Number of automated Cloud SQL backups to retain."
  type        = number
  default     = 14

  validation {
    condition = var.retained_backups == null ? false : (
      var.retained_backups >= 7 &&
      var.retained_backups <= 365 &&
      floor(var.retained_backups) == var.retained_backups
    )
    error_message = "retained_backups must be a whole number from 7 through 365."
  }
}
