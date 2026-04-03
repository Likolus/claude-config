---
name: deerflow_skills_auto_trigger
description: Automatic triggering rules for DeerFlow skills based on context
type: feedback
---

**Rule:** Automatically apply DeerFlow skills when context matches their domain, without requiring explicit user request.

## Automatic Skill Triggers

### 1. deerflow:deep-research

**Auto-trigger when:**

- User asks "what is X", "explain X", "research X", "investigate X"
- User asks to compare technologies, products, or concepts
- User requests information that requires current web data
- Before generating content (presentations, articles, reports) that needs real-world information
- User asks about trends, market analysis, or industry insights
- Question requires comprehensive understanding from multiple sources

**Why:** Single WebSearch is insufficient for quality answers. Deep research ensures comprehensive, multi-angle information gathering.

**Example triggers:**

- "What is the current state of quantum computing?"
- "Compare React vs Vue in 2026"
- "Explain how LangGraph works"
- "Research the AI agent market"

### 2. deerflow:data-analysis

**Auto-trigger when:**

- User uploads or mentions Excel (.xlsx, .xls) or CSV files
- User asks for statistics, summaries, or data insights
- User wants to filter, aggregate, or query structured data
- User requests pivot tables or cross-tabulation
- User asks "analyze this data", "what does this data show"
- User wants to export or transform data

**Why:** Provides SQL-powered analysis with DuckDB for efficient data exploration.

**Example triggers:**

- "Analyze sales_2024.xlsx"
- "Show me top 10 customers by revenue"
- "What's the average order value by region?"
- User uploads data file and asks questions about it

### 3. deerflow:github-research

**Auto-trigger when:**

- User provides a GitHub repository URL (github.com/owner/repo)
- User asks to analyze, evaluate, or research a GitHub project
- User asks "what is [repo-name]" where repo-name is a known GitHub project
- User requests competitive analysis of open-source projects
- User asks about project history, timeline, or evolution
- User wants to understand project architecture or adoption

**Why:** Combines GitHub CLI + web research for comprehensive repository analysis with metrics, timeline, and competitive landscape.

**Example triggers:**

- "Analyze https://github.com/bytedance/deer-flow"
- "What is LangChain and how does it work?"
- "Compare FastAPI vs Flask"
- "Should I use this library for my project?"

### 4. deerflow:consulting-analysis

**Auto-trigger when:**

- User requests a "market analysis", "industry report", or "research report"
- User asks for "consumer insights", "brand analysis", or "competitive intelligence"
- User needs a professional/consulting-grade report
- User asks to "analyze the market for X"
- User requests strategic recommendations or business insights
- After completing deep-research, if user wants structured report

**Why:** Produces McKinsey/BCG-level professional reports with structured analysis, insights, and recommendations.

**Example triggers:**

- "Analyze the electric vehicle market"
- "I need a market analysis report on AI agents"
- "What are the trends in the skincare industry?"
- "Competitive analysis of cloud providers"

## Skill Combinations

**Auto-combine skills when appropriate:**

1. **Research → Report:**
   - User asks for market analysis
   - Apply: `deep-research` (gather data) → `consulting-analysis` (structure report)

2. **GitHub → Research:**
   - User asks about open-source project
   - Apply: `github-research` (repo analysis) → `deep-research` (ecosystem context)

3. **Data → Report:**
   - User uploads data and asks for insights
   - Apply: `data-analysis` (query data) → `consulting-analysis` (strategic insights)

## Execution Protocol

**When auto-triggering a skill:**

1. **Announce briefly:** "Using [skill-name] to [purpose]"
2. **Follow skill methodology:** Read skill file and apply its workflow
3. **Don't ask permission:** Just apply it (user requested auto-trigger)
4. **Combine when needed:** Chain skills for complex tasks
5. **Explain if asked:** Be ready to explain why you chose that skill

**Example:**

```
User: "What's the state of AI agents in 2026?"
Assistant: "Using deerflow:deep-research to investigate AI agents comprehensively..."
[Applies 4-phase research methodology]
[Delivers comprehensive answer with multiple sources]
```

## How to apply:

When I detect a trigger pattern, I will:

1. Silently read the appropriate skill file from `~/.claude/skills/deerflow-ported/`
2. Announce which skill I'm using and why
3. Follow the skill's methodology exactly
4. Deliver results according to skill's output format
