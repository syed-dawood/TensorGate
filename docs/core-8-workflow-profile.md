# Core-8 Workflow Profile

TensorGate runs **eight active automation paths** on normal development. Everything else is manual (`workflow_dispatch`), tag-only, or archived.

## Active workflows (Core-8)

| # | Workflow | Trigger | Purpose |
|---|----------|---------|---------|
| 1 | `ci.yml` | PR → `main` | Build, format, bootstrap guard |
| 2 | `pr-gate.yml` | PR | Branch name, conventional title, readiness |
| 3 | `docs-quality.yml` | PR | Markdown + link checks |
| 4 | `secrets-scan.yml` | PR | Gitleaks on diff |
| 5 | `dependency-review.yml` | PR (manifest paths) | Dependency policy |
| 6 | `issue-pipeline.yml` | Issue open/reopen | Triage + decomposition |
| 7 | `pr-pipeline.yml` | PR | Labels, size, review/QA, traceability |
| 8 | `codeql.yml` | PR | CodeQL (or bootstrap guard) |

## Tier 2 — scheduled / manual (not Core-8)

| Workflow | Trigger |
|----------|---------|
| `security-scheduled.yml` | Weekly + manual (gitleaks full repo, CodeQL, Scorecards) |
| `scorecards.yml` | Manual only (duplicate entry point) |
| `release-drafter.yml` | Manual |
| `sbom.yml` | Manual |
| `stale.yml` | Weekly |
| `project-automation.yml` | Issues (needs `TG_PROJECT_TOKEN`) |
| `release.yml` | Tags |

## Archived (superseded)

Moved to `.github/workflows/_archive/`:

- `branch-name.yml`, `pr-title.yml`, `pr-readiness-gate.yml`
- `labeler.yml`, `pr-size.yml`
- `issue-intelligence.yml`, `issue-decomposition.yml`
- `pr-intelligence.yml`, `traceability-matrix.yml`

GitHub ignores workflows in subfolders; these files are history only.

## Branch protection (required on PR)

- `branch-name` (PR Gate)
- `Validate Conventional PR Title` (PR Gate)
- `readiness` (PR Gate)
- `gitleaks`
- `markdown-lint`, `link-check`
- `Bootstrap CI Guard`
- `Bootstrap CodeQL Guard`

## Local setup

```bash
cd ~/TensorGate
./scripts/setup-local-dev.sh
./scripts/agentic-local-gate.sh
```
