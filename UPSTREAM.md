# Upstream

- Source: https://github.com/mattpocock/skills (MIT)
- Pinned commit: `5863806dd4e15c63174bee4e7515a4256792ecfa` (2026-11-12, plugin version 1.3.2)

## Included (23)

| Group | Skills |
| --- | --- |
| Getting started | `setup-matt-pocock-skills`, `ask-matt` |
| Main flow | `grill-with-docs`, `to-spec`, `to-tickets`, `implement`, `implement-spec`, `code-review`, `retro` |
| Reference | `grilling`, `tdd`, `codebase-design`, `domain-modeling`, `pr` |
| Shaping | `prototype`, `research`, `wayfinder` |
| Engineering | `diagnosing-bugs`, `improve-codebase-architecture`, `triage` |
| Productivity | `handoff`, `grill-me`, `wait-what` |

Each skill folder is copied whole, without its `agents/openai.yaml` (Codex metadata).

## Excluded

| What | Why |
| --- | --- |
| `wizard`, `teach`, `to-questionnaire`, `writing-for-agents` | Human-facing or meta skills outside the code flow. Easy to add later: put the path in `INCLUDE` in the sync script. |
| `skills/misc/` | Frozen upstream. `git-guardrails-claude-code` duplicates marcsh's git guard. |
| `skills/in-progress/` | Unstable upstream. |
| `skills/deprecated/` | Deprecated. |
| `.claude-plugin/`, `.changeset/`, `.github/`, `scripts/`, `docs/` | Upstream packaging and docs. marcsh reads `agents/`, `skills/` and `commands/`. |

## Sync

```sh
scripts/sync-upstream.sh            # the pinned commit
scripts/sync-upstream.sh <commit>   # a newer one
```

Then:

1. Review `git diff skills/`. Look for new skills the agent prompt should route to, renamed skills, and new mentions of harness features (`/clear`, `/compact`, subagents, the Skill tool).
2. Update `agents/matt.md` and `commands/` to match.
3. Update the pinned commit here and in `scripts/sync-upstream.sh`.
4. Test from a branch: `/agents install <owner>/marcsh-matt@<branch>`.

Never edit files under `skills/` by hand. Put every marcsh-specific change in `agents/` or `commands/`, so a sync stays a plain diff.
