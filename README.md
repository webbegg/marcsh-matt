# marcsh-matt

A [marcsh](https://github.com/webbegg/marcsh) pack that runs [Matt Pocock's engineering skills](https://www.aihero.dev/skills) (`mattpocock/skills`, MIT) as a marcsh workflow: grill an idea, write a spec, split it into tickets, build test-first, review, and look back.

The skills are copied unchanged. This pack adds only what marcsh needs: an agent that routes between the skills, four subagents, and slash commands that work from any selected agent.

## Install

```
/agents install <owner>/marcsh-matt
```

Then run `/setup-matt-pocock-skills` once in each repository, and `/ask-matt` when you are unsure where to start.

## The main flow

| Step | Command | What it does |
| --- | --- | --- |
| 0 | `/setup-matt-pocock-skills` | Picks the issue tracker (local `.scratch/`, GitHub or GitLab) and the domain doc layout. |
| 1 | `/grill-with-docs` | Interviews you about the plan and records decisions in `GLOSSARY.md` and ADRs. |
| 2 | `/to-spec` | Turns the agreed conversation into a spec. |
| 3 | `/to-tickets` | Splits the spec into tracer-bullet tickets with blocking edges. |
| 4 | `/implement` or `/implement-spec` | Builds one ticket per session, or the whole spec with parallel subagents. |
| 5 | `/code-review` | Reviews the diff on two axes, Standards and Spec, in parallel subagents. |
| 6 | `/retro` | Suggests improvements to the repo's agent environment. |

Other commands: `/ask-matt`, `/grill-me`, `/wayfinder`, `/prototype`, `/research`, `/diagnosing-bugs`, `/improve-codebase-architecture`, `/triage`, `/handoff`, `/wait-what`, `/tdd`. The `pr`, `grilling`, `codebase-design` and `domain-modeling` skills have no command: the agent loads them when they fit.

If a command name is taken by marcsh or the engine, marcsh lists it as `/marcsh-matt:<name>`.

## Layout

| Path | What it is |
| --- | --- |
| `agents/matt.md` | The agent you select (`Matt`). Its prompt says how the skills map onto marcsh. |
| `agents/implementer.md`, `merger.md`, `reviewer.md`, `researcher.md` | Subagents for `implement-spec`, `code-review`, `research` and `wayfinder`. |
| `commands/*.md` | Entry points. Each runs its turn as `Matt` and loads one skill. |
| `skills/` | The upstream skills, unchanged. Do not edit them here; see [UPSTREAM.md](UPSTREAM.md). |
| `scripts/sync-upstream.sh` | Copies the included skills from a pinned upstream commit. |

## How it differs from upstream

- `/clear` in the skills means marcsh's `/new`.
- Upstream's user-only skills (`disable-model-invocation`) are enforced by the agent prompt, because marcsh does not read that field.
- While `Matt` is selected, this flow replaces the lanes of `marcsh:workflow`: one-session work is `/implement`, multi-session work is `/to-spec` → `/to-tickets` → `/implement`.
- On pi, subagents stop after 3 minutes and at most 4 run in the background, so `Matt` prefers `/implement` per ticket over `/implement-spec` unless the tickets are small.
- Commits, pushes and PRs go through marcsh's guard.
- No hooks and no MCP servers.

## License

The skills in `skills/` are © 2026 Matt Pocock, MIT. See [NOTICE.md](NOTICE.md) and [LICENSES/mattpocock-skills-MIT.txt](LICENSES/mattpocock-skills-MIT.txt).
