# Make automated Cloud SQL backup retention configurable

Expose the number of retained automated backups as a Terraform input named `retained_backups`.

- Preserve the current default of 14 and keep retention in `COUNT` units.
- Accept whole numbers from 7 to 365 inclusive. Reject values outside that range, fractional values, and null.
- Keep private connectivity, regional HA, TLS, deletion protection, and seven-day point-in-time recovery behavior intact.
- Update the README and add Terraform test coverage for the default, an override of 30, and invalid values.
- Run formatting, validation, and the Terraform tests. Open a PR linked to this issue with the validation results.
