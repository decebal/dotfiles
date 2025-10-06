# Maintainers Guide

Quick reference for repository maintainers.

## 🚀 Release Process

### Automated Releases (Recommended)

1. **Contributors create changesets**
   ```bash
   bun run changeset
   ```

2. **GitHub Actions creates Release PR**
   - Triggered on push to `master`
   - Automatically aggregates all changesets
   - Updates version and CHANGELOG

3. **Review Release PR**
   - Check version bump is correct
   - Review CHANGELOG entries
   - Verify all changesets are included

4. **Merge Release PR**
   - Creates git tag
   - Publishes GitHub release
   - Updates CHANGELOG

### Manual Release (Emergency)

```bash
# 1. Version packages
bun run version

# 2. Review changes
git diff

# 3. Commit
git add .
git commit -m "chore: version packages"

# 4. Tag
VERSION=$(node -p "require('./package.json').version")
git tag -a "v$VERSION" -m "Release v$VERSION"

# 5. Push
git push && git push --tags

# 6. Create GitHub release manually
```

## 📝 Common Tasks

### Reviewing PRs

**Checklist:**
- [ ] Code follows style guidelines
- [ ] Tests pass (both normal and AI agent modes)
- [ ] Documentation updated
- [ ] Changeset included (if needed)
- [ ] Health check passes
- [ ] No security issues

### Merging PRs

```bash
# Use GitHub's "Squash and merge" for feature PRs
# Use "Rebase and merge" for Release PRs
```

### Managing Issues

**Labels:**
- `bug` - Something isn't working
- `enhancement` - New feature request
- `documentation` - Documentation improvements
- `good first issue` - Good for newcomers
- `help wanted` - Extra attention needed
- `question` - Further information requested
- `wontfix` - Will not be worked on

### Triaging Issues

1. **Verify** - Can you reproduce?
2. **Label** - Apply appropriate labels
3. **Respond** - Ask for more info if needed
4. **Prioritize** - Set milestone if critical

## 🔒 Security

### Reporting Security Issues

**DO NOT** create public issues for security vulnerabilities.

Instead:
1. Email maintainers directly
2. Use GitHub Security Advisories
3. Wait for fix before disclosure

### Security Checklist

- [ ] No secrets in codebase
- [ ] `.gitignore` properly configured
- [ ] Dependencies up to date
- [ ] No known vulnerabilities

## 📊 Metrics & Health

### Repository Health

```bash
# Check for outdated dependencies
bun outdated

# Run health check
./health-check.sh

# Test startup time
time zsh -i -c exit
```

### Community Health

Monitor:
- Issue response time
- PR review time
- Contributor activity
- Star growth

## 🎯 Priorities

### High Priority
1. Security vulnerabilities
2. Breaking bugs
3. Documentation gaps
4. Community engagement

### Medium Priority
1. Feature requests
2. Performance improvements
3. Code quality
4. Testing

### Low Priority
1. Nice-to-have features
2. Minor optimizations
3. Cosmetic changes

## 🤝 Community Guidelines

### Responding to Issues

**Be:**
- Friendly and welcoming
- Patient and helpful
- Clear and concise
- Appreciative of contributions

**Templates:**

**Bug Report Response:**
```markdown
Thanks for reporting this!

To help us fix this:
1. Can you run `./health-check.sh` and share the output?
2. What's your OS and Zsh version?
3. Does this happen in both normal and AI agent modes?
```

**Feature Request Response:**
```markdown
Thanks for the suggestion! This sounds interesting.

Questions:
1. How would you use this feature?
2. Can you provide an example?
3. Are you interested in contributing this?
```

## 📅 Release Schedule

### Versioning Strategy

- **Patch** (1.0.x): Bug fixes, small improvements - as needed
- **Minor** (1.x.0): New features - monthly
- **Major** (x.0.0): Breaking changes - quarterly

### Release Cadence

- Patch releases: As needed for critical fixes
- Minor releases: Every 2-4 weeks
- Major releases: When necessary for breaking changes

## 🔄 Maintenance Tasks

### Weekly
- [ ] Review open PRs
- [ ] Triage new issues
- [ ] Respond to community questions

### Monthly
- [ ] Update dependencies
- [ ] Review and update documentation
- [ ] Check for security advisories
- [ ] Plan next release

### Quarterly
- [ ] Review project goals
- [ ] Update roadmap
- [ ] Community survey
- [ ] Major version planning

## 🛠️ Tools

### Useful Commands

```bash
# List all changesets
ls -la .changeset/

# View changeset content
cat .changeset/*.md

# Check git tags
git tag -l

# View release history
gh release list

# Check workflow runs
gh run list --workflow=release.yml
```

### GitHub CLI

```bash
# View PR status
gh pr status

# Review PR
gh pr review <number> --approve

# Create release
gh release create v1.0.0 --title "v1.0.0" --notes "Release notes"
```

## 📚 Resources

- [Changesets Documentation](https://github.com/changesets/changesets)
- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Semantic Versioning](https://semver.org/)
- [Keep a Changelog](https://keepachangelog.com/)

## 🆘 Troubleshooting

### Release PR Not Created

**Check:**
1. Are there changesets in `.changeset/`?
2. Did the workflow run? Check Actions tab
3. Check workflow logs for errors

**Fix:**
```bash
# Manually trigger workflow
gh workflow run release.yml
```

### Failed Release

**Common causes:**
1. Merge conflicts in CHANGELOG
2. Version already exists
3. Permission issues

**Recovery:**
```bash
# Revert the release commit
git revert HEAD

# Fix issues
# Try again
```

### Broken Main Branch

**Emergency procedure:**
1. Create hotfix branch
2. Fix issue
3. Create changeset (patch)
4. Fast-track PR review
5. Merge and release

---

**Questions?** Reach out to other maintainers or open a discussion.
