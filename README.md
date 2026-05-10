# multi-agent-starter-kit

A Claude Code starter kit that pairs an orchestrated agent pipeline with a
catalogue of reusable skills. Clone the repo, run one script, and the skills
become loadable inside Claude Code — either globally or scoped to this project.

## Structure

```
multi-agent-starter-kit/
├── docs/
│   ├── prd/                    <-- The "Why" and user flows
│   ├── rfc/                    <-- The "How" and global rules
│   ├── adr/                    <-- (Lazy) Hard-to-reverse decisions
│   └── context.md              <-- (Lazy) Project-wide domain glossary
├── tasks/                      <-- Exact steps and technical specs per feature
├── roadmap.json                <-- Map of pending vs. done tasks
├── CLAUDE.md                   <-- Orchestrator contract
├── .claude/
│   └── AGENTS/
│       ├── architect.md
│       ├── backend.md
│       ├── frontend.md
│       ├── ui-designer.md
│       └── qa-ux.md
├── skills/                     <-- One folder per skill, each holds SKILL.md
│   ├── caveman/
│   ├── diagnose/
│   ├── grill-me/
│   ├── grill-with-docs/
│   ├── improve-codebase-architecture/
│   ├── prototype/
│   ├── tdd/
│   ├── to-prd/
│   ├── write-a-skill/
│   └── zoom-out/
└── scripts/
    ├── link-skills.sh          <-- Install skills via symlinks
    └── list-skills.sh          <-- Print every SKILL.md in the repo
```

`docs/adr/` and `docs/context.md` are created lazily by the skills the first
time they have something to write — there is no need to scaffold them
upfront.

## Skills catalogue

Each skill is a single `SKILL.md` adapted to this kit's anchors
(`docs/prd/`, `docs/rfc/`, `docs/adr/`, `docs/context.md`, `tasks/`,
`roadmap.json`, and the `.claude/AGENTS/` pipeline).

| Skill                              | What it does                                                           |
| ---------------------------------- | ---------------------------------------------------------------------- |
| `caveman`                          | Ultra-compressed reply mode for ~75% fewer tokens.                     |
| `diagnose`                         | Six-phase debug loop wired to `tasks/` and the `qa-ux` handoff.        |
| `grill-me`                         | Relentless one-question-at-a-time interview on a plan.                 |
| `grill-with-docs`                  | Same interview, anchored to the kit's PRDs / RFCs / glossary / ADRs.   |
| `improve-codebase-architecture`    | Surface shallow modules; emit refactors as `tasks/` + `roadmap.json`.  |
| `prototype`                        | Build a throwaway spike that answers one question, then capture verdict. |
| `tdd`                              | Vertical-slice red-green-refactor with `qa-ux` handoff.                |
| `to-prd`                           | Turn the current conversation into `docs/prd/<slug>.md`.               |
| `write-a-skill`                    | Scaffold a new `skills/<name>/SKILL.md` following kit conventions.     |
| `zoom-out`                         | Higher-level map of modules, callers, and matching RFCs.               |

## Install the skills

The intended flow is: clone the repo, run the script, the skills become
available in Claude Code.

```bash
git clone <this-repo>
cd multi-agent-starter-kit

# Default: install globally so every project can use the skills.
./scripts/link-skills.sh                  # → ~/.claude/skills/<name>

# Or scope them to this repo only.
./scripts/link-skills.sh --project        # → ./.claude/skills/<name>

# Or a custom location.
./scripts/link-skills.sh --target /path/to/skills

# See what would happen first.
./scripts/link-skills.sh --dry-run
```

The script creates one symlink per skill. Re-running it overwrites existing
symlinks, but refuses to clobber a directory that isn't already a symlink —
hand-authored skills at the target are safe.

To see every skill the script would install:

```bash
./scripts/list-skills.sh
```

## Start a new project from scratch

Once the skills are installed, kick off a fresh project with this five-step
ritual. Each step writes a durable artifact, so when you (or the agent) come
back tomorrow, `roadmap.json` + `tasks/` are enough for the orchestrator to
pick up exactly where it left off.

1. **Brief the agent.** Open a new chat in Claude Code and explain, in plain
   prose, what you want to build — the user, the problem, the rough scope,
   any constraints. Don't try to be exhaustive; the next step exists
   precisely because you'll be missing things.

   Example of the first prompt:

   > I want to build a small web app for tracking the books I'm reading. The
   > user is just me. Core need: log a book with title + author, mark it as
   > "reading / finished / abandoned", and add a one-paragraph note when I
   > finish it. Stack constraint: keep it boring — a single backend service,
   > one database, no auth for v1. Out of scope: social features,
   > recommendations, mobile apps. Before we do anything else, please
   > `/grill-me` until the plan is tight, then turn it into a PRD and RFC
   > and seed `roadmap.json`.

   Notice it names the user, the problem, the rough scope, the constraints,
   what's *not* in scope, and ends by handing the agent the next move
   (`/grill-me`). That last sentence is what triggers the rest of the
   ritual.

2. **Ask to be grilled.** Tell the agent `/grill-me` (or `/grill-with-docs`
   if you already have notes in `docs/`). It will interview you one question
   at a time, with a recommended answer per question, until the design tree
   is resolved. Override anything that doesn't match your intent. Stop when
   the agent says it has no more questions that would change the plan.

3. **Generate the PRD.** Run `/to-prd`. The agent synthesises the grilled
   conversation into `docs/prd/<slug>.md` — problem, solution, user stories,
   scope, acceptance signals, open questions. Skim it; tweak anything wrong
   before moving on. This file is now the *what* and *why*.

4. **Request the RFC from the PRD.** Ask the `architect` agent to read the
   PRD and produce `docs/rfc/<slug>.md` — module breakdown, data shapes,
   integration points, the *how*. If you spot architectural decisions that
   feel hard to reverse, ask for an `docs/adr/<NNNN>-<slug>.md` alongside
   the RFC.

5. **Slice into tasks + roadmap.** Have the agent split the RFC into
   independently-shippable steps, one `tasks/<NN>-<slug>.md` per slice, and
   append matching entries to `roadmap.json` (`status: "pending"`, with the
   exact `file_path`). One task ≈ one PR's worth of work.

From this point on, every new session can start with a single instruction —
*"work the roadmap"* — and the orchestrator in `CLAUDE.md` will read
`roadmap.json`, open the first pending task, and delegate down the
`architect → backend → ui-designer + frontend → qa-ux` pipeline.

Re-run steps 1–3 whenever scope shifts; re-run steps 4–5 whenever a new
slice becomes possible. The only state the agent needs to resume work is on
disk: PRDs, RFCs, ADRs, tasks, and the roadmap.

## How the skills plug into the orchestrator

`CLAUDE.md` defines a strict execution loop: read `roadmap.json`, open the
matching `tasks/<id>-<slug>.md`, then delegate sequentially to
`architect → backend → ui-designer + frontend → qa-ux`. The skills slot into
that loop without replacing it:

- **Before tasks exist** — `/grill-me`, `/grill-with-docs`, `/to-prd`, and
  `/prototype` produce the artifacts (`docs/prd/`, `docs/rfc/`, `docs/adr/`)
  that downstream agents consume.
- **Inside the loop** — `/tdd` shapes how `backend` and `frontend` write code;
  `/diagnose` is the debug discipline when a task uncovers a bug; `/zoom-out`
  helps any agent get its bearings.
- **After the loop** — `/improve-codebase-architecture` emits new task files
  + `roadmap.json` entries when refactors land; `/write-a-skill` captures
  recurring workflows as new entries in `skills/`.

Skills hand off to the right `.claude/AGENTS/` agent — they never flip
`roadmap.json` status themselves. That stays the orchestrator's job.

## Adding your own skill

Run `/write-a-skill` (after install) or hand-author a new folder:

```
skills/<your-slug>/
└── SKILL.md
```

`SKILL.md` needs YAML frontmatter with `name` and `description` (the
description is the only thing other agents see when deciding to load the
skill — make the trigger phrases obvious). Then re-run
`./scripts/link-skills.sh` to symlink it into place.

## Credits

The skills in this kit are adapted from
[Matt Pocock's `mattpocock/skills`](https://github.com/mattpocock/skills) —
specifically the `engineering` and `productivity` collections. Each
`SKILL.md` here has been rewired to this kit's anchors (`docs/prd/`,
`docs/rfc/`, `docs/adr/`, `docs/context.md`, `tasks/`, `roadmap.json`, and
the `.claude/AGENTS/` pipeline). The install script pattern
(`scripts/link-skills.sh`, `scripts/list-skills.sh`) is also modelled on
his repository.

Huge thanks to Matt for publishing the originals.
