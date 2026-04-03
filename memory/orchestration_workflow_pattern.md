---
name: orchestration_workflow_pattern
description: Command → Agent → Skill orchestration pattern for complex multi-step workflows with examples and implementation guidance
type: feedback
---

# Orchestration Workflow Pattern

**Pattern:** Command → Agent → Skill

Source: claude-code-best-practice repository orchestration workflow

## The Pattern

```
User invokes Command
    ↓
Command spawns Agent(s)
    ↓
Agent loads Skill(s) on-demand
    ↓
Skill provides specialized knowledge
    ↓
Agent executes with skill context
    ↓
Results returned to user
```

## Why This Works

**Separation of concerns:**

- **Commands** handle orchestration and user interaction
- **Agents** handle execution in isolated contexts
- **Skills** provide domain knowledge without cluttering main context

**Progressive disclosure:**

- Only skill descriptions in context initially
- Full skill content loaded on-demand
- Prevents context bloat

**Reusability:**

- Same skill can be used by multiple agents
- Same agent can be invoked by multiple commands
- Commands compose agents and skills flexibly

## When to Use

Use this pattern when:

- Task requires multiple specialized knowledge domains
- Need isolation between workflow steps
- Want to keep main context clean
- Building reusable workflow components

Don't use when:

- Simple single-step task
- No need for isolation
- Skill content is small enough to stay in main context

## Implementation Example

**Command** (`.claude/commands/weather-orchestrator.md`):

```markdown
---
name: weather-orchestrator
description: Orchestrate weather data collection and analysis
---

Spawn the weather-collector agent to gather data, then spawn the weather-analyzer agent to process it.
```

**Agent** (`.claude/agents/weather-collector.md`):

```markdown
---
name: weather-collector
description: Collect weather data from APIs
tools: Read, Bash
skills: [api-integration]
---

Use the api-integration skill to fetch weather data.
```

**Skill** (`.claude/skills/api-integration/SKILL.md`):

```markdown
---
name: api-integration
description: Best practices for API integration and error handling
---

When calling APIs:

1. Check for API keys in environment
2. Handle rate limits with exponential backoff
3. Parse and validate responses
   ...
```

## How to Apply

1. **Identify workflow steps** - Break complex task into phases
2. **Create command** - Define orchestration logic
3. **Create agents** - One per isolated execution context needed
4. **Create skills** - Extract domain knowledge into reusable skills
5. **Wire together** - Command invokes agents, agents load skills

## Real-World Usage

From boris-cherny tips:

- Use commands for "inner loop" workflows done many times daily
- Use agents to automate common workflows
- Skills provide specialized knowledge that multiple agents can use

Example workflows:

- `/commit-push-pr` - Command that orchestrates git operations
- `code-simplifier` - Agent that reviews and refactors code
- `verify-app` - Agent with detailed testing instructions

## Key Insight

**The orchestration pattern scales:**

- Start simple: single command, single agent, single skill
- Grow complex: commands compose multiple agents, agents load multiple skills
- Maintain clarity: each component has single responsibility

**Why:** As codebase grows, this pattern prevents workflow spaghetti and keeps components reusable and testable.

**How to apply:** Start with this pattern for any workflow you'll use more than once. The upfront structure cost pays off in maintainability.
