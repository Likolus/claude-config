---
name: boris_cherny_workflow
description: Boris Cherny's (Claude Code creator) personal setup and workflow - parallelism, verification loops, and team collaboration patterns
type: user
---

# Boris Cherny Workflow

Boris Cherny is the creator of Claude Code. His setup is "surprisingly vanilla" - Claude Code works great out of the box.

**Why:** These practices come from the person who designed Claude Code and uses it daily for production work at Anthropic.

**How to apply:** Adopt patterns that fit your workflow, especially verification loops and team collaboration.

## Parallelism Strategy

**Run 10-15 Claudes in parallel:**

- 5 in terminal tabs (numbered 1-5)
- 5-10 on claude.ai/code
- Use system notifications for input needed
- Hand off sessions between local and web

**Why:** Maximize throughput on independent tasks. While one Claude is thinking, work with others.

**How to apply:** Start with 2-3 parallel sessions. Add more as you get comfortable context-switching.

## Model Selection

**Use Opus 4.5 with thinking for everything**

**Why:** Even though bigger/slower, better tool use and less steering needed = faster overall results.

**How to apply:** Don't optimize for speed per response. Optimize for time to correct solution.

## Team Collaboration

**Shared CLAUDE.md in git:**

- Whole team contributes multiple times per week
- Add corrections immediately when Claude does something wrong
- Keep under 200 lines per file
- Tag @claude on PRs to update CLAUDE.md during code review

**Why:** Team learns collectively. Mistakes documented once, never repeated.

**How to apply:** Treat CLAUDE.md as living documentation. Update it like you'd update tests after finding a bug.

## Plan Mode First

**Always start with plan mode (Shift+Tab twice):**

1. Enter plan mode
2. Iterate on plan with Claude until satisfied
3. Switch to auto-accept edits mode
4. Claude usually 1-shots the implementation

**Why:** Good plan = correct implementation on first try. Bad plan = multiple iterations.

**How to apply:** Resist urge to jump straight to coding. 5 minutes planning saves 30 minutes debugging.

## Inner Loop Automation

**Create slash commands for daily workflows:**

- Example: `/commit-push-pr`
- Lives in `.claude/commands/`
- Checked into git, shared with team
- Claude can use these workflows too

**Why:** Repeated prompting is waste. Codify it once, use forever.

**How to apply:** After prompting same thing 3 times, make it a command.

## Subagents for Common Workflows

**Regular subagents:**

- `code-simplifier` - Simplifies code after work is done
- `verify-app` - Detailed testing instructions
- Lives in `.claude/agents/`

**Why:** Automate quality checks and verification steps.

**How to apply:** Think of subagents as automated workflows, similar to slash commands but with isolated context.

## Formatting Hook

**PostToolUse hook for auto-formatting:**

```json
"PostToolUse": [{
  "matcher": "Write|Edit",
  "hooks": [{"type": "command", "command": "bun run format || true"}]
}]
```

**Why:** Claude generates well-formatted code, hook handles last 10% to avoid CI failures.

**How to apply:** Add formatter hook early. Prevents formatting noise in diffs.

## Permission Management

**Pre-allow safe commands instead of --dangerously-skip-permissions:**

- Use `/permissions` to pre-allow common safe commands
- Check into `.claude/settings.json`
- Share with team

**Why:** Avoid unnecessary prompts without sacrificing safety.

**How to apply:** After approving same command 5 times, pre-allow it.

## MCP Integration

**Let Claude use all your tools:**

- Slack (via MCP server)
- BigQuery (via `bq` CLI)
- Sentry (for error logs)
- `.mcp.json` checked into git, shared with team

**Why:** Claude becomes extension of your workflow, not separate tool.

**How to apply:** Connect tools you use daily. Start with communication (Slack) and data (SQL).

## Verification Loop (Most Important)

**Give Claude a way to verify its work:**

- Background agents for long-running tasks
- Agent Stop hooks for deterministic verification
- Test every single change

**Why:** Feedback loop = 2-3x quality improvement. Without verification, Claude can't learn from mistakes.

**How to apply:**

1. Add tests that Claude can run
2. Use background agents to verify after completion
3. Use Stop hooks for automatic verification
4. Never merge without verification

## Prompting Style

**Challenge Claude, don't babysit:**

- "Grill me on these changes and don't make a PR until I pass your test"
- "Prove to me this works" - have Claude diff between main and branch
- "Knowing everything you know now, scrap this and implement the elegant solution"
- Paste bug, say "fix", don't micromanage how

**Why:** Claude is capable. Micromanaging wastes time and produces worse results.

**How to apply:** State the goal, let Claude figure out the how. Intervene only when stuck.

## Key Insight

**Verification is everything.** If Claude can test its own work, quality goes up 2-3x. Everything else is optimization.

**Why:** Without feedback, Claude can't improve. With feedback, Claude iterates to correct solution.

**How to apply:** Before starting any project, set up verification first. Tests, linters, type checkers - whatever gives Claude feedback.
