# DeerFlow Skills - Ported to Claude Code

**Collection of professional skills ported from DeerFlow to Claude Code**

This directory contains skills adapted from the [DeerFlow](https://github.com/bytedance/deer-flow) open-source project (MIT License) for use with Claude Code.

## Available Skills

### 1. Deep Research (`deep-research.md`)

**Systematic multi-angle web research methodology**

Use instead of single WebSearch calls for comprehensive research. Provides structured 4-phase research workflow:

- Phase 1: Broad Exploration
- Phase 2: Deep Dive
- Phase 3: Diversity & Validation
- Phase 4: Synthesis Check

**When to use:**

- Research questions ("what is X", "explain X", "compare X and Y")
- Before content generation tasks
- When comprehensive understanding is needed

### 2. Data Analysis (`data-analysis.md`)

**Analyze Excel/CSV files using SQL queries**

Supports schema inspection, SQL-based querying, statistical summaries, and result export using DuckDB.

**When to use:**

- User uploads Excel/CSV files
- Needs statistics, summaries, pivot tables
- Wants filtering, aggregation, or structured data exploration

**Prerequisites:**

```bash
pip install duckdb openpyxl pandas
```

### 3. GitHub Research (`github-research.md`)

**Multi-round deep research on GitHub repositories**

Combines GitHub CLI, web search, and web fetch to produce comprehensive markdown reports with timelines, metrics, and competitive analysis.

**When to use:**

- User provides GitHub repository URL
- Needs comprehensive repository analysis
- Wants timeline reconstruction or competitive analysis

**Prerequisites:**

```bash
# Install GitHub CLI
# Windows: winget install GitHub.cli
# Mac: brew install gh
# Linux: See https://github.com/cli/cli#installation

gh auth login
```

### 4. Consulting Analysis (`consulting-analysis.md`)

**Generate professional consulting-grade research reports**

Produces McKinsey/BCG-style reports for market analysis, consumer insights, brand strategy, financial analysis, and competitive intelligence.

**When to use:**

- User requests professional research report
- Needs structured analysis framework
- Wants consulting-grade strategic insights

## How to Use These Skills

### Method 1: Direct Invocation (Recommended)

Skills in this directory are not automatically loaded by Claude Code. To use them:

1. **Reference the skill explicitly:**

   ```
   User: "Use the deerflow:deep-research skill to research AI in healthcare"
   ```

2. **Claude will read and follow the skill:**
   - Reads the skill file from `~/.claude/skills/deerflow-ported/`
   - Follows the methodology described
   - Applies the workflow to your task

### Method 2: Manual Integration

Copy skill content into your prompts or CLAUDE.md files for specific projects.

### Method 3: Skill Tool (if supported)

If your Claude Code version supports the Skill tool for custom skills:

```
/skill deerflow:deep-research
```

## Differences from DeerFlow

These skills have been adapted for Claude Code:

| DeerFlow                       | Claude Code                         |
| ------------------------------ | ----------------------------------- |
| `bash` tool                    | `Bash` tool                         |
| `web_search` tool              | `WebSearch` tool                    |
| `web_fetch` tool               | `WebFetch` tool                     |
| `write_file` tool              | `Write` tool                        |
| `read_file` tool               | `Read` tool                         |
| Virtual paths (`/mnt/skills/`) | Actual file paths                   |
| Pre-built Python scripts       | Create scripts on-the-fly or inline |
| Sandbox isolation              | Direct file system access           |

## Skill Combinations

These skills work well together:

**Research Report Workflow:**

1. `deep-research` → Gather comprehensive information
2. `consulting-analysis` → Structure findings into professional report
3. `github-research` → Add technical analysis if relevant

**Data Analysis Workflow:**

1. User uploads data files
2. `data-analysis` → Inspect and query data
3. `consulting-analysis` → Transform insights into strategic report

## Contributing

These skills are ported from DeerFlow's public skills (MIT License). To add more:

1. Review DeerFlow skills at: `/tmp/deer-flow/skills/public/`
2. Adapt tool names and paths for Claude Code
3. Test the workflow
4. Add to this collection

## Credits

- **Original Source:** [DeerFlow](https://github.com/bytedance/deer-flow) by ByteDance
- **License:** MIT License
- **Ported by:** Claude Code skill conversion
- **Date:** 2026-04-03

## License

These ported skills maintain the MIT License from the original DeerFlow project.

---

**Note:** These skills are community adaptations and are not officially supported by Anthropic or ByteDance. Use at your own discretion.
