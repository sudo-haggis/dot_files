# CLAUDE.md

Ahoy! Project context and workin' rules fer Claude Code sessions on this repo.

---

## Purpose

This repo is a personal developer environment automation toolkit fer Ubuntu workstations. It captures live machine state (installed packages, configs, services), enables rapid rebuild on new or replacement hardware, and keeps a consistent environment across multiple machines. It builds on the existin' `sudo-haggis/dot_files` stow-managed dotfiles structure.

The drivin' problem: "I just installed a new tool on machine A — how do I make sure machine B gets it too, and how do I rebuild from scratch if a machine dies?"

---

## Current Phase

**Phase 1 — `snapshot.sh`** is the active work.

Phases are logically separated and worked one at a time. Do not begin Phase 2 work during a Phase 1 session — finish the phase, merge, then move on.

- **Phase 1:** `snapshot.sh` — live machine state capture
- **Phase 2:** `install.sh` — new machine bootstrap
- **Phase 3:** `healthcheck.sh` — baseline vs reality comparison
- **Phase 4+:** out of scope until 1-3 are complete (see *Future Direction* below)

---

## Repo Structure

```
dot_files/
├── CLAUDE.md                        ← this file
├── README.md                        ← human-facing project plan
├── .claude/settings.json            ← Claude Code permissions
│
├── bash/ nvim/ tmux/ git/ ...       ← stow packages (existing)
│
├── snapshot.sh                      ← Phase 1
├── install.sh                       ← Phase 2 (not yet)
├── healthcheck.sh                   ← Phase 3 (not yet)
│
├── packages.conf/                   ← curated baseline (on main)
│   ├── apt.conf
│   ├── snap.conf
│   ├── pip.conf
│   └── curl.conf
│
└── machine/<hostname>/              ← per-machine snapshot (on machine branch)
    └── packages.conf/
        ├── apt.conf
        ├── snap.conf
        ├── pip.conf
        └── curl.conf
```

---

## Branch Strategy

```
main                      ← clean baseline, what a new machine gets
└── backup-scripts        ← feature branch — phases 1-3 work
    └── machine/<hostname>  ← per-machine, auto-created by install.sh
                             holds machine/<hostname>/ directory only
                             invisible to other machines
```

- `main` — curated baseline, cross-machine truth
- `backup-scripts` — current feature work (phases 1-3)
- `machine/<hostname>` — created by `install.sh`, receives daily snapshot commits

**Upgrade flow:** improvements PR'd intae `main` → each machine rebases its own `machine/<hostname>` branch onto the new `main`. Machine branches never merge intae each other.

---

## The Collector Pattern

`snapshot.sh` uses a modular collector pattern. Each package manager gets a function; all functions are registered in an array and iterated. Addin' a new manager = write a function, add one line tae the array.

```bash
collect_apt()  { dpkg --get-selections | awk '{print $1}' | sort > "$OUT/apt.conf"; }
collect_snap() { snap list | awk 'NR>1 {print $1" "$2}' | sort > "$OUT/snap.conf"; }
collect_pip()  { pip freeze | sort > "$OUT/pip.conf"; }
collect_curl() { cp "$REPO/packages.conf/curl.conf" "$OUT/curl.conf"; }

COLLECTORS=(
    collect_apt
    collect_snap
    collect_pip
    collect_curl
)

for collector in "${COLLECTORS[@]}"; do
    "$collector"
done
```

New collector? Write the function, add it tae `COLLECTORS`. Nothin' else changes.

---

## Package Config Format

One package per line. Alphabetically sorted. Version included where available.

```
git 2.43.0
neovim 0.9.5
stow 2.3.1
tmux 3.4
```

**Why this format:** identical shape between `main:packages.conf/apt.conf` and `machine/<hostname>/packages.conf/apt.conf` means `git diff` is the comparison tool. No custom diff scripts, no JSON, no snapshots-as-blobs. Git-native, greppable, human-readable.

---

## Coding Conventions

### Script header
Every script starts with:
```bash
#!/bin/bash
set -euo pipefail
```

### Naming
| Thing | Convention | Example |
|---|---|---|
| Scripts | `snake_case.sh` | `snapshot.sh`, `files_backup.sh` |
| Global vars | `UPPER_SNAKE_CASE` | `REPO_ROOT`, `OUT_DIR` |
| Local vars | `lower_snake_case` | `collector`, `hostname` |
| Functions | `verb_noun` | `collect_apt`, `restore_cron` |
| Config files | `<installer>.conf` | `apt.conf`, `snap.conf` |

**Name things for intent, not implementation.** `collect_apt` (what it does) not `run_dpkg` (how it does it). Implementation changes; intent shouldn't.

### Error handling
- Functions report success/failure explicitly
- Failures logged, never silently swallowed
- Use exit codes meaningfully (0 = ok, 1 = error, 2 = partial)
- No bare `|| true` without a comment explainin' why

---

## Commit Format

**Non-negotiable.** Enforced by global git hook.

```
type(scope): this will <message>
```

**Valid types:** `feat`, `fix`, `docs`, `chore`, `refactor`, `perf`, `test`

**Examples:**
```
feat(snapshot): this will add the apt collector function
fix(snapshot): this will handle missing snap binary gracefully
chore(snapshot): this will capture daily state on <hostname>
docs(claude): this will add the collector pattern example
refactor(snapshot): this will extract output path tae a helper
```

Always suggest a commit message when proposin' code changes. Suggest branch names when new work warrants one. Suggest `.gitignore` updates when new file types appear.

---

## Workin' with Claude Code

- **Davey writes the code.** Claude reviews, discusses, debugs, suggests. Do not write unprompted.
- **Describe before creatin'.** Propose the shape of any file or function and get confirmation before writin' it.
- **Keep responses tight.** Conversation, not lectures. Small, iterative, reviewable.
- **Enforce commit format** on every suggestion.
- **Suggest git hygiene:** commits, branches, `.gitignore`, README updates.
- **Follow the collector pattern** when addin' new capture sources — don't invent new structures.
- **Honour `.claude/settings.json`** — the permissions there are deliberate.
- **Pirate flair in chat is fine**, but code and commits stay professional.

---

## Definition of Done — Phase 1

`snapshot.sh` ships when all of these hold:

- [ ] Script exists at repo root wi' `set -euo pipefail`
- [ ] Collector pattern implemented (array + for loop)
- [ ] `collect_apt` produces sorted, versioned `apt.conf`
- [ ] `collect_snap` produces sorted, versioned `snap.conf`
- [ ] `collect_pip` produces sorted, versioned `pip.conf`
- [ ] `collect_curl` handles manually-tracked curl-installed tools
- [ ] Output lands in `machine/<hostname>/packages.conf/`
- [ ] Auto-commits tae `machine/<hostname>` branch wi' conformant message
- [ ] Cron entry documented in README (not installed by the script itself)
- [ ] README updated tae reflect Phase 1 complete

---

## Future Direction (out of scope)

**Phase 4** introduces SD card infrastructure — partitioned 58GB backup + 70GB data, mounted via fstab wi' `nofail`. The backup partition is not part of the live machine's runtime path (no symlinks intae it, no running process reads from it during normal operation), keepin' the system independent of the card's presence. It's read only during disaster recovery or fresh-machine bootstrap. The data partition hosts bulk files (`~/Media/`, `~/Archive/`) via symlinks from `~`, plus a portable clone of this repo fer offline bootstrap.

**Phase 5** adds `files_backup.sh` — an additive, archive-style rsync of `~/.config/`, `~/.dotfiles/`, and `~/.ssh/` intae `/mnt/sd/backup/`. New and changed files are copied; deletions on the live machine are **not** propagated tae the card, so the backup accumulates as a historical record. *Trade-off:* ye cannae tell from the card alone whether a missin' file "was deleted deliberately" or "never existed" — acceptable fer a personal archive, worth knowin'. *Future refinement:* `rsync --backup --backup-dir=...` would keep dated versions of overwritten files — skipped fer now tae keep Phase 5 simple.

**Phase 6** layers on offline package cachin' (`apt-get download` tae `/mnt/sd/data/packages-cache/`) enablin' `install.sh --offline`.

**Phase 7** handles overflow from the backup partition tae external storage when it approaches capacity.

---

## Stack

| Tool | Purpose |
|---|---|
| Ubuntu | Host OS |
| Neovim | Editor |
| Tmux | Terminal multiplexer |
| GNU Stow | Dotfile symlink management |
| Git | Version control + diff engine |
| Bash | Scripting language |
| apt / snap / pip | Package managers (Phase 1 targets) |

---

*Written by Davey, transcribed by Claude. This file is the source of truth fer project conventions — update it when conventions change.* 🏴‍☠️
