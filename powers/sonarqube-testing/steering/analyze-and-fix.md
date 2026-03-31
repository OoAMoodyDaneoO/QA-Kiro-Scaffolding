# Analyze Code and Fix Issues

This guide covers analyzing your code against SonarQube standards, finding issues, and resolving them before they reach CI. Use this after you've inspected your standards (see `inspect-standards` steering file).

## Analyze Code Before Committing

### Analyze a File or Snippet

The primary analysis tool lets you check code against SonarQube's analyzers locally:

**Tool:** `analyze_code_snippet`
- `projectKey` - your project key
- `filePath` - project-relative path (e.g., `src/main/java/MyClass.java`) when workspace is mounted
- `fileContent` - full file content as string (only needed if workspace is NOT mounted)
- `codeSnippet` - optional snippet to filter results to just that section
- `language` - language hint (e.g., `java`, `python`, `javascript`)
- `scope` - `MAIN` or `TEST` (default: MAIN)

When the workspace is mounted (recommended), just pass `filePath` and the server reads the file directly — no need to paste file content into the conversation.

**Supported languages:** Java, Kotlin, Python, Ruby, Go, JavaScript, TypeScript, JSP, PHP, XML, HTML, CSS, CloudFormation, Kubernetes, Terraform, Azure Resource Manager, Ansible, Docker, Secrets detection.

### Analyze Multiple Files

For broader analysis using SonarQube for IDE integration:

**Tool:** `analyze_file_list`
- `file_absolute_paths` - array of absolute file paths to analyze

This requires SonarQube for IDE to be running and the `SONARQUBE_IDE_PORT` env var to be set.

## Find and Triage Issues

### Search for Issues

**Tool:** `search_sonar_issues_in_projects`
- `projects` - list of project keys
- `pullRequestId` - filter to a specific PR
- `severities` - filter by severity: `INFO`, `LOW`, `MEDIUM`, `HIGH`, `BLOCKER`
- `impactSoftwareQualities` - filter by: `MAINTAINABILITY`, `RELIABILITY`, `SECURITY`
- `issueStatuses` - filter by: `OPEN`, `CONFIRMED`, `FALSE_POSITIVE`, `ACCEPTED`, `FIXED`
- `issueKey` - fetch a specific issue by key

**Recommended approach:**
1. Start with `severities: ["BLOCKER", "HIGH"]` to focus on critical issues first
2. Filter by `impactSoftwareQualities: ["SECURITY"]` for security-focused review
3. Use `pullRequestId` to see only issues introduced in your PR

### Understand a Rule Behind an Issue

When you find an issue and want to understand the rule:

**Tool:** `show_rule`
- `key` - the rule key from the issue (e.g., `java:S2259`)

This gives you the full explanation, why it matters, and how to fix it.

## Improve Test Coverage

### Find Files with Low Coverage

**Tool:** `search_files_by_coverage`
- `projectKey` - your project key
- `pullRequest` - optional PR ID
- `maxCoverage` - only return files with coverage at or below this percentage (e.g., `50`)

Results are sorted ascending (worst coverage first), so you immediately see what needs attention.

### Get Line-by-Line Coverage Details

Once you've identified a file with low coverage:

**Tool:** `get_file_coverage_details`
- `key` - file key (e.g., `my_project:src/foo/Bar.java`)
- `pullRequest` - optional PR ID
- `from` / `to` - optional line range to focus on

This shows exactly which lines are uncovered and which branches are partially covered, so you know precisely where to add tests.

## Review Security Hotspots

Security hotspots are code that needs manual review to determine if it's safe.

### Search for Hotspots

**Tool:** `search_security_hotspots`
- `projectKey` - your project key
- `status` - `TO_REVIEW` or `REVIEWED`
- `pullRequest` - optional PR filter
- `files` - optional file path filter
- `onlyMine` - show only hotspots assigned to you

### Get Hotspot Details

**Tool:** `show_security_hotspot`
- `hotspotKey` - the hotspot key

Returns rule details, code context, data flows, and any existing comments.

## Find Code Duplications

### Search for Duplicated Files

**Tool:** `search_duplicated_files`
- `projectKey` - your project key
- `pullRequest` - optional PR filter

### Get Duplication Details

**Tool:** `get_duplications`
- `key` - file key
- `pullRequest` - optional PR ID

## Check Quality Gate Before Merging

Before merging a PR, verify the quality gate:

**Tool:** `get_project_quality_gate_status`
- `projectKey` - your project key
- `pullRequest` - your PR ID

If the gate is failing, use the tools above to find and fix the specific issues causing the failure.

## Recommended Fix Workflow

1. Run `get_project_quality_gate_status` with your PR ID to see if you're passing
2. If failing, run `search_sonar_issues_in_projects` filtered to your PR to see new issues
3. For each issue, use `show_rule` to understand the fix
4. Run `search_files_by_coverage` to find coverage gaps
5. Use `get_file_coverage_details` on low-coverage files to see exactly what to test
6. Run `search_security_hotspots` with `status: TO_REVIEW` to check for security concerns
7. After fixing, re-run `analyze_code_snippet` on changed files to verify locally
8. Check `get_project_quality_gate_status` again to confirm the gate passes
