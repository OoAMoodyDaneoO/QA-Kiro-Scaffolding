# Kiro QA Testing Toolkit

A ready-to-use [Kiro](https://kiro.dev) workspace that automates unit testing, enforces code quality standards, and integrates with SonarQube — all from inside your IDE.

Install it into any project to get automated test generation, quality auditing, and coverage reporting out of the box.

## What's Included

```
.kiro/
├── agents/              # Custom QA agent
│   ├── qa-test-engineer.json
│   └── qa-test-engineer-prompt.md
├── hooks/               # Automated triggers
│   ├── auto-test-on-create.kiro.hook
│   ├── auto-test-on-edit.kiro.hook
│   └── test-coverage-report.kiro.hook
├── skills/              # Reusable agent skills
│   ├── write-unit-tests/
│   ├── review-test-quality/
│   └── fix-failing-tests/
└── steering/            # Project-wide policies
    ├── unit-testing-standards.md
    ├── test-bug-fixing-policy.md
    └── test-evidence-policy.md

powers/
└── sonarqube-testing/   # SonarQube MCP integration (optional)

docs/
└── test-reports/        # Generated reports and audit trail
    ├── coverage/
    ├── gap-analysis/
    └── audit-log.md
```

## Quick Start

### Option A: Install into an existing project (recommended)

Clone this repo, then run the install script pointing at your project:

```bash
# macOS / Linux
git clone https://github.com/YOUR_USERNAME/kiro-qa-toolkit.git
cd kiro-qa-toolkit
chmod +x install.sh
./install.sh /path/to/your/project
```

```powershell
# Windows (PowerShell)
git clone https://github.com/YOUR_USERNAME/kiro-qa-toolkit.git
cd kiro-qa-toolkit
.\install.ps1 -Target C:\path\to\your\project
```

The script copies all files without overwriting anything that already exists, so it's safe to re-run. It will ask whether you want the SonarQube integration.

### Option B: Use this repo directly

1. Clone or fork this repo.
2. Add your project's source code into it.
3. Open in Kiro.

### Option C: Manual copy

Copy the `.kiro/` and `docs/` directories into your project root. That's the only requirement — everything else is optional.

### After install

1. Open the project in [Kiro](https://kiro.dev).
2. Start coding — hooks will automatically generate and update tests as you save files.

No additional setup is needed unless you want SonarQube integration (see below).

## Features

### Automated Test Generation (Hooks)

Hooks run automatically in response to IDE events. No manual intervention required.

| Hook | Trigger | What It Does |
|------|---------|--------------|
| Auto Test on Create | New source file created | Scaffolds a test file with stubs for all exports |
| Auto Test on Edit | Source file saved | Checks for missing test coverage on changed code and adds tests |
| Generate Coverage Report | Manual trigger (user-initiated) | Runs the full suite, generates coverage + gap analysis reports |

Supported file types: `.ts`, `.tsx`, `.js`, `.jsx`, `.py`, `.java`, `.go`, `.cs`

To trigger the coverage report manually, find "Generate Test Coverage Report" in the Agent Hooks section of the Kiro explorer panel and click it.

### QA Test Engineer Agent

A custom agent you can chat with directly for testing tasks. Switch to it from the agent selector in Kiro's chat panel.

It can:
- Write unit tests for any function, class, or module
- Audit existing tests for quality and coverage gaps
- Triage and fix failing tests (following the bug fixing policy)
- Generate coverage and gap analysis reports

Start a conversation with it by selecting "qa-test-engineer" from the agent dropdown.

### Skills

Skills are specialized workflows the agent (or you) can activate on demand:

| Skill | Purpose |
|-------|---------|
| write-unit-tests | Generates tests following FIRST principles, AAA pattern, 95% coverage target |
| review-test-quality | Audits test suites for weak assertions, missing edge cases, test smells |
| fix-failing-tests | Triages failures into categories (code bug / test bug / behavior change / flaky) and fixes the right thing |

### Steering (Policies)

Steering files are always-on rules that guide every agent interaction in the workspace. They enforce:

- **Unit Testing Standards** — FIRST principles, AAA pattern, 95% coverage target, 80% minimum gate, language-specific framework guidance (Vitest/Jest, pytest, JUnit 5, Go testing, xUnit).
- **Test Bug Fixing Policy** — Never silence a failing test. Classify failures into categories A–D and fix the root cause. Prohibited actions include deleting tests, weakening assertions, or skipping without a plan.
- **Test Evidence Policy** — All testing activity is logged in `docs/test-reports/audit-log.md`. Coverage reports and gap analyses are saved with ISO 8601 timestamps for traceability.

## SonarQube Integration (Optional)

The `powers/sonarqube-testing/` directory adds SonarQube/SonarCloud integration via the official SonarSource MCP server.

### Prerequisites

- Docker installed and running
- A SonarQube Server (2025.1+), SonarQube Community Build, or SonarQube Cloud account
- A SonarQube user token

### Setup

1. Copy `powers/sonarqube-testing/` into your workspace (or keep it where it is).
2. Edit `powers/sonarqube-testing/mcp.json` and replace the placeholders:

| Placeholder | Value |
|-------------|-------|
| `YOUR_SONARQUBE_TOKEN` | Your user token (My Account > Security > Generate Token) |
| `YOUR_SONARQUBE_URL` | `https://sonarcloud.io` for Cloud, or your server URL |
| `YOUR_SONARQUBE_ORG` | Your org key (Cloud only — remove for Server) |
| `YOUR_PROJECT_KEY` | Your project key (found in Project Information) |

3. Kiro will pick up the MCP server automatically. You can verify it's connected in the MCP Server view.

### SonarQube Workflows

The power includes three steering guides:

| Guide | Use Case |
|-------|----------|
| inspect-standards | Discover quality gates, rules, and metrics your org enforces |
| analyze-and-fix | Analyze code against SonarQube rules, find issues, fix before CI |
| update-sonarqube | Manage issue statuses, review security hotspots, configure webhooks |

## Test Reports

All generated reports live in `docs/test-reports/`:

```
docs/test-reports/
├── coverage/              # Timestamped coverage reports
│   └── latest.md          # Most recent report
├── gap-analysis/          # What's missing from the test suite
└── audit-log.md           # Append-only log of all testing activity
```

The audit log tracks every test-related action (tests added, bugs fixed, reports generated) with timestamps and actor information.

## Supported Languages

| Language | Test Framework | Coverage Tool |
|----------|---------------|---------------|
| TypeScript / JavaScript | Vitest or Jest | Built-in / istanbul |
| Python | pytest | pytest-cov |
| Java | JUnit 5 + Mockito | JaCoCo |
| Go | testing + testify | go test -cover |
| C# / .NET | xUnit + Moq | coverlet |

The agent auto-detects your project's language and framework from config files (`package.json`, `pyproject.toml`, `pom.xml`, `go.mod`, `*.csproj`).

## Customization

All configuration lives in plain files you can edit:

- **Adjust coverage targets** — edit `.kiro/steering/unit-testing-standards.md`
- **Change hook behavior** — edit the `.kiro/hooks/*.kiro.hook` files (JSON format)
- **Modify the QA agent** — edit `.kiro/agents/qa-test-engineer-prompt.md`
- **Disable a hook** — set `"enabled": false` in the hook file
- **Add new skills** — create a new directory under `.kiro/skills/` with a `SKILL.md`

## Contributing

PRs welcome. If you add a new skill, hook, or steering file, update this README to match.

## License

MIT — see [LICENSE](LICENSE).
