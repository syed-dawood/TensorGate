# Workflow Cost Optimization Policy

## COST FREEZE (active)

**All automatic Actions and Dependabot version updates are paused.**

| What | State |
|------|--------|
| PR / issue workflows | `workflow_dispatch` only |
| Scheduled security / stale | `workflow_dispatch` only |
| Dependabot | `updates: []` (no new PRs) |
| Tag release workflow | Still on tag push (disable before tagging if needed) |

### Run checks manually

```bash
gh workflow run ci.yml --repo TensorGateLabs/TensorGate
gh workflow run pr-gate.yml --repo TensorGateLabs/TensorGate
```

Or use **Actions → workflow → Run workflow** in GitHub.

### Unfreeze

1. Restore triggers in `.github/workflows/*.yml` (remove `COST FREEZE` blocks; see git history).
2. Restore `.github/dependabot.yml` `updates` section (commented template at bottom of file).
3. Re-enable branch protection required checks when PR CI is turned back on.

---

## Cost Strategy (when unfrozen)

### Tier 1 - Required per PR (fast, merge-blocking)

- CI (build / test / format)
- PR Gate (branch, title, readiness)
- Docs Quality (markdown paths only)
- Secret Scan (PR scope)

### Tier 2 - Manual / scheduled only

- CodeQL, Scorecards, SBOM, Security Scheduled, Stale

### Tier 3 - Manual or issue-only (low runtime)

- Issue Pipeline, Project Automation, PR Pipeline

## Dependabot

Use grouped updates (`dotnet-minors`, `dotnet-majors`, `github-actions`) and low `open-pull-requests-limit` to avoid run explosions.

## Operational

```bash
gh run list --repo TensorGateLabs/TensorGate --limit 50
# Cancel active runs:
for id in $(gh run list --repo TensorGateLabs/TensorGate --status in_progress --json databaseId -q '.[].databaseId'); do
  gh run cancel "$id" --repo TensorGateLabs/TensorGate
done
```
