# Claude AI Assistant Context

This document provides context for Claude AI when working with this dotfiles repository.

## Quick Start Commands

- **Install dotfiles**: `./install.sh`
- **Non-interactive install**: `./non-interactive-install.sh`
- **Test shell config**: `zsh -c "source ~/.zshrc && echo 'Config loaded successfully'"`

## Common Tasks

### Adding a new shell alias
1. Edit `common/aliases`
2. Reload shell: `source ~/.zshrc`

### Adding a new shell function
1. Edit `common/functions`
2. Reload shell: `source ~/.zshrc`

### Adding a new PATH entry
1. Edit `common/paths`
2. Reload shell: `source ~/.zshrc`

### Installing a new Oh-My-Zsh plugin
1. Add plugin name to the plugins array in `common/zsh-normal-config`
2. If it's a third-party plugin, add as git submodule in `zsh/oh-my-zsh/plugins/`

## AI Agent Mode

The shell configuration automatically detects AI agent environments and loads a minimal configuration for better compatibility. This happens when any of these environment variables are set:
- `CURSOR_AGENT`
- `GITHUB_COPILOT_AGENT`
- `AI_AGENT`

In agent mode:
- Simple prompt is used (no powerline/oh-my-posh)
- Minimal plugin set (only git, gitfast, ssh-agent)
- Auto-updates are disabled
- Complex themes are skipped

## File Structure Overview

```
.dotfiles/
├── common/              # Shared configurations
│   ├── aliases         # Shell aliases
│   ├── functions       # Shell functions
│   ├── paths          # PATH configurations
│   ├── zsh-agent-config    # Minimal config for AI agents
│   ├── zsh-normal-config   # Full config for interactive use
│   └── zsh-config     # Legacy config (fallback)
├── zsh/                # Zsh-specific files
│   ├── zshrc          # Main zsh configuration
│   └── oh-my-zsh/     # Oh-My-Zsh framework
├── bash/              # Bash configurations
├── vim/               # Vim configurations
├── git/               # Git configurations
└── local/             # Machine-specific configs (not in git)
```

## Important Notes

1. **Machine-specific configurations** should go in `local/` directory
2. **Test changes** in both normal and agent modes before committing
3. **Preserve PATH** - Many tools depend on specific PATH entries
4. **Check file existence** before sourcing to avoid errors
5. **Agent detection** is automatic based on environment variables

## Debugging

To test agent mode manually:
```bash
CURSOR_AGENT=1 zsh
```

To check which mode is active:
```bash
echo $AI_AGENT_CONTEXT
```

## Version Control

When making changes:
1. Test in a new shell session first
2. Verify both normal and agent modes work
3. Commit with descriptive message
4. Don't commit `local/` directory contents