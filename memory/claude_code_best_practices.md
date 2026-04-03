---
name: claude_code_best_practices
description: Core best practices from claude-code-best-practice repository - orchestration patterns, workflow strategies, and Boris Cherny's setup recommendations
type: reference
---

# Claude Code Best Practices

Source: https://github.com/shanraisshan/claude-code-best-practice (31k+ stars)

## Orchestration Pattern

**Command → Agent → Skill** architecture for complex workflows:

- **Command** (`.claude/commands/`) - User-invoked prompt templates that initiate workflows
- **Agent** (`.claude/agents/`) - Autonomous actors in isolated contexts with custom tools/permissions
- **Skill** (`.claude/skills/`) - Auto-discoverable knowledge with progressive disclosure

**Why:** Separates orchestration (command), execution (agent), and domain knowledge (skill) for maintainable workflows.

**How to apply:** For multi-step tasks, create a command that spawns agents which load relevant skills on-demand.

## Core Workflow Pattern

All major workflows follow: **Research → Plan → Execute → Review → Ship**

**Why:** Structured approach prevents premature implementation and ensures quality.

**How to apply:** Always start with plan mode (`Shift+Tab` twice), iterate on the plan, then execute with auto-accept edits.

## Frontmatter Fields Reference

### Skills (13 fields)

- `name` - Display name and `/slash-command` identifier
- `description` - What the skill does (used for auto-discovery)
- `disable-model-invocation` - Prevent auto-invocation
- `user-invocable` - Hide from `/` menu (background knowledge only)
- `context: fork` - Run in isolated subagent context
- `paths` - Glob patterns for auto-activation
- `model`, `effort` - Override model/effort level
- `allowed-tools` - Tools allowed without prompts
- `shell` - `bash` or `powershell` for code blocks

### Agents (16 fields)

- `name`, `description` - Identifier and when to invoke
- `tools` - Allowlist (e.g., `Read, Write, Edit, Bash`)
- `disallowedTools` - Denylist
- `model` - `haiku`, `sonnet`, `opus`, or `inherit`
- `permissionMode` - `default`, `acceptEdits`, `dontAsk`, `bypassPermissions`, `plan`
- `maxTurns` - Maximum agentic turns
- `skills` - Preload skills at startup
- `mcpServers` - MCP servers for this agent
- `hooks` - Lifecycle hooks (PreToolUse, PostToolUse, Stop)
- `memory` - `user`, `project`, or `local`
- `background` - Run as background task
- `isolation: worktree` - Run in temporary git worktree

### Commands (13 fields)

Same as Skills, plus:

- `argument-hint` - Hint for autocomplete (e.g., `[issue-number]`)

## Boris Cherny's Setup (Creator of Claude Code)

### 1. Parallelism

- Run 5 Claudes in parallel in terminal tabs (numbered 1-5)
- Run 5-10 more on claude.ai/code
- Use system notifications to know when input is needed

### 2. Model Choice

- Use Opus 4.5 with thinking for everything
- Bigger/slower but better at tool use = faster overall
- Less steering needed

### 3. CLAUDE.md Strategy

- Share single CLAUDE.md with team, checked into git
- Team contributes multiple times per week
- Add corrections immediately when Claude does something wrong
- Keep under 200 lines per file
- Tag @claude on PRs to update CLAUDE.md

### 4. Plan Mode First

- Start most sessions in Plan mode (Shift+Tab twice)
- Iterate on plan until satisfied
- Switch to auto-accept edits mode for execution
- Good plan = usually 1-shot implementation

### 5. Slash Commands for Inner Loop

- Create commands for workflows done many times daily
- Example: `/commit-push-pr`
- Saves repeated prompting
- Claude can use these workflows too

### 6. Subagents for Automation

- `code-simplifier` - Simplifies code after work is done
- `verify-app` - Detailed testing instructions
- Think of subagents as automating common workflows

### 7. PostToolUse Hook for Formatting

```json
"PostToolUse": [{
  "matcher": "Write|Edit",
  "hooks": [{"type": "command", "command": "bun run format || true"}]
}]
```

### 8. Pre-allow Permissions

- Don't use `--dangerously-skip-permissions`
- Use `/permissions` to pre-allow safe commands
- Check into `.claude/settings.json` and share with team

### 9. MCP for All Tools

- Let Claude use Slack, BigQuery, Sentry, etc. via MCP
- Check `.mcp.json` into git and share with team

### 10. Verification Loop

**Most important:** Give Claude a way to verify its work

- Use background agents for long-running tasks
- Use agent Stop hooks for deterministic verification
- Feedback loop = 2-3x quality improvement
- Test every single change

## Prompting Best Practices

### Challenge Claude (don't babysit)

- "Grill me on these changes and don't make a PR until I pass your test"
- "Prove to me this works" - have Claude diff between main and your branch
- "Knowing everything you know now, scrap this and implement the elegant solution"

### Let Claude Fix Bugs

- Paste the bug, say "fix", don't micromanage how
- Claude fixes most bugs by itself

### Planning

- Always start with plan mode
- Ask Claude to interview you using AskUserQuestion tool
- Make phase-wise gated plan with multiple tests per phase
- Spin up second Claude to review plan as staff engineer
- Write detailed specs, reduce ambiguity
- Prototype > PRD - build 20-30 versions instead of writing specs

## Official Built-in Resources

### Skills (5)

1. `simplify` - Review code for reuse, quality, efficiency
2. `batch` - Run commands across multiple files
3. `debug` - Debug failing commands
4. `loop` - Recurring prompts (up to 3 days)
5. `claude-api` - Build with Claude API/SDK

### Agents (5)

1. `general-purpose` - Complex multi-step tasks (default)
2. `Explore` - Fast codebase search (haiku, read-only)
3. `Plan` - Pre-planning research in plan mode
4. `statusline-setup` - Configure status line
5. `claude-code-guide` - Answer Claude Code questions

### Commands (64 total)

Key ones:

- `/plan [description]` - Enter plan mode
- `/config` - Settings interface
- `/permissions` - Manage tool permissions
- `/memory` - Edit CLAUDE.md files
- `/model [model]` - Change AI model
- `/effort [level]` - Set effort level
- `/diff` - Interactive diff viewer
- `/export` - Export conversation
- `/branch` - Branch conversation

## Hot Features (2026)

- **Power-ups** (`/powerup`) - Interactive lessons with animated demos
- **No Flicker Mode** (`CLAUDE_CODE_NO_FLICKER=1`) - Flicker-free rendering
- **Computer Use** - Control screen on macOS (beta)
- **Auto Mode** (`--enable-auto-mode`) - AI safety classifier replaces manual prompts
- **Channels** - Push events from Telegram/Discord/webhooks
- **Code Review** - Multi-agent PR analysis (GitHub App)
- **Scheduled Tasks** - `/loop` (local, 3 days) and `/schedule` (cloud, persistent)
- **Voice Dictation** (`/voice`) - Push-to-talk speech input
- **Agent Teams** - Multiple agents in parallel on same codebase
- **Git Worktrees** - Isolated branches for parallel development

## Development Workflow Comparison

Top workflows all converge on Research → Plan → Execute → Review → Ship:

1. **Everything Claude Code** (133k⭐) - instinct scoring, AgentShield, multi-lang rules
2. **Superpowers** (132k⭐) - TDD-first, Iron Laws, whole-plan review
3. **Spec Kit** (85k⭐) - spec-driven, constitution, 22+ tools
4. **gstack** (62k⭐) - role personas, /codex review, parallel sprints
5. **Get Shit Done** (47k⭐) - fresh 200K contexts, wave execution, XML plans

**Why:** Different approaches to same goal - find what fits your workflow.

**How to apply:** Study these repos for specific patterns (TDD, spec-driven, parallel execution, etc.)
