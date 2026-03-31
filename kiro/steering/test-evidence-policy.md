---
inclusion: always
---

# Test Evidence & Documentation Policy

All testing activity must be documented and traceable. This policy defines where test evidence lives, what it contains, and how it is maintained.

## Report Location

All test reports are stored in `docs/test-reports/` at the repository root.

Directory structure:
```
docs/test-reports/
├── coverage/                  # Coverage reports (timestamped)
│   ├── 2026-03-31T14-30-00Z.md
│   └── latest.md             # Symlink or copy of most recent report
├── gap-analysis/              # Coverage gap analysis reports
│   └── 2026-03-31T14-30-00Z.md
└── audit-log.md               # Running log of all test activities
```

## Coverage Report Format

Each coverage report must contain:

```markdown
# Test Coverage Report

- Generated: [ISO 8601 timestamp]
- Commit: [git commit hash]
- Branch: [branch name]
- Generator: [tool used, e.g., vitest, pytest-cov, jacoco]

## Summary

| Metric          | Value  | Target | Status |
|-----------------|--------|--------|--------|
| Line Coverage   | XX.X%  | 95%    | ✅/❌  |
| Branch Coverage | XX.X%  | 95%    | ✅/❌  |
| Function Coverage| XX.X% | 95%    | ✅/❌  |
| Total Tests     | NNN    | —      | —      |
| Passing         | NNN    | —      | —      |
| Failing         | NNN    | 0      | ✅/❌  |
| Skipped         | NNN    | 0      | ✅/❌  |

## Files Below Threshold

[List any files below 80% coverage with their current percentage]

## Critical Path Coverage

[List critical modules (auth, payments, security) with their coverage]

## Uncovered Lines

[Top 10 files with the most uncovered lines, with line numbers]
```

## Gap Analysis Report Format

Gap analysis identifies what is missing from the test suite:

```markdown
# Test Gap Analysis

- Generated: [ISO 8601 timestamp]
- Commit: [git commit hash]
- Analyzer: [human/agent/tool]

## Untested Modules

[List modules with no corresponding test file]

## Untested Exports

[List exported functions/classes with no test coverage]

## Missing Edge Cases

[List functions that have tests but are missing boundary/error case coverage]

## Recommendations

[Prioritized list of what to test next, ordered by risk]
```

## Audit Log

The audit log (`docs/test-reports/audit-log.md`) is an append-only record of testing activities:

```markdown
# Test Audit Log

| Timestamp | Action | Actor | Details |
|-----------|--------|-------|---------|
| 2026-03-31T14:30:00Z | Coverage Report | agent | 92.3% line, 88.1% branch |
| 2026-03-31T15:00:00Z | Tests Added | developer | Added 12 tests for auth module |
| 2026-03-31T16:00:00Z | Bug Fix | agent | Fixed Category A failure in payment calc |
```

Entries must include:
- ISO 8601 timestamp
- Action type (Coverage Report, Tests Added, Tests Updated, Bug Fix, Gap Analysis, Test Deleted)
- Actor (developer name, agent, or CI)
- Brief description of what happened

## When to Generate Reports

- Coverage report: after every significant test suite change, before PRs, and on demand via manual hook
- Gap analysis: when starting work on a new module, during sprint planning, or on demand
- Audit log: updated automatically whenever tests are added, modified, or deleted

## Retention

- Keep all timestamped reports in version control
- The `latest.md` file always reflects the most recent report
- Do not delete historical reports — they provide a timeline of quality improvement

## Integration with CI/CD

If the project has CI/CD:
- Coverage reports should also be generated in CI and compared against the gate threshold
- CI should fail if coverage drops below 80%
- CI should warn if coverage drops below 95%
- The CI-generated report can be committed back to `docs/test-reports/coverage/` automatically
