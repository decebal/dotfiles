# Contributing to Modern Dotfiles

First off, thank you for considering contributing to this project! 🎉

This document provides guidelines for contributing to this dotfiles repository. Following these guidelines helps maintain quality and makes the contribution process smooth for everyone.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Pull Request Process](#pull-request-process)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Documentation](#documentation)

## 🤝 Code of Conduct

This project follows a simple code of conduct:

- **Be respectful**: Treat everyone with respect and kindness
- **Be constructive**: Provide helpful feedback and suggestions
- **Be collaborative**: Work together to improve the project
- **Be inclusive**: Welcome contributors of all skill levels

## 🌟 How Can I Contribute?

### Reporting Bugs

Before creating a bug report:
1. **Check existing issues** to avoid duplicates
2. **Test with the latest version** to ensure the bug still exists
3. **Run the health check** (`./health-check.sh`) to gather diagnostic info

When creating a bug report, include:
- **Clear title** describing the issue
- **Steps to reproduce** the problem
- **Expected vs actual behavior**
- **System information** (OS, Zsh version, terminal)
- **Health check output** if relevant

**Use the bug report template** when creating an issue.

### Suggesting Enhancements

Enhancement suggestions are welcome! When suggesting:
- **Use a clear title** describing the enhancement
- **Explain the use case** - why would this be useful?
- **Provide examples** of how it would work
- **Consider alternatives** you've thought about

**Use the feature request template** when creating an issue.

### Contributing Code

Great! Here's how to contribute code:

#### 1. Types of Contributions

**Easy First Contributions:**
- Adding useful aliases to `common/aliases`
- Adding utility functions to `common/functions`
- Improving documentation
- Fixing typos or broken links
- Adding examples to existing docs

**Medium Contributions:**
- Adding new plugins as git submodules
- Improving installation scripts
- Enhancing the health check
- Adding new shell configurations

**Advanced Contributions:**
- Improving AI agent detection
- Optimizing shell startup time
- Refactoring core configuration logic
- Adding support for new shells or platforms

#### 2. Getting Started

```bash
# Fork the repository on GitHub

# Clone your fork
git clone --recursive https://github.com/YOUR-USERNAME/dotfiles.git ~/.dotfiles-dev

# Add upstream remote
cd ~/.dotfiles-dev
git remote add upstream https://github.com/decebal/dotfiles.git

# Create a feature branch
git checkout -b feature/my-awesome-feature
```

## 🛠️ Development Setup

### Prerequisites

- Git 2.0+
- Zsh 5.0+
- A test environment (don't test on your production dotfiles!)

### Testing Your Changes

**Important**: Always test in both modes:

1. **Normal interactive mode**
   ```bash
   zsh -c "source ~/.dotfiles-dev/zsh/zshrc && echo 'Success'"
   ```

2. **AI agent mode**
   ```bash
   AI_AGENT=1 zsh -c "source ~/.dotfiles-dev/zsh/zshrc && echo 'Success'"
   ```

3. **Run health check**
   ```bash
   cd ~/.dotfiles-dev
   ./health-check.sh
   ```

### File Organization

When adding new features:

- **Aliases**: Add to `common/aliases`
- **Functions**: Add to `common/functions`
- **Paths**: Add to `common/paths`
- **Plugins**: Add as git submodules in `zsh/plugins/`
- **Zsh config**: Edit `common/zsh-normal-config` or `common/zsh-agent-config`
- **Documentation**: Update relevant `.md` files

## 🔄 Pull Request Process

### Before Submitting

1. **Test thoroughly** in both normal and agent modes
2. **Run health check** and ensure it passes
3. **Update documentation** if you've changed functionality
4. **Follow coding standards** (see below)
5. **Write clear commit messages**

### Commit Message Format

```
type: brief description (50 chars or less)

More detailed explanation if needed. Wrap at 72 characters.

- Bullet points for multiple changes
- Explain what and why, not how
- Reference issues with #issue-number
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Formatting, no code change
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**
```
feat: add Starship prompt integration

Replaced Oh-My-Posh with Starship for better performance and
modern features. Configured in zsh/zshrc with automatic detection.

Closes #42
```

```
fix: correct zsh-autosuggestions path in normal config

The plugin was looking in the wrong directory. Updated path
to zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

Fixes #17
```

### Pull Request Template

When creating a PR, include:

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Code refactoring

## Testing
- [ ] Tested in normal mode
- [ ] Tested in AI agent mode
- [ ] Health check passes
- [ ] Documentation updated

## Screenshots/Output
If applicable, add screenshots or terminal output

## Related Issues
Closes #(issue number)
```

### Review Process

1. **Automated checks** will run on your PR
2. **Maintainer review** - we'll review your code and provide feedback
3. **Address feedback** if requested
4. **Merge** - once approved, your PR will be merged!

## 📝 Coding Standards

### Shell Scripts

```bash
#!/bin/zsh
# File description

# Use descriptive variable names
local user_input="$1"
local config_file="$HOME/.zshrc"

# Add comments for complex logic
# This function checks if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Use proper error handling
if [[ ! -f "$config_file" ]]; then
    echo "Error: Config file not found" >&2
    return 1
fi

# Quote variables to prevent word splitting
if [[ -n "$user_input" ]]; then
    process_input "$user_input"
fi
```

### Key Principles

1. **POSIX compliance** where possible
2. **Quote variables** to prevent issues
3. **Check before using** - verify files/commands exist
4. **Descriptive names** - no single-letter variables (except loops)
5. **Comments** - explain why, not what
6. **Error handling** - fail gracefully with helpful messages

### Plugin Integration

When adding plugins:

```bash
# Check if plugin exists before sourcing
if [ -f $DOTFILES/zsh/plugins/plugin-name/plugin.zsh ]; then
    source $DOTFILES/zsh/plugins/plugin-name/plugin.zsh
fi
```

### AI Agent Compatibility

Ensure changes work in both modes:

```bash
# Feature only for interactive mode
if [[ -z "$AI_AGENT_CONTEXT" ]]; then
    # Interactive-only feature
    fancy_prompt_setup
fi

# Feature for both modes
useful_function() {
    # Works everywhere
}
```

## 🧪 Testing

### Manual Testing Checklist

- [ ] Source the config in a new shell
- [ ] Test in normal interactive mode
- [ ] Test in AI agent mode (`AI_AGENT=1 zsh`)
- [ ] Run `./health-check.sh`
- [ ] Check startup time (`time zsh -i -c exit`)
- [ ] Test on macOS (if available)
- [ ] Test on Linux (if available)

### Automated Testing

We're working on automated tests. Contributions to testing infrastructure are welcome!

## 📚 Documentation

Good documentation is crucial! When making changes:

### Update README.md if:
- Adding a new major feature
- Changing installation process
- Modifying core functionality

### Update CLAUDE.md if:
- Changing architecture
- Adding new configuration files
- Modifying AI agent detection

### Update COOL-PLUGINS.md if:
- Adding a new plugin
- Changing plugin configuration

### Inline Comments
- Explain complex logic
- Document functions and their parameters
- Note any quirks or platform-specific code

## 🎯 Priority Areas

We'd especially love contributions in these areas:

1. **Platform support**: Better Linux support, BSD support
2. **Testing**: Automated tests, CI/CD
3. **Performance**: Faster startup, lazy loading
4. **Plugins**: Well-tested, useful plugins
5. **Documentation**: Examples, tutorials, videos
6. **AI integration**: Better AI agent detection and optimization

## 🆘 Getting Help

Need help contributing?

- **Open a discussion** on GitHub Discussions
- **Join the community** - check README for links
- **Ask questions** in issues or PRs
- **Review existing code** for examples

## 🏆 Recognition

Contributors will be:
- Listed in the project (coming soon: CONTRIBUTORS.md)
- Thanked in release notes
- Appreciated by the community!

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing! 🚀

**Questions?** Open an issue or discussion - we're here to help!
