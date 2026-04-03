---
name: deerflow:deep-research
description: Systematic multi-angle web research methodology. Use instead of single WebSearch calls for ANY question requiring comprehensive research. Trigger on "what is X", "explain X", "compare X and Y", "research X", or before content generation tasks. Provides structured research phases instead of superficial searches.
---

# Deep Research Skill (from DeerFlow)

**Ported from DeerFlow to Claude Code**

This skill provides a systematic methodology for conducting thorough web research. **Use this BEFORE starting any content generation task** to ensure you gather sufficient information from multiple angles, depths, and sources.

## When to Use This Skill

**Always use this skill when:**

### Research Questions

- User asks "what is X", "explain X", "research X", "investigate X"
- User wants to understand a concept, technology, or topic in depth
- The question requires current, comprehensive information from multiple sources
- A single web search would be insufficient to answer properly

### Content Generation (Pre-research)

- Creating presentations or documentation
- Writing articles, reports, or analysis
- Building features that require domain knowledge
- Any content that requires real-world information, examples, or current data

## Core Principle

**Never generate content based solely on general knowledge.** The quality of your output directly depends on the quality and quantity of research conducted beforehand. A single search query is NEVER enough.

## Research Methodology

### Phase 1: Broad Exploration

Start with broad searches to understand the landscape:

1. **Initial Survey**: Search for the main topic to understand the overall context
2. **Identify Dimensions**: From initial results, identify key subtopics, themes, angles, or aspects that need deeper exploration
3. **Map the Territory**: Note different perspectives, stakeholders, or viewpoints that exist

Example:

```
Topic: "AI in healthcare"
Initial searches:
- "AI healthcare applications 2026"
- "artificial intelligence medical diagnosis"
- "healthcare AI market trends"

Identified dimensions:
- Diagnostic AI (radiology, pathology)
- Treatment recommendation systems
- Administrative automation
- Patient monitoring
- Regulatory landscape
- Ethical considerations
```

### Phase 2: Deep Dive

For each important dimension identified, conduct targeted research:

1. **Specific Queries**: Search with precise keywords for each subtopic
2. **Multiple Phrasings**: Try different keyword combinations and phrasings
3. **Fetch Full Content**: Use `WebFetch` to read important sources in full, not just snippets
4. **Follow References**: When sources mention other important resources, search for those too

Example:

```
Dimension: "Diagnostic AI in radiology"
Targeted searches:
- "AI radiology FDA approved systems"
- "chest X-ray AI detection accuracy"
- "radiology AI clinical trials results"

Then fetch and read:
- Key research papers or summaries
- Industry reports
- Real-world case studies
```

### Phase 3: Diversity & Validation

Ensure comprehensive coverage by seeking diverse information types:

| Information Type            | Purpose                  | Example Searches                               |
| --------------------------- | ------------------------ | ---------------------------------------------- |
| **Facts & Data**            | Concrete evidence        | "statistics", "data", "numbers", "market size" |
| **Examples & Cases**        | Real-world applications  | "case study", "example", "implementation"      |
| **Expert Opinions**         | Authority perspectives   | "expert analysis", "interview", "commentary"   |
| **Trends & Predictions**    | Future direction         | "trends 2026", "forecast", "future of"         |
| **Comparisons**             | Context and alternatives | "vs", "comparison", "alternatives"             |
| **Challenges & Criticisms** | Balanced view            | "challenges", "limitations", "criticism"       |

### Phase 4: Synthesis Check

Before proceeding to content generation, verify:

- [ ] Have I searched from at least 3-5 different angles?
- [ ] Have I fetched and read the most important sources in full?
- [ ] Do I have concrete data, examples, and expert perspectives?
- [ ] Have I explored both positive aspects and challenges/limitations?
- [ ] Is my information current and from authoritative sources?

**If any answer is NO, continue researching before generating content.**

## Search Strategy Tips

### Effective Query Patterns

```
# Be specific with context
❌ "AI trends"
✅ "enterprise AI adoption trends 2026"

# Include authoritative source hints
"[topic] research paper"
"[topic] McKinsey report"
"[topic] industry analysis"

# Search for specific content types
"[topic] case study"
"[topic] statistics"
"[topic] expert interview"

# Use temporal qualifiers with CURRENT year
"[topic] 2026"   # ← always use current year from context
"[topic] latest"
"[topic] recent developments"
```

### Temporal Awareness

**Always check current date in your context before forming ANY search query.**

Use the right level of precision depending on what the user is asking:

| User intent                            | Temporal precision needed | Example query                                 |
| -------------------------------------- | ------------------------- | --------------------------------------------- |
| "today / this morning / just released" | **Month + Day**           | `"tech news April 3 2026"`                    |
| "this week"                            | **Week range**            | `"technology releases week of March 31 2026"` |
| "recently / latest / new"              | **Month**                 | `"AI breakthroughs April 2026"`               |
| "this year / trends"                   | **Year**                  | `"software trends 2026"`                      |

**Rules:**

- When the user asks about "today" or "just released", use **month + day + year** in your search queries
- Never drop to year-only when day-level precision is needed
- Try multiple phrasings: numeric form (`2026-04-03`), written form (`April 3 2026`), and relative terms (`today`, `this week`)

### When to Use WebFetch

Use `WebFetch` to read full content when:

- A search result looks highly relevant and authoritative
- You need detailed information beyond the snippet
- The source contains data, case studies, or expert analysis
- You want to understand the full context of a finding

### Iterative Refinement

Research is iterative. After initial searches:

1. Review what you've learned
2. Identify gaps in your understanding
3. Formulate new, more targeted queries
4. Repeat until you have comprehensive coverage

## Quality Bar

Your research is sufficient when you can confidently answer:

- What are the key facts and data points?
- What are 2-3 concrete real-world examples?
- What do experts say about this topic?
- What are the current trends and future directions?
- What are the challenges or limitations?
- What makes this topic relevant or important now?

## Common Mistakes to Avoid

- ❌ Stopping after 1-2 searches
- ❌ Relying on search snippets without reading full sources
- ❌ Searching only one aspect of a multi-faceted topic
- ❌ Ignoring contradicting viewpoints or challenges
- ❌ Using outdated information when current data exists
- ❌ Starting content generation before research is complete

## Claude Code Adaptation Notes

**Tool Mapping:**

- DeerFlow `web_search` → Claude Code `WebSearch`
- DeerFlow `web_fetch` → Claude Code `WebFetch`

**Workflow:**

1. Use `WebSearch` for broad exploration and targeted queries
2. Use `WebFetch` to read full content from important sources
3. Track findings in conversation context
4. Synthesize before generating content

## Output

After completing research, you should have:

1. A comprehensive understanding of the topic from multiple angles
2. Specific facts, data points, and statistics
3. Real-world examples and case studies
4. Expert perspectives and authoritative sources
5. Current trends and relevant context

**Only then proceed to content generation**, using the gathered information to create high-quality, well-informed content.

---

**Source:** DeerFlow public skills (MIT License)
**Ported by:** Claude Code skill conversion
**Date:** 2026-04-03
