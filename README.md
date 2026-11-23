# Cloud SQL for PostgreSQL · Aiden demo

A reusable Terraform module for a private Cloud SQL for PostgreSQL instance and database. The demo starts from a hardened baseline and exercises two separate Aiden workflows in the Demo workspace.

| Demo | GitHub input | Expected Aiden result |
| --- | --- | --- |
| Module generation | An issue requesting configurable backup retention | A linked PR with Terraform, documentation, and mock tests, plus a passing validation result |
| Enterprise readiness | A separate PR that reduces backup recovery and availability defaults | An Aiden review on the submitted commit with a grade, evidence, and actionable blocking findings |

See [demo setup and acceptance checks](demo/README.md), the [issue request](demo/generation-issue.md), and the [grading rubric](demo/readiness-rubric.md).

## Usage

This module expects the Cloud SQL Admin API to be enabled and the VPC to already have Private Services Access. Configure IAM database users and client permissions in the calling root. Use the instance connection name with a Cloud SQL connector and private network access.

```hcl
module "postgres" {
  source = "./gcp_tf_sql_database"

  project_id      = "example-platform-project"
  region          = "us-central1"
  instance_name   = "orders-postgres"
  database_name   = "orders"
  private_network = "projects/example-platform-project/global/networks/platform"
  labels          = { environment = "demo" }
}
```

The module defaults to PostgreSQL 16, regional high availability, encrypted connections, IAM database authentication, 14 automated backups, and seven days of point-in-time recovery logs. It enables Terraform and Cloud SQL instance deletion protection and preserves the database on module removal. It exposes the instance ID, instance connection name, and database name.

## Validation

```bash
terraform fmt -check -recursive
terraform init -backend=false -input=false
terraform validate
terraform test
```

The tests use a mocked Google provider. Demo validation does not require Google Cloud credentials or provision infrastructure.

- [Google Cloud provider resource reference](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance)
- [Cloud SQL for PostgreSQL security best practices](https://docs.cloud.google.com/sql/docs/postgres/security-best-practices)
