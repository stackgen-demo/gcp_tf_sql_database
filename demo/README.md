# Demo setup and acceptance checks

Use `stackgen-demo/gcp_tf_sql_database` and the staging Demo Workspace. The Azure proof points are [issue #8](https://github.com/stackgen-demo/azure_tf_sql_database/issues/8) and [PR #9](https://github.com/stackgen-demo/azure_tf_sql_database/pull/9). Keep their repo routing and validation paths active when adding the GCP demo.

## Ready-to-show demo

Follow the GitHub issue through implementation, then walk through the enterprise readiness review on a separate PR.

1. Open [issue #1](https://github.com/stackgen-demo/gcp_tf_sql_database/issues/1) and follow its result comment to [generation PR #3](https://github.com/stackgen-demo/gcp_tf_sql_database/pull/3).
2. Open [inbound PR #2](https://github.com/stackgen-demo/gcp_tf_sql_database/pull/2) and read the [D-grade enterprise review](https://github.com/stackgen-demo/gcp_tf_sql_database/pull/2#pullrequestreview-6018507240).

## Aiden wiring

- In `terraform-module-update`, which generated Azure PR #9, scope the GitHub issue route to the exact GCP repository in addition to the existing Azure route. Reuse the workspace’s authorized GitHub integration, runner, and model. Use the GCP module at the repository root. Accept an issue opened by a trusted demo operator and permit writes only to the GCP demo repository and generated branches.
- In `terraform-module-pr-review`, which graded Azure PR #9, add the same exact repository to the PR route. Pass the PR number, base SHA, and head SHA. For this repository, use the [GCP rubric](readiness-rubric.md) from the trusted base branch. Review PRs opened, reopened, or updated, and post to the matching PR. Keep this route review-only.
- Route GitHub deliveries through the same authenticated ingress mechanism verified for the Azure demo. Before adding the new repo, confirm the two live workflow names, event filters, GitHub permissions, and runner reachability. Confirm that delivery retries do not create duplicate generation PRs or duplicate grades for the same PR head.
- Allowlist regular GitHub event origins through the existing authenticated receiver. Keep the read-only `validate.yml` independent from Aiden so CI results can corroborate Aiden’s report.

## Module generation

Open a GitHub issue from [generation-issue.md](generation-issue.md). Confirm the GitHub delivery reaches the issue workflow and the Aiden run opens a linked PR. Check that the PR defaults to 14 retained backups, accepts 30, rejects invalid input, and preserves the rest of the module behavior. Verify the Aiden run and the PR validation check.

## Enterprise readiness

Open the local `demo/readiness-review` branch as a PR to `main`. It proposes zonal availability and removes PITR configuration while retaining private connectivity, encryption, and automated backups. The change is designed to pass formatting and schema validation and fail the enterprise defaults test. Confirm Aiden posts a blocking grade of D or F with evidence for the loss of PITR and regional HA, identifies the failing check, and recommends restoring the original controls. Leave the demo PR unmerged.
