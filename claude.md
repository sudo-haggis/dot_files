# CLAUDE.md — Project Context for Claude Code

This file provides context for AI-assisted development on this repository.
Update this file as the project evolves.

---

## Project Overview

`sudo-haggis/dot_files` is a personal system configuration and machine recovery repository.
It serves two purposes:

1. **Configuration management** — All tool configs managed via GNU Stow and symlinked to the correct locations on the host machine.
2. **Machine recovery** — A snapshot system that captures the state of a live machine (packages, services, crons, environment) enabling rapid rebuild on new hardware.

The goal: clone this repo on a fresh machine, run one script, and be back to a working environment as fast as possible.

---

## Repository Structure

```
dot_files/
├── bash/               # Bash configs (.bashrc, aliases, functions)
├── nvim/               # Neovim configuration
├── tmux/               # Tmux configuration
├── git/                # Git config and global hooks
├── ssh/                # SSH config (no keys committed)
├── alacritty/          # Terminal emulator config
├── scripts/            # Utility scripts
├── snapshot/           # Machine state captures (per-machine, gitignored sensitive data)
│   └── <hostname>/     # Named by machine hostname
│       ├── apt_packages.txt
│       ├── manual_packages.txt
│       ├── snap_packages.txt
│       ├── crontabs.txt
│       ├── systemd_services.txt
│       ├── system_info.txt
│       └── manifest.txt
├── snapshot.sh         # Live machine snapshot script
├── install.sh          # New machine bootstrap script
├── files_backup.sh     # File backup to SD card (rsync-based)
├── CLAUDE.md           # This file
└── README.md           # Project documentation
```

---

## Branch Strategy

This is a multi-machine repository. Branch discipline is critical.

| Branch | Purpose |
|---|---|
| `main` | Clean baseline. Template for new machines. Only deliberate, tested changes land here. |
| `machine/<hostname>` | Per-machine branch. Auto-created by `install.sh`. Rebased onto main regularly. |

**Rules:**
- `snapshot.sh` always commits to the current machine branch, never `main`
- Config improvements intended for all machines are PRed into `main`
- Each machine branch rebases onto `main` to pull down improvements
- Never force push `main`

---

## Key Scripts

### `snapshot.sh`
Captures the state of the **live running machine**. Designed to run daily via cron or manually at any time.

Uses a modular collector pattern:

```bash
COLLECTORS=(
    collect_apt
    collect_snap
    collect_cron
    collect_systemd
    collect_system_info
    # Add new collectors here
)

for collector in "${COLLECTORS[@]}"; do
    $collector
done
```

Each collector is a self-contained function responsible for one data source. Adding support for a new package manager or tool requires only writing a new function and appending it to the array.

On completion, the script commits the snapshot to the current `machine/<hostname>` branch and pushes.

### `install.sh`
Bootstrap script for a new machine. Run after cloning the repo.

Steps:
1. Detect hostname, create `machine/<hostname>` branch from `main`
2. Install packages from snapshot lists (apt, snap)
3. Run `stow` on all config directories
4. Restore crontabs
5. Report any failures cleanly

### `files_backup.sh`
Rsync-based backup of important data to an SD card. Includes the dot_files repo itself, ensuring a local copy of all config and snapshot data exists on every machine. Runs daily via cron alongside `snapshot.sh`.

Currently stubbed — storage paths are configured per machine.

---

## Stow Usage

All configs are managed with GNU Stow. Run from the repository root:

```bash
# Stow all packages
stow bash nvim tmux git ssh alacritty

# Stow a single package
stow nvim

# Remove symlinks
stow -D nvim
```

Stow symlinks each directory's contents into `$HOME`, matching the expected config paths.

---

## Conventions

### Commit Format
Non-negotiable. Enforced by global git hook.

```
type(scope): this will <message>
```

Valid types: `feat`, `fix`, `docs`, `chore`, `refactor`, `perf`, `test`

Examples:
```
feat(snapshot): add systemd service collector
fix(install): handle missing snap packages gracefully
chore(snapshot): daily automated capture on machinename
docs(readme): update recovery instructions
```

### Naming
- Scripts: `snake_case.sh`
- Variables: `UPPER_SNAKE_CASE` for globals, `lower_snake_case` for locals
- Functions: `verb_noun` pattern — `collect_apt`, `restore_cron`, `backup_files`
- Snapshot output files: `<type>_<source>.txt` — `apt_packages.txt`, `snap_packages.txt`

### Error Handling
- All scripts use `set -euo pipefail` at the top
- Functions report success/failure explicitly
- Failed package installs are logged to `failed_<type>.txt`, never silently skipped

---

## Data Redundancy Model

Each machine maintains three copies of its configuration:

| Copy | Location | Updated |
|---|---|---|
| Working | Live machine (`~/.dotfiles`) | Continuously |
| Cloud | GitHub (`sudo-haggis/dot_files`) | On snapshot/push |
| Local backup | SD card (via `files_backup.sh`) | Daily via cron |

---

## Stack

| Tool | Purpose |
|---|---|
| Ubuntu | Host OS |
| Neovim | Editor |
| Tmux | Terminal multiplexer |
| GNU Stow | Symlink management |
| Git | Version control |
| Bash | Scripting language |
| apt / snap | Package managers |

---

## What Claude Should Know

- Davey writes the code. Claude reviews, discusses, debugs, and suggests.
- Always discuss and get confirmation before creating or modifying files.
- Suggest commits, branch names, and `.gitignore` updates where relevant.
- Keep responses concise. This is a conversation, not a lecture.
- Commit format is non-negotiable — enforce it in all suggestions.
- When adding a new collector or feature, follow the existing modular pattern.
- README.md should be updated to reflect any significant changes to structure or scripts.

---

## Current Status

See `README.md` for current implementation status and roadmap.
