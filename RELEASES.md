# Release Management Guide

This project uses [Changesets](https://github.com/changesets/changesets) for automated version management and releases.

## 📋 Table of Contents

- [Overview](#overview)
- [Creating a Changeset](#creating-a-changeset)
- [Release Process](#release-process)
- [Version Types](#version-types)
- [Best Practices](#best-practices)

## 🎯 Overview

Changesets help us:
- 📝 Track changes that need to be released
- 🔢 Automatically bump versions
- 📄 Generate CHANGELOGs
- 🏷️ Create GitHub releases
- 🤖 Automate the entire release process

## ✍️ Creating a Changeset

When you make a change that should be released, create a changeset:

### 1. Run the changeset command

```bash
bun run changeset
```

Or use bunx directly:

```bash
bunx changeset
```

### 2. Select the version bump type

You'll be prompted to select the type of change:
- **patch** (1.0.0 → 1.0.1): Bug fixes, small improvements
- **minor** (1.0.0 → 1.1.0): New features, non-breaking changes
- **major** (1.0.0 → 2.0.0): Breaking changes

### 3. Write a summary

Describe what changed. This will appear in the CHANGELOG.

**Example:**
```
Add support for Starship prompt and zsh-autosuggestions plugin
```

### 4. Commit the changeset

```bash
git add .changeset/
git commit -m "docs: add changeset for starship integration"
git push
```

## 🚀 Release Process

### Automated (Recommended)

When you push to `master`:

1. **GitHub Actions** detects changesets
2. A **Release PR** is automatically created
3. The PR includes:
   - Version bumps
   - Updated CHANGELOG
   - All pending changesets merged
4. When you **merge the Release PR**:
   - Version is tagged
   - GitHub release is created
   - CHANGELOG is updated

### Manual

If you need to release manually:

```bash
# 1. Version the packages
bun run version

# 2. Commit the version changes
git add .
git commit -m "chore: version packages"

# 3. Create a git tag
git tag -a v1.0.0 -m "Release v1.0.0"

# 4. Push changes and tags
git push && git push --tags
```

## 📊 Version Types

### Patch (1.0.0 → 1.0.1)
**When to use:**
- Bug fixes
- Documentation updates
- Performance improvements
- Dependency updates
- Typo fixes

**Examples:**
```bash
# Bug fix
fix: correct zsh-autosuggestions path

# Documentation
docs: update README with new features

# Performance
perf: optimize shell startup time
```

### Minor (1.0.0 → 1.1.0)
**When to use:**
- New features
- New plugins
- Non-breaking enhancements
- New aliases/functions

**Examples:**
```bash
# New feature
feat: add Starship prompt integration

# New plugin
feat: add fzf fuzzy finder integration

# Enhancement
feat: add AI agent auto-detection
```

### Major (1.0.0 → 2.0.0)
**When to use:**
- Breaking changes
- Removed features
- Changed configuration structure
- Incompatible updates

**Examples:**
```bash
# Breaking change
BREAKING: replace Oh-My-Posh with Starship

# Removed feature
BREAKING: remove GVM support

# Changed structure
BREAKING: restructure configuration files
```

## 💡 Best Practices

### 1. One Changeset Per Logical Change

Create separate changesets for different features:

```bash
# Good
bun run changeset  # For Starship feature
bun run changeset  # For autosuggestions feature

# Avoid
bun run changeset  # For both features combined
```

### 2. Clear, Descriptive Summaries

**Good:**
```
Add Starship prompt with git integration and execution time tracking
```

**Avoid:**
```
Update stuff
```

### 3. Link to Issues/PRs

Reference related issues in your changeset summary:

```
Fix zsh-autosuggestions not loading (fixes #42)
```

### 4. Group Related Changes

If making multiple related commits, create the changeset last:

```bash
git commit -m "feat: add starship config"
git commit -m "docs: update README for starship"
git commit -m "test: verify starship loads correctly"
bun run changeset  # One changeset for all related commits
```

## 📝 Changeset File Format

Changesets are stored in `.changeset/` as markdown files:

```markdown
---
"dotfiles": minor
---

Add Starship prompt integration

Replaced Oh-My-Posh with Starship for better performance and modern features.
- Fast, minimal prompt written in Rust
- Git integration with branch and status
- Execution time tracking
- Customizable via starship.toml
```

## 🔄 Workflow Examples

### Example 1: Adding a New Feature

```bash
# 1. Create your feature
git checkout -b feature/add-fzf
# ... make changes ...

# 2. Create changeset
bun run changeset
# Select: minor
# Summary: "Add fzf fuzzy finder integration"

# 3. Commit and push
git add .
git commit -m "feat: add fzf fuzzy finder integration"
git push origin feature/add-fzf

# 4. Create PR
# 5. Merge PR to master
# 6. GitHub Actions creates Release PR
# 7. Merge Release PR when ready
```

### Example 2: Fixing a Bug

```bash
# 1. Fix the bug
git checkout -b fix/autosuggestions-path
# ... fix bug ...

# 2. Create changeset
bun run changeset
# Select: patch
# Summary: "Fix zsh-autosuggestions not loading"

# 3. Commit and push
git add .
git commit -m "fix: correct zsh-autosuggestions path"
git push origin fix/autosuggestions-path

# 4. Create and merge PR
# 5. GitHub Actions handles the rest
```

### Example 3: Documentation Only (No Release)

For changes that don't require a release:

```bash
# Just commit without a changeset
git commit -m "docs: fix typo in README"
git push
```

## 🤖 GitHub Actions Details

The `.github/workflows/release.yml` workflow:

1. **Triggers** on push to `master`
2. **Checks** for changesets
3. **Creates** a Release PR if changesets exist
4. **Updates** the PR as new changesets are added
5. **Publishes** when the Release PR is merged
6. **Creates** git tags and GitHub releases

## 📚 Additional Resources

- [Changesets Documentation](https://github.com/changesets/changesets)
- [Semantic Versioning](https://semver.org/)
- [Conventional Commits](https://www.conventionalcommits.org/)

## ❓ FAQ

### Do I need a changeset for every PR?

No, only for changes that should be released:
- **Need changeset**: New features, bug fixes, breaking changes
- **No changeset**: Documentation, tests, CI/CD, refactoring (if internal only)

### Can I edit a changeset after creating it?

Yes! Changeset files are just markdown. Edit them in `.changeset/` before the Release PR is merged.

### How do I skip a release?

Don't create a changeset. The GitHub Action won't create a Release PR if there are no changesets.

### What if I make a mistake?

Before merging the Release PR:
- Edit or delete changeset files
- Force push to update the Release PR

After merging:
- Create a new changeset to fix the issue
- Release the fix

### Can I see what will be released?

Yes! The Release PR shows:
- New version number
- Updated CHANGELOG
- All changes included

---

**Questions?** Open an issue or check the [Changesets docs](https://github.com/changesets/changesets).
