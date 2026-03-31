---
name: "sonarqube-testing"
displayName: "SonarQube Testing Standards"
description: "Leverage SonarQube enterprise testing standards and quality gates to enforce consistent code quality at the project level. Inspect existing rules, analyze code against them, and update SonarQube configuration when project constraints require changes."
keywords: ["sonarqube", "sonarcloud", "quality-gate", "code-quality", "static-analysis"]
author: "Kiro Power Builder"
---

# SonarQube Testing Standards

## Overview

This power connects to your SonarQube Server or SonarQube Cloud instance via the official SonarSource MCP server. It gives you direct access to your organization's testing standards, quality gates, rules, and analysis results so you can enforce consistent code quality from within your IDE.

The core philosophy: your SonarQube instance is the single source of truth for code quality standards. This power lets you inspect what standards exist, analyze your code against them, and when project-level constraints demand it, update the SonarQube configuration directly.

Key capabilities:
- Inspect quality gates, rules, and metrics defined in your SonarQube instance
- Analyze code snippets and files against those standards before committing
- Review issues, security hotspots, coverage gaps, and duplications
- Update issue statuses, hotspot reviews, and webhook configurations when project needs change
- Monitor project health and quality gate status across branches and pull requests

## Available Steering Files

This power has workflow-specific guides for different use cases:

- **inspect-standards** - Discover and understand the quality gates, rules, and metrics your organization has defined in SonarQube. Start here to learn what standards apply to your project.
- **analyze-and-fix** - Analyze your code against SonarQube standards, find issues, and fix them before they hit CI. Covers code analysis, issue triage, coverage gaps, and security hotspots.
- **update-sonarqube** - Update SonarQube configuration when project constraints require changes. Manage issue statuses, hotspot reviews, and webhooks.

## Onboarding

### Prerequisites

- Docker installed and running (the MCP server runs as a container)
- A SonarQube Server (2025.1+), SonarQube Community Build, or SonarQube Cloud account
- A SonarQube user token (not a project or global token for Server)

### Getting Your Token

**SonarQube Cloud:**
1. Go to https://sonarcloud.io (or https://sonarqube.us for US region)
2. Navigate to My Account > Security
3. Generate a new token

**SonarQube Server:**
1. Log into your SonarQube Server instance
2. Navigate to My Account > Security
3. Generate a User token (must be User type, not Project or Global)

### Configuration

After installing this power, replace the placeholders in `mcp.json` with your actual values.

**For SonarQube Cloud:**
- `SONARQUBE_TOKEN` - your user token
- `SONARQUBE_ORG` - your organization key
- `SONARQUBE_URL` - leave blank or set to `https://sonarcloud.io` (use `https://sonarqube.us` for US region)
- `SONARQUBE_PROJECT_KEY` - your project key (optional, but recommended for single-project work)
- `SONARQUBE_WORKSPACE_PATH` - absolute path to your project root on disk

**For SonarQube Server:**
- `SONARQUBE_TOKEN` - your User token
- `SONARQUBE_URL` - your server URL (e.g. `https://sonarqube.mycompany.com`)
- `SONARQUBE_ORG` - remove this env var and its `-e` arg from mcp.json
- `SONARQUBE_PROJECT_KEY` - your project key (optional)
- `SONARQUBE_WORKSPACE_PATH` - absolute path to your project root on disk

### Optional: Workspace Mount (Recommended)

For efficient file analysis without passing file content through the agent context, add a volume mount to the `args` array in `mcp.json`. Insert these two entries before `"mcp/sonarqube"`:

```json
"-v", "/absolute/path/to/your/project:/app/mcp-workspace"
```

Replace `/absolute/path/to/your/project` with your actual project root path. On Windows, use a path like `C:/Users/you/projects/my-app`.

## MCP Config Placeholders

Before using this power, replace the following placeholders in `mcp.json`:

- **`YOUR_SONARQUBE_TOKEN`**: Your SonarQube authentication token.
  - **How to get it:** Go to your SonarQube instance > My Account > Security > Generate Token. For SonarQube Server, ensure it is a "User" type token.

- **`YOUR_SONARQUBE_URL`**: Your SonarQube instance URL.
  - **How to set it:** For SonarQube Cloud use `https://sonarcloud.io` (or `https://sonarqube.us` for US). For SonarQube Server use your server URL like `https://sonarqube.mycompany.com`.

- **`YOUR_SONARQUBE_ORG`**: Your SonarQube Cloud organization key.
  - **How to get it:** Found in your SonarQube Cloud organization settings. If using SonarQube Server, remove the `SONARQUBE_ORG` env var and its corresponding `-e` arg from the args array.

- **`YOUR_PROJECT_KEY`**: The SonarQube project key for your current project.
  - **How to get it:** Go to your project in SonarQube > Project Information. Setting this makes all tools default to this project without needing to specify it each time.

## Quick Start Workflow

1. **Inspect your standards first** - Read the `inspect-standards` steering file to discover what quality gates, rules, and metrics your organization enforces.
2. **Analyze your code** - Read the `analyze-and-fix` steering file to run analysis, find issues, and fix them.
3. **Update SonarQube when needed** - Read the `update-sonarqube` steering file when project constraints require changing issue statuses or configurations.

## Toolset Reference

The SonarQube MCP server organizes tools into toolsets. The key ones for testing standards:

| Toolset | Purpose |
|---------|---------|
| `analysis` | Analyze code snippets and files for quality/security issues |
| `issues` | Search and manage SonarQube issues |
| `quality-gates` | Check quality gate status and definitions |
| `rules` | Browse and inspect SonarQube rules |
| `coverage` | Find files with low test coverage |
| `security-hotspots` | Review security-sensitive code |
| `duplications` | Find duplicated code |
| `measures` | Get project metrics (complexity, coverage, violations) |
| `projects` | Browse projects and pull requests |
| `webhooks` | Manage webhook integrations |

You can limit which toolsets are active by setting `SONARQUBE_TOOLSETS` in the env section of mcp.json (comma-separated list). By default, the most important toolsets are enabled.

## Troubleshooting

### MCP Server Won't Start
- Ensure Docker is running: `docker ps`
- Pull the latest image: `docker pull mcp/sonarqube:latest`
- Check your token is valid and not expired

### "Unauthorized" or "Forbidden" Errors
- For SonarQube Server: ensure you're using a User token, not a Project or Global token
- Verify the token has appropriate permissions for the project
- Check that `SONARQUBE_URL` is correct and reachable

### Tools Missing or Not Working
- You may have an outdated Docker image. Run `docker pull mcp/sonarqube:latest`
- Check if the toolset is enabled via `SONARQUBE_TOOLSETS`
- Some tools require specific SonarQube editions (e.g., dependency risks require Enterprise)

### Workspace Mount Issues
- Ensure `SONARQUBE_WORKSPACE_PATH` is an absolute path
- On Windows, use forward slashes or escaped backslashes in the path
- The path must point to your project root directory

---

**MCP Server:** `mcp/sonarqube` (official SonarSource Docker image)
**Documentation:** https://docs.sonarsource.com/sonarqube-mcp-server/
**Source:** https://github.com/SonarSource/sonarqube-mcp-server
