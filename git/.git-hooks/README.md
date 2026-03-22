
# Git Hooks - Global Collection

A streamlined set of Git hooks for maintaining code quality and consistency across all repositories.

## 🎯 Features

### `pre-commit` - Version Consistency
- Validates `VERSION` file format (vX.Y.Z)
- Auto-syncs versions across:
  - Source file headers (`@version`, `__version__`)
  - `package.json`
  - `pyproject.toml`
  - `setup.py`
- Supports: JavaScript, TypeScript, Python, PHP, Go

### `commit-msg` - Conventional Commits
- Enforces conventional commit format
- Pattern: `type(scope): message`
- Valid types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`
- Max length: 72 characters
- Bypass: Start message with `!`

### `pre-push` - Security Scanning
- Runs [gitleaks](https://github.com/gitleaks/gitleaks) to detect secrets
- Blocks push if sensitive data found
- Prevents accidental credential leaks

## 📦 Requirements

- **Bash** (default on most Unix systems)
- **Git** 2.9+ (for global hooks support)
- **gitleaks** - [Installation Guide](https://github.com/gitleaks/gitleaks#installing)

## 🚀 Installation

### From Gist (Recommended)

```bash
# Clone the gist to a local directory
git clone git@gist.github.com:YOUR_GIST_ID.git ~/.git-hooks-repo

# Create symlinks to the global hooks directory
mkdir -p ~/.git-hooks
ln -sf ~/.git-hooks-repo/pre-commit ~/.git-hooks/
ln -sf ~/.git-hooks-repo/commit-msg ~/.git-hooks/
ln -sf ~/.git-hooks-repo/pre-push ~/.git-hooks/

# Make them executable
chmod +x ~/.git-hooks/*

# Configure Git to use global hooks
git config --global core.hooksPath ~/.git-hooks
```

### Manual Installation

```bash
# Create hooks directory
mkdir -p ~/.git-hooks

# Copy hooks to directory
cp pre-commit commit-msg pre-push ~/.git-hooks/

# Make executable
chmod +x ~/.git-hooks/*

# Configure Git
git config --global core.hooksPath ~/.git-hooks
```

## 🔄 Updating Hooks

If hooks are managed via gist:

```bash
cd ~/.git-hooks-repo
git pull
```

Changes are immediately active due to symlinks!

## 📝 Usage Examples

### Version Management
```bash
# Update VERSION file manually
echo "v2.1.0" > VERSION
git add VERSION
git commit -m "chore: bump version to 2.1.0"
# pre-commit auto-syncs all version references
```

### Commit Messages
```bash
# ✅ Valid formats
git commit -m "feat(auth): add password reset"
git commit -m "fix(ui): resolve button alignment"
git commit -m "docs: update installation guide"

# ❌ Invalid formats
git commit -m "Added new feature"  # Missing type
git commit -m "feat add stuff"     # Missing colon

# 🚫 Bypass validation (use sparingly!)
git commit -m "!WIP: testing something"
```

### Security Scanning
```bash
git push
# pre-push automatically scans for secrets
# Push blocked if any detected
```

## 🎨 Color Scheme

Consistent output colors across all hooks:
- 🔵 **Blue** - Info/Progress
- 🟢 **Green** - Success
- 🟡 **Yellow** - Warnings
- 🔴 **Red** - Errors

## 🔧 Configuration

### Disable Hooks Temporarily
```bash
# Skip all hooks for one commit
git commit --no-verify -m "emergency fix"

# Skip hooks for one push
git push --no-verify
```

### Disable Globally
```bash
# Remove global hooks setting
git config --global --unset core.hooksPath

# Re-enable later
git config --global core.hooksPath ~/.git-hooks
```

### Per-Repo Override
```bash
# Use repo-specific hooks instead of global
cd /path/to/repo
git config core.hooksPath .git/hooks
```

## 🐛 Troubleshooting

### Hooks Not Running
```bash
# Check global config
git config --global core.hooksPath

# Verify hooks are executable
ls -la ~/.git-hooks/

# Make executable if needed
chmod +x ~/.git-hooks/*
```

### Gitleaks Not Found
```bash
# Install via Homebrew (macOS/Linux)
brew install gitleaks

# Or download binary from GitHub releases
# https://github.com/gitleaks/gitleaks/releases
```

### Version Sync Issues
- Ensure `VERSION` file exists in repo root
- Check file headers have correct format:
  - JS/TS: `@version v1.0.0`
  - Python: `__version__ = "v1.0.0"`
  - PHP: `@version v1.0.0`
  - Go: `version = "v1.0.0"`

## 📂 File Structure

```
~/.git-hooks-repo/          # Gist clone (version controlled)
├── pre-commit              # Version consistency checker
├── commit-msg              # Message format validator
├── pre-push                # Security scanner
└── README.md               # This file

~/.git-hooks/               # Active hooks (symlinks)
├── pre-commit -> ~/.git-hooks-repo/pre-commit
├── commit-msg -> ~/.git-hooks-repo/commit-msg
└── pre-push -> ~/.git-hooks-repo/pre-push
```

## 🤝 Contributing

These hooks are managed as a GitHub Gist. To suggest improvements:

1. Update hooks in `~/.git-hooks-repo/`
2. Test thoroughly across multiple repos
3. Commit and push to gist:
   ```bash
   cd ~/.git-hooks-repo
   git add .
   git commit -m "feat: add new validation"
   git push
   ```

## 📜 License

MIT - Use freely, modify as needed!

## 🔗 Links

- [Conventional Commits](https://www.conventionalcommits.org/)
- [Gitleaks](https://github.com/gitleaks/gitleaks)
- [Git Hooks Documentation](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks)

---

**Version:** See `VERSION` file  
**Last Updated:** 2025-02-03
