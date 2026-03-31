# Update SonarQube Configuration

This guide covers updating SonarQube when project-level constraints require changes. Use this when you need to manage issue statuses, review security hotspots, or configure webhooks.

**Important:** These are write operations that modify your SonarQube instance. Ensure you have the appropriate permissions and understand the impact before proceeding.

## Manage Issue Statuses

When a project has legitimate reasons to change an issue's status (e.g., a rule doesn't apply in a specific context, or an issue is a false positive):

### Accept an Issue

Use when the issue is real but you've decided to accept the risk for this project:

**Tool:** `change_sonar_issue_status`
- `key` - the issue key
- `status` - `accept`

### Mark as False Positive

Use when the issue is incorrectly flagged and doesn't actually apply:

**Tool:** `change_sonar_issue_status`
- `key` - the issue key
- `status` - `falsepositive`

### Reopen an Issue

Use when a previously accepted or false-positive issue should be reconsidered:

**Tool:** `change_sonar_issue_status`
- `key` - the issue key
- `status` - `reopen`

### Best Practices for Issue Management

- Always document why you're changing a status (use comments in SonarQube)
- Prefer `falsepositive` only when the detection is genuinely wrong
- Use `accept` when the issue is real but the risk is acceptable for your project
- Periodically review accepted and false-positive issues to ensure they're still valid
- Avoid bulk-accepting issues without individual review

## Review Security Hotspots

Security hotspots require human review to determine if the code is safe.

### Mark a Hotspot as Reviewed

**Tool:** `change_security_hotspot_status`
- `hotspotKey` - the hotspot key
- `status` - `REVIEWED`
- `resolution` - one of:
  - `FIXED` - the security issue has been fixed
  - `SAFE` - the code is safe as-is, no vulnerability exists
  - `ACKNOWLEDGED` - the risk is known and accepted
- `comment` - explain your reasoning (recommended)

### Send a Hotspot Back for Review

**Tool:** `change_security_hotspot_status`
- `hotspotKey` - the hotspot key
- `status` - `TO_REVIEW`
- `comment` - explain why it needs re-review

### Best Practices for Hotspot Reviews

- Always include a comment explaining your resolution
- Use `SAFE` only when you've verified the code doesn't introduce a vulnerability
- Use `FIXED` when you've made code changes to address the concern
- Use `ACKNOWLEDGED` sparingly — it means you know the risk exists but accept it
- Have security-sensitive hotspots reviewed by a second person when possible

## Manage Webhooks

Webhooks let you integrate SonarQube events with other systems (CI/CD, chat notifications, etc.).

### Create a Webhook

**Tool:** `create_webhook`
- `name` - descriptive name for the webhook
- `url` - the endpoint URL to receive events
- `projectKey` - optional, for project-specific webhooks (omit for organization-wide)
- `secret` - optional secret for payload verification

### List Existing Webhooks

**Tool:** `list_webhooks`
- `projectKey` - optional, to see project-specific webhooks

## When to Update vs. When to Discuss

**Update directly when:**
- A specific issue is clearly a false positive for your codebase
- A security hotspot has been reviewed and the code is verified safe
- You need to add a webhook for your project's CI pipeline

**Discuss with your team first when:**
- You want to accept multiple issues of the same rule (may indicate the rule needs adjustment at the org level)
- A quality gate condition seems too strict or too lenient for your project
- You're considering marking security hotspots as acknowledged without fixing them
- Changes would affect organization-wide settings rather than project-level ones

## Workflow for Project-Level Rule Adjustments

If your project has constraints that make certain rules impractical:

1. Use `search_sonar_issues_in_projects` to identify the pattern of issues
2. Use `show_rule` to understand each rule's intent
3. Determine if the issue is:
   - A false positive → mark as `falsepositive`
   - A real issue you accept → mark as `accept`
   - A rule that shouldn't apply to your project → discuss with your SonarQube admin about creating a project-specific quality profile
4. Document your reasoning for any status changes
5. Review `get_project_quality_gate_status` to confirm the impact on your quality gate
