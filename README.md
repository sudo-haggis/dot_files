# dot_files

System configuration and machine recovery for Ubuntu workstations.

Clone this repo on a fresh machine, run `install.sh`, and be back to a working environment fast.

---

## What This Is

Two things in one repo:

**Configuration management** — Tool configs (nvim, tmux, bash, git, ssh, alacritty) managed with GNU Stow and symlinked into place on the host machine.

**Machine recovery** — A daily snapshot of the live environment (packages, services, crontabs) committed to a per-machine branch. If a machine dies, the snapshot tells a new one exactly what to install.

---

## Quick Start

```bash
# Clone
git clone git@github.com:sudo-haggis/dot_files.git ~/.dotfiles
cd ~/.dotfiles

# Bootstrap new machine (creates machine branch, installs packages, runs stow)
sudo ./install.sh
```

---

## Branch Structure

| Branch | Purpose |
|---|---|
| `main` | Clean baseline. Template for new machines. |
| `machine/<hostname>` | Per-machine branch. Snapshots live here. |

Machine branches are created automatically by `install.sh` and rebased onto `main` to pull down improvements without overwriting machine-specific state.

---

## Scripts

| Script | Description |
|---|---|
| `install.sh` | Bootstrap a new machine from scratch |
| `snapshot.sh` | Capture live machine state, commit to machine branch |
| `files_backup.sh` | Rsync important data to local SD card |

### Running a Snapshot Manually
```bash
./snapshot.sh
```

### Snapshot runs daily via cron
```
0 2 * * * /home/<user>/.dotfiles/snapshot.sh
```

---

## Stow

All configs are managed with [GNU Stow](https://www.gnu.org/software/stow/). Run from the repo root:

```bash
# Apply all configs
stow bash nvim tmux git ssh alacritty

# Single package
stow nvim

# Remove symlinks
stow -D nvim
```

---

## Snapshot Contents

Each daily snapshot captures:

- APT package list (all installed)
- Manually installed APT packages
- Snap packages
- User and system crontabs
- Enabled systemd user services
- System info (hostname, OS, kernel, timezone, locale, shell)
- Manifest with timestamp and machine details

Output lives in `snapshot/<hostname>/` on the machine branch.

---

## Data Redundancy

Every machine maintains three copies of its configuration:

```
GitHub (cloud)          ← always in sync via snapshot push
~/.dotfiles (live)      ← working copy on the machine
SD card (local)         ← daily rsync via files_backup.sh
```

Three points of failure required before data is lost.

---

## Commit Format

Enforced by global git hook. Non-negotiable.

```
type(scope): this will <message>
```

```bash
feat(snapshot): add systemd service collector
fix(install): handle missing snap packages gracefully
chore(snapshot): daily automated capture
docs(readme): update recovery steps
```

---

## Stack

- **OS:** Ubuntu
- **Editor:** Neovim
- **Terminal:** Alacritty + Tmux
- **Symlinks:** GNU Stow
- **Packages:** apt, snap
- **Version Control:** Git

---

## Roadmap

- [x] Stow-based config management
- [x] Global git hooks (conventional commits, secret scanning)
- [ ] `snapshot.sh` — modular live environment capture
- [ ] `install.sh` — new machine bootstrap
- [ ] `files_backup.sh` — SD card rsync
- [ ] Cron setup for daily automation
- [ ] Per-machine branch automation
- [ ] README updated to reflect completed implementation

---

## Repository

[github.com/sudo-haggis/dot_files](https://github.com/sudo-haggis/dot_files)
