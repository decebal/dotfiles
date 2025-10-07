# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

This document provides context for Claude AI when working with this dotfiles repository.

## Quick Start Commands

- **Install dotfiles**: `./install.sh` (interactive with prompts)
- **Non-interactive install**: `./non-interactive-install.sh` (simple symlink setup)
- **Health check**: `./health-check.sh` (validate installation and report issues)
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

### Adding a new Zsh plugin
1. Add as git submodule in `zsh/plugins/`
   ```bash
   git submodule add <plugin-url> zsh/plugins/<plugin-name>
   ```
2. Source the plugin in `common/zsh-normal-config` or `common/zsh-agent-config`
   ```bash
   if [ -f $DOTFILES/zsh/plugins/<plugin-name>/<plugin-name>.zsh ]; then
       source $DOTFILES/zsh/plugins/<plugin-name>/<plugin-name>.zsh
   fi
   ```

### Adding machine-specific configuration
1. Create file in `local/` directory (e.g., `local/machine-specific.sh`)
2. Add logic to `local/master-config.sh` to source your new file
3. The `local/` directory is gitignored for security

## AI Agent Mode

The shell configuration automatically detects AI agent environments and loads a minimal configuration for better compatibility. This happens when any of these environment variables are set:
- `CURSOR_AGENT`
- `GITHUB_COPILOT_AGENT`
- `AI_AGENT`
- `WINDSURF_PID` (Windsurf IDE)
- `VSCODE_PID` (VS Code/Windsurf)

In agent mode:
- Simple prompt is used (no Starship or complex prompts)
- Minimal plugin set (git, gitfast, ssh-agent, last-working-dir, z)
- Auto-updates are disabled
- Complex themes are skipped
- Optimized for fast shell loading and AI interactions

### Windsurf-Specific Features

When running in Windsurf, additional optimizations are applied:
- Fast command completion for AI interactions
- Optimized history settings for better AI context
- Windsurf CLI path integration (if available)
- Helper functions: `windsurf-here` and `windsurf-check`

## Architecture Overview

This dotfiles system uses a **dual-configuration architecture** that automatically adapts between normal interactive mode and AI agent mode:

### Configuration Loading Order
1. **Environment Detection**: Checks for AI agent environment variables
2. **Master Config**: Loads `local/master-config.sh` for machine-specific setup
3. **Path Setup**: Sources `common/paths` for PATH configurations
4. **Mode Selection**: Loads either `common/zsh-agent-config` or `common/zsh-normal-config`
5. **Common Components**: Sources aliases, functions, and integrations
6. **AI Optimizations**: Applies GitHub Copilot and other AI tool integrations

### Key Components
- **Entry Point**: `zsh/zshrc` - main configuration with intelligent mode detection
- **AI Integration**: `common/copilot-integration.zsh` - GitHub Copilot CLI features
- **Performance**: `common/shell-performance.sh` - shell optimization settings
- **Health Validation**: `health-check.sh` - comprehensive system validation

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
│   ├── plugins/       # Zsh plugins (submodules)
│   ├── zsh-completions/  # Additional completions
│   └── k/             # k directory listing
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

To test Windsurf mode:
```bash
WINDSURF_PID=12345 zsh
```

To check which mode is active:
```bash
echo $AI_AGENT_CONTEXT
echo $WINDSURF_CONTEXT
```

To check Windsurf optimization status:
```bash
windsurf-check
```

## Important Development Notes

1. **GVM Removed**: Go Version Manager has been completely removed due to compatibility issues. Use system Go or other version managers if needed.
2. **Machine-specific configurations**: Must go in `local/` directory (gitignored for security)
3. **Test changes**: Always test in both normal and agent modes before committing
4. **PATH preservation**: Many tools depend on specific PATH entries - handle with care
5. **Agent detection**: Automatic based on environment variables, no manual setup needed

## Version Control

When making changes:
1. Test in a new shell session first
2. Verify both normal and agent modes work
3. Commit with descriptive message
4. Don't commit `local/` directory contents

## Troubleshooting

- **Shell errors after changes**: Run `./health-check.sh` to validate configuration
- **Agent mode not detected**: Check environment variables listed in AI Agent Mode section
- **Permission issues**: Run `ZSH_DISABLE_COMPFIX=true zsh` to bypass directory warnings