---
name: deerflow:github-research
description: Conduct multi-round deep research on GitHub repositories. Use when users request comprehensive analysis, timeline reconstruction, competitive analysis, or in-depth investigation of GitHub repos. Produces structured markdown reports with executive summaries, chronological timelines, metrics analysis, and diagrams.
---

# GitHub Deep Research Skill (from DeerFlow)

**Ported from DeerFlow to Claude Code**

Multi-round research combining GitHub CLI, web search, and web fetch to produce comprehensive markdown reports about GitHub repositories.

## When to Use This Skill

Use this skill when the user:

- Provides a GitHub repository URL for analysis
- Asks for comprehensive repository analysis
- Wants to understand a project's history, architecture, or ecosystem
- Needs competitive analysis of similar projects
- Requests timeline reconstruction of project development
- Wants to evaluate an open-source project for adoption

## Research Workflow

### Round 1: GitHub API Data Collection

Use GitHub CLI to gather structured data:

```bash
# Repository overview
gh repo view owner/repo --json name,description,createdAt,pushedAt,stargazerCount,forkCount,primaryLanguage,licenseInfo,isArchived,homepageUrl

# README content
gh repo view owner/repo --json readme

# Recent releases
gh release list --repo owner/repo --limit 10

# Top contributors
gh api repos/owner/repo/contributors --paginate | jq -r '.[] | "\(.login): \(.contributions) commits"' | head -20

# Recent issues and PRs
gh issue list --repo owner/repo --limit 20 --state all
gh pr list --repo owner/repo --limit 20 --state all

# Repository topics/tags
gh repo view owner/repo --json repositoryTopics

# Languages breakdown
gh api repos/owner/repo/languages
```

**Key data to extract:**

- Basic metrics (stars, forks, age, activity)
- Technology stack and languages
- License and governance
- Community health (contributors, issues, PRs)
- Release cadence and versioning
- Documentation quality

### Round 2: Discovery Phase (3-5 searches)

Conduct broad web searches to understand context:

```
# Project overview and purpose
"[repo-name] overview"
"[repo-name] what is it"
"[repo-name] use cases"

# Ecosystem and adoption
"[repo-name] adoption"
"companies using [repo-name]"
"[repo-name] production usage"

# Community and resources
"[repo-name] tutorial"
"[repo-name] getting started"
"[repo-name] documentation"
```

**Focus on:**

- Official documentation and blog posts
- Community discussions (Reddit, HN, Dev.to)
- Adoption stories and case studies
- Tutorials and learning resources

### Round 3: Deep Investigation (5-10 searches + WebFetch)

Targeted searches for specific aspects:

```
# Architecture and design
"[repo-name] architecture"
"[repo-name] design decisions"
"[repo-name] technical overview"

# Comparisons and alternatives
"[repo-name] vs [alternative]"
"[repo-name] alternatives"
"[repo-name] comparison"

# Problems and limitations
"[repo-name] issues"
"[repo-name] problems"
"[repo-name] limitations"
"[repo-name] criticism"
```

**Use WebFetch on:**

- Official documentation pages
- Technical blog posts
- Architecture diagrams
- Comparison articles

### Round 4: Deep Dive

Final round for comprehensive understanding:

```
# Roadmap and future
"[repo-name] roadmap"
"[repo-name] future plans"
"site:github.com [repo-name] roadmap"

# Recent developments
"[repo-name] 2026"
"[repo-name] latest updates"
"[repo-name] recent changes"

# Expert opinions
"[repo-name] review"
"[repo-name] analysis"
"[repo-name] expert opinion"
```

## Report Structure

Generate a comprehensive markdown report with these sections:

### 1. Executive Summary

```markdown
# [Repository Name] - Deep Research Report

**Repository:** [owner/repo]
**Generated:** 2026-04-03
**Status:** [Active/Archived/Deprecated]

## Quick Facts

- **Stars:** [count] | **Forks:** [count]
- **Language:** [primary language]
- **License:** [license]
- **Created:** [date] | **Last Updated:** [date]
- **Contributors:** [count]

## TL;DR

[2-3 sentence summary of what this project is, why it matters, and current status]

## Key Findings

- [Finding 1]
- [Finding 2]
- [Finding 3]
```

### 2. Chronological Timeline

```markdown
## Timeline & History

\`\`\`mermaid
gantt
title Project Timeline
dateFormat YYYY-MM-DD
section Phase 1
Initial Development :2025-01-01, 2025-03-01
section Phase 2
Public Launch :2025-03-01, 2025-04-01
section Phase 3
Growth Phase :2025-04-01, 2026-04-03
\`\`\`

### Major Milestones

- **[Date]**: Initial release [citation:Source](url)
- **[Date]**: Major feature added [citation:Source](url)
- **[Date]**: Reached 10k stars [citation:GitHub](url)

### Evolution

[Narrative of how the project has evolved over time]
```

### 3. Technical Analysis

```markdown
## Technical Analysis

### Architecture

\`\`\`mermaid
flowchart TD
A[User] --> B[API Gateway]
B --> C[Backend Service]
C --> D[Database]
C --> E[Cache]
\`\`\`

### Technology Stack

- **Primary Language:** [language]
- **Key Dependencies:** [list major dependencies]
- **Supported Platforms:** [platforms]

### Code Quality

- **Test Coverage:** [if available]
- **CI/CD:** [description]
- **Code Style:** [linting, formatting]
```

### 4. Community & Adoption

```markdown
## Community & Adoption

### Growth Metrics

\`\`\`mermaid
pie title Star Distribution
"Last 6 months" : 30
"6-12 months ago" : 25
"12+ months ago" : 45
\`\`\`

### Notable Users

- [Company/Project 1] [citation:Source](url)
- [Company/Project 2] [citation:Source](url)

### Community Health

- **Active Contributors:** [count]
- **Response Time:** [average]
- **Documentation Quality:** [assessment]
```

### 5. Competitive Landscape

```markdown
## Competitive Landscape

| Feature     | [This Project] | [Alternative 1] | [Alternative 2] |
| ----------- | -------------- | --------------- | --------------- |
| [Feature 1] | ✅             | ✅              | ❌              |
| [Feature 2] | ✅             | ❌              | ✅              |
| Stars       | [count]        | [count]         | [count]         |

### Differentiation

[What makes this project unique?]
```

### 6. SWOT Analysis

```markdown
## Strengths & Weaknesses

### Strengths ✅

- [Strength 1] [citation:Source](url)
- [Strength 2]
- [Strength 3]

### Weaknesses ⚠️

- [Weakness 1] [citation:Source](url)
- [Weakness 2]

### Opportunities 🚀

- [Opportunity 1]
- [Opportunity 2]

### Threats ⚡

- [Threat 1]
- [Threat 2]
```

### 7. Sources & References

```markdown
## Sources & References

### Official Resources

- [Documentation](url)
- [GitHub Repository](url)
- [Website](url)

### Research Sources

1. [Source 1 Title](url)
2. [Source 2 Title](url)
3. [Source 3 Title](url)

### Community Resources

- [Discord/Slack](url)
- [Forum](url)
```

## Citation Requirements

**CRITICAL: Always include inline citations**

Use `[citation:Title](URL)` format immediately after each claim from external sources:

```markdown
✅ Good:
The project gained 10,000 stars within 3 months [citation:GitHub Stats](https://github.com/owner/repo).

❌ Bad:
The project gained 10,000 stars within 3 months.
```

## Confidence Scoring

Assign confidence levels to claims:

| Confidence      | Criteria                                                   |
| --------------- | ---------------------------------------------------------- |
| High (90%+)     | Official docs, GitHub data, multiple corroborating sources |
| Medium (70-89%) | Single reliable source, recent articles                    |
| Low (50-69%)    | Social media, unverified claims, outdated info             |

## Claude Code Adaptation Notes

**Tool Mapping:**

- DeerFlow `bash` → Claude Code `Bash` (for `gh` commands)
- DeerFlow `web_search` → Claude Code `WebSearch`
- DeerFlow `web_fetch` → Claude Code `WebFetch`
- DeerFlow `write_file` → Claude Code `Write`

**GitHub CLI Setup:**

```bash
# Install if needed
# Windows: winget install GitHub.cli
# Mac: brew install gh
# Linux: See https://github.com/cli/cli#installation

# Authenticate
gh auth login
```

**Workflow:**

1. Extract owner/repo from GitHub URL
2. Run GitHub CLI commands to gather structured data
3. Conduct multi-round web research (4 phases)
4. Use WebFetch to read important sources in full
5. Synthesize findings into structured markdown report
6. Include Mermaid diagrams for visualization
7. Save report with Write tool

## Quality Checklist

Before finalizing the report, ensure:

- [ ] All GitHub API data has been collected
- [ ] At least 10-15 web searches conducted across 4 rounds
- [ ] Key sources have been read in full with WebFetch
- [ ] Timeline includes major milestones with dates
- [ ] Competitive analysis includes at least 2 alternatives
- [ ] SWOT analysis is balanced and evidence-based
- [ ] All claims are backed by inline citations
- [ ] Mermaid diagrams are included where helpful
- [ ] Report is well-structured and readable

---

**Source:** DeerFlow public skills (MIT License)
**Ported by:** Claude Code skill conversion
**Date:** 2026-04-03
