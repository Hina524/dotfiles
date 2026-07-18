Write a handoff document to `.agent/handoff.md` that captures the current session state for continuity after context compaction or session restart.

## When to use

- Context window is filling up (>70%) and compaction is approaching
- Switching to a new session mid-task
- Before running `/compact` manually

## Output format

Write `.agent/handoff.md` with the following structure (in English to minimize token cost):

```markdown
# Handoff

Updated: <ISO timestamp>

## Goal
<What we are trying to accomplish in one sentence>

## Current State
<Where we are right now — what's done, what's in progress>

## Key Decisions
- <Decision made and why>

## Discoveries
- <fact>: <source file:line or URL>

## Next Steps
1. <Immediate next action>
2. <Following action>

## Critical Context
<Any non-obvious constraints, gotchas, or context that would be lost after compaction>
```

## Rules

- If `.agent/handoff.md` already exists, UPDATE it — do not overwrite from scratch
- Keep it concise: the goal is token efficiency, not completeness
- Do NOT include sensitive values (tokens, passwords, keys)
- Create `.agent/` directory if it does not exist
- Always write in English
