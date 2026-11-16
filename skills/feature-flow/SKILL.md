---
name: feature-flow
description: "Orchestrate one feature through Matt's main flow: route it (which optional phases it needs), get the route approved, then run every phase in order through implement-spec and retro. Use for any new feature, change request or incoming issue, and to resume one."
---

# Feature flow

You are the orchestrator. Every feature goes down Matt's main flow, from idea to ship. The spine is fixed. Only the optional phases before it change per feature, and you decide which ones it needs.

This skill is part of this pack, not of upstream. It sits on top of the upstream skills and never replaces them. Load each phase's skill and follow its `SKILL.md`. This file only decides **which** phases run, **in what order**, and **where you stop**.

## The route

| # | Phase | Skill | When |
| --- | --- | --- | --- |
| 0 | Setup | `setup-matt-pocock-skills` | Only if `docs/agents/issue-tracker.md` is missing. |
| 1 | Intake | `triage` | Optional, see below. |
| 2 | Diagnose | `diagnosing-bugs` | Optional, see below. |
| 3 | Map | `wayfinder` | Optional, see below. |
| 4 | Research | `research` | Optional, see below. |
| 5 | Grill | `grill-with-docs` | Optional, see below. |
| 6 | Prototype | `prototype` | Optional, see below. |
| 7 | Spec | `to-spec` | **Always.** |
| 8 | Tickets | `to-tickets` | **Always**, even when there is a single ticket. |
| 9 | Build | `implement-spec` | **Always.** It drives `tdd` per ticket and runs `code-review` once on the integration branch. Never use `/implement`: this pack does not ship it. |
| 10 | PR | `pr` | When the tracker closes work through PRs, or the user asks for one. |
| 11 | Retro | `retro` | **Always**, in the build session, before `/new`. |

## Routing the optional phases

Decide each optional phase from evidence: the request, the issue, the repo, `GLOSSARY.md`, the ADRs, and earlier `.scratch/` work. Give one line of reason per phase. When the evidence is mixed, include the phase. A wasted interview costs minutes; a spec built on a guess costs the build.

- **Intake (`triage`)**: run it when the work arrives as a raw issue someone else filed (a bug report or feature request not yet `ready-for-agent`). Skip it for your own ideas and for tickets `to-tickets` made.
- **Diagnose (`diagnosing-bugs`)**: run it when something is broken, throwing, flaky, slow or regressed. It gets a failing repro and a fix with a regression test. Then go to Retro, skipping 3 to 10. Exception: if the diagnosis shows the fix is really new behaviour or a design change, record that in `FLOW.md` and continue at Grill with the diagnosis as input.
- **Map (`wayfinder`)**: run it when the effort is too foggy for one session of decisions: greenfield, several subsystems, many decisions nobody has made. Never use it for a well-scoped feature. When the map clears, join the spine at Spec. Skip Grill unless the map left open decisions.
- **Research (`research`)**: run it when a decision waits on facts outside the repo (a third-party API, library behaviour, a standard, a spec). Start it in the background before Grill and feed the file into Grill.
- **Grill (`grill-with-docs`)**: run it by default. Skip it only when **all** of these are true:
  - the behaviour and the acceptance criteria are already written down (an agent-ready issue, a cleared wayfinder map, or an earlier grill whose decisions are in `GLOSSARY.md` or ADRs);
  - the feature brings no new domain term;
  - no design decision is open.

  When you skip it, read that written source into the conversation before Spec, because `to-spec` only synthesises what the conversation holds.
- **Prototype (`prototype`)**: run it when a question needs a runnable answer that conversation cannot settle: a state model or logic with many cases or transitions, or a UI whose look is not agreed. It usually comes up during Grill. Add it to the route then, and record why.

## Steps

### 1. Open or resume the flow

- With a request: pick a short kebab-case feature slug and create `.scratch/<slug>/FLOW.md` from the template below. Quote the request verbatim.
- With `resume <slug>`, or no argument: read `.scratch/*/FLOW.md`. With no argument, list the open flows and ask which one. Report where it stands, then continue at the first unfinished phase.

### 2. Route

Explore just enough to decide the optional phases (the request, the issue, related code, the glossary, the ADRs). Write the proposed route into `FLOW.md`: every phase marked `run` or `skip`, each with its reason.

### 3. Get the route approved

Show the route to the user as a short table and ask them to approve or change it. This is the one approval for the whole flow. After it, running each `run` phase counts as the user asking for that skill by name. Record the answer verbatim in the Log. Change the route later only with a new approval, also logged.

### 4. Run the phases

Run each `run` phase in order. After each one:

- mark it `done` in `FLOW.md`, with pointers to what it produced (spec path or issue, ticket paths, ADRs, research file, prototype branch, integration branch, PR);
- log every user decision verbatim.

Keep the human gates the skills already have: the grilling questions, the seam check in `to-spec`, the ticket quiz in `to-tickets`, and the guard for commits, pushes and PRs. Never answer them for the user.

### 5. Phase boundaries

- **Grill, Prototype, Spec and Tickets stay in one unbroken context**, so the spec and the tickets build on the reasoning itself, not on a summary of it. Do not suggest `/compact` or `/new` before Tickets is done. If the context nears ~150k tokens first, recommend `/compact` at the nearest boundary, with an instruction that keeps the open decisions.
- **Prototype is a detour into its own session.** Run `handoff` out with the design question, and tell the user to open a fresh session (`/new`) and run `/prototype` from the handoff file. When they come back, run `handoff` back. Record the verdict and the `prototype/<name>` branch in `FLOW.md`. Then resume the flow with `/feature-flow resume <slug>`.
- **Before Build**, recommend one move by the tree in `ask-matt/PHASE-BOUNDARIES.md`. The tickets are self-contained, so `/new` followed by `/feature-flow resume <slug>` is usually right. Continuing is fine if there is room. Never run `/new` or `/compact` yourself.
- **Retro runs in the build session**, before anyone clears it.

### 6. Build

Build needs Build permission. In Plan, stop and tell the user to switch. Then follow `implement-spec` with this pack's subagents:

- one `implementer` per frontier ticket, each in its own worktree and branch;
- one `merger` per finished branch;
- two `reviewer`s (Standards and Spec) for the final `code-review`;
- one fresh `implementer` for the review fixes.

On pi, start the implementers and mergers with `background: true`. A foreground subagent is stopped after 3 minutes; a background one is not. At most 4 run at once, so start new ones as earlier ones finish. Background subagents do not work in Plan or in `marcsh run`. On Claude, use `Task` as usual.

### 7. Close

Run PR if routed, then Retro. Mark the flow `done` in `FLOW.md`, then report: what shipped (integration branch, PR), the tickets closed, the review results per axis, and what Retro suggested.

## FLOW.md template

```markdown
# Flow: <slug>

Status: routing | approved | in progress | done
Request: "<the user's words, verbatim>"

## Route

| # | Phase | Decision | Reason | State | Pointer |
| --- | --- | --- | --- | --- | --- |
| 5 | Grill | run | new domain term "<x>" | done | GLOSSARY.md, docs/adr/00NN |
| 7 | Spec | run | always | pending | |

## Log

- L1 (request): "<verbatim>"
- L2 (route approval): "<verbatim>"
```
