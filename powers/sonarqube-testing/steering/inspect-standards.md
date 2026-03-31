# Inspect SonarQube Testing Standards

This guide walks you through discovering and understanding the quality standards your organization has defined in SonarQube. Use this before writing or reviewing code to know exactly what rules and gates apply.

## Step 1: Discover Your Projects

Start by listing the projects available in your SonarQube instance:

**Tool:** `search_my_sonarqube_projects`

This returns your projects with their keys. Note the project key for the project you're working on — most other tools need it.

## Step 2: Check Quality Gate Status

Quality gates are the pass/fail criteria your organization defines. Check the current status:

**Tool:** `get_project_quality_gate_status`
- `projectKey` - your project key

This tells you whether your project is currently passing or failing the quality gate, and which conditions are not met (e.g., coverage below threshold, too many new bugs).

## Step 3: List Quality Gate Definitions

To see all quality gates defined in your organization:

**Tool:** `list_quality_gates`

This shows the gate names, conditions, and thresholds. Understanding these is critical — they define what "passing" means for your code.

## Step 4: Browse Rules

Rules are the individual checks SonarQube runs against your code. To understand a specific rule:

**Tool:** `show_rule`
- `key` - the rule key (e.g., `java:S1135`, `python:S5754`)

This returns the rule description, severity, impact on software qualities (maintainability, reliability, security), and remediation guidance.

## Step 5: Check Available Metrics

Metrics quantify aspects of your code. To see what metrics are available:

**Tool:** `search_metrics`

Common metrics include:
- `ncloc` - lines of code
- `coverage` - test coverage percentage
- `bugs`, `vulnerabilities`, `code_smells` - issue counts
- `duplicated_lines_density` - duplication percentage
- `complexity` - cyclomatic complexity

## Step 6: Get Current Project Measures

To see how your project scores on specific metrics:

**Tool:** `get_component_measures`
- `component` - your project key
- `metricKeys` - comma-separated metrics (e.g., `coverage,bugs,vulnerabilities,code_smells,duplicated_lines_density`)

This gives you the current state of your project against the metrics your organization tracks.

## Step 7: Review Pull Request Status

If you're working on a PR, check its specific quality:

**Tool:** `list_pull_requests`
- `projectKey` - your project key

Then use the PR key with:

**Tool:** `get_project_quality_gate_status`
- `projectKey` - your project key
- `pullRequest` - the PR ID

## Step 8: Check Supported Languages

To see which languages SonarQube can analyze in your instance:

**Tool:** `list_languages`

## Recommended Inspection Workflow

1. Run `search_my_sonarqube_projects` to find your project
2. Run `list_quality_gates` to understand the pass/fail criteria
3. Run `get_project_quality_gate_status` to see current status
4. Run `get_component_measures` with key metrics to get the numbers
5. If any conditions are failing, use `show_rule` on the specific rules to understand what needs fixing
6. Use the `analyze-and-fix` steering file to address any issues found
