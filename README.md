# marcsh-matt

A [marcsh](https://github.com/webbegg/marcsh) pack that runs [Matt Pocock's engineering skills](https://www.aihero.dev/skills) (`mattpocock/skills`, MIT) as a marcsh workflow: grill an idea, write a spec, split it into tickets, build test-first, review, and look back.

The skills are copied unchanged. On top of them the pack adds an orchestrator (`feature-flow`) that sends every feature down the main flow, the `Matt` agent that runs it, four subagents, and slash commands that work from any selected agent.

## Install

```
/agents install <owner>/marcsh-matt
```

Then start every feature with:

```
/feature-flow <what you want built>
/feature-flow resume <slug>
```

## The orchestrator

`/feature-flow` routes the feature, shows you the route, and runs it once you approve. The state lives in `.scratch/<slug>/FLOW.md`, so a flow resumes in any session.

| # | Phase | Skill | When |
| --- | --- | --- | --- |
| 0 | Setup | `setup-matt-pocock-skills` | The repo has no tracker config yet. |
| 1 | Intake | `triage` | The work is a raw issue someone else filed. |
| 2 | Diagnose | `diagnosing-bugs` | Something is broken. Goes on to Retro, or to Grill if the fix is really new behaviour. |
| 3 | Map | `wayfinder` | The effort is too foggy for one session of decisions. |
| 4 | Research | `research` | A decision waits on facts outside the repo. |
| 5 | Grill | `grill-with-docs` | By default. Skipped only when behaviour and acceptance are written down, with no new terms and no open decisions. |
| 6 | Prototype | `prototype` | A question needs a runnable answer (a state model, a UI). It runs in its own session through `handoff`. |
| 7 | Spec | `to-spec` | Always. |
| 8 | Tickets | `to-tickets` | Always. |
| 9 | Build | `implement-spec` | Always: parallel implementers, `tdd` per ticket, one `code-review`. |
| 10 | PR | `pr` | When the tracker closes work through PRs, or you ask. |
| 11 | Retro | `retro` | Always, in the build session. |

The pack does not ship upstream's `implement`: every build goes through `implement-spec`.

Each phase also has its own command, for running it by hand: `/setup-matt-pocock-skills`, `/grill-with-docs`, `/to-spec`, `/to-tickets`, `/implement-spec`, `/code-review`, `/retro`, `/ask-matt`, `/grill-me`, `/wayfinder`, `/prototype`, `/research`, `/diagnosing-bugs`, `/improve-codebase-architecture`, `/triage`, `/handoff`, `/wait-what`, `/tdd`. The `pr`, `grilling`, `codebase-design` and `domain-modeling` skills have no command: the agent loads them when they fit.

If a command name is taken by marcsh or the engine, marcsh lists it as `/marcsh-matt:<name>`.

## Layout

| Path | What it is |
| --- | --- |
| `agents/matt.md` | The agent you select (`Matt`). It sends feature work through `feature-flow` and says how the skills map onto marcsh. |
| `skills/feature-flow/` | The orchestrator. Owned by this pack, not upstream. |
| `agents/implementer.md`, `merger.md`, `reviewer.md`, `researcher.md` | Subagents for `implement-spec`, `code-review`, `research` and `wayfinder`. |
| `commands/*.md` | Entry points. Each runs its turn as `Matt` and loads one skill. |
| `skills/` (the rest) | The upstream skills, unchanged. Do not edit them here; see [UPSTREAM.md](UPSTREAM.md). |
| `scripts/sync-upstream.sh` | Copies the included skills from a pinned upstream commit. |

## How it differs from upstream

- `/clear` in the skills means marcsh's `/new`.
- Upstream's user-only skills (`disable-model-invocation`) are enforced by the agent prompt, because marcsh does not read that field.
- While `Matt` is selected, `feature-flow` replaces the lanes of `marcsh:workflow`. There is no small lane: every change goes through spec, tickets and `implement-spec`.
- On pi, a foreground subagent stops after 3 minutes, so implementers and mergers run with `background: true`, at most 4 at a time. That needs Build (not Plan, not `marcsh run`).
- Commits, pushes and PRs go through marcsh's guard.
- No hooks and no MCP servers.

## License

The skills in `skills/` are © 2026 Matt Pocock, MIT. See [NOTICE.md](NOTICE.md) and [LICENSES/mattpocock-skills-MIT.txt](LICENSES/mattpocock-skills-MIT.txt).
