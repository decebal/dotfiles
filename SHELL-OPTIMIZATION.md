# Shell Optimization Guide

This document explains the shell optimizations implemented in this dotfiles repository.

## Prompt Configuration

### Modern Prompt with Starship
The dotfiles now use **Starship** as the default prompt:

- **Fast**: Written in Rust, minimal overhead
- **Cross-shell**: Works with Zsh, Bash, Fish, etc.
- **Customizable**: Configure via `~/.config/starship.toml`
- **Modern**: Git integration, execution time, status codes

### AI Agent Mode
In AI agent mode (Cursor, Copilot, Windsurf):
- Starship is disabled for compatibility
- Simple prompt is used: `%n@%m:%~$ `
- Optimized for fast loading and AI parsing

### Control Variables
- `AI_AGENT_CONTEXT=1` - Minimal prompt for AI agents (disables Starship)

## Plugin Optimization

### Previous Issues
- **Missing plugins**: 5 configured plugins didn't exist (custom-aliases, colored-man-pages, direnv, hook, rust)
- **Unconditional loading**: All plugins loaded regardless of whether tools were installed
- **Performance impact**: Unnecessary plugins slowing down shell startup

### Optimized Plugin Loading

#### Core Plugins (Always Loaded)
- `git` - Essential git aliases and functions
- `ssh-agent` - SSH key management
- `history` - Better history management
- `history-substring-search` - Search with arrow keys

#### Performance Plugins
- `gitfast` - Faster git completions (replaces standard git completions)
- `zsh-syntax-highlighting` - Syntax highlighting (loaded early for better performance)
- `zsh-autosuggestions` - Fish-like autosuggestions

#### Conditional Plugins
Plugins now load only when their associated tools are installed:
```bash
command -v python3 &>/dev/null && plugins+=(pip python)
command -v go &>/dev/null && plugins+=(golang)
command -v rvm &>/dev/null && plugins+=(rvm)
```

## Performance Improvements

### 1. Lazy Loading
**NVM** and **PyEnv** are now lazy-loaded, significantly improving startup time:
- Functions are created as proxies
- Actual initialization happens on first use
- Saves 200-500ms on shell startup

### 2. Compilation
Zsh scripts are automatically compiled to bytecode:
- `.zwc` files created for faster loading
- Automatic recompilation when source files change

### 3. Completion Optimization
- Security checks run once per day instead of every startup
- Completion dump cached and reused

### 4. History Optimization
- Duplicate detection disabled during search
- Blanks automatically reduced
- Extended history with timestamps

## Shell Startup Time Testing

### Check current startup time:
```bash
# Zsh
time zsh -i -c exit

# With profiling
PROFILE_SHELL=1 zsh -i -c exit
zprof  # View results
```

### Expected startup times:
- **With all optimizations**: 150-300ms
- **Without lazy loading**: 500-800ms
- **With all plugins**: 800-1200ms

## Troubleshooting

### Starship not working
```bash
# Check if starship is installed
command -v starship

# Test starship directly
starship init zsh

# Install starship if needed
brew install starship

# Test configuration
starship config
```

### Plugins not loading
```bash
# Check which plugins are active
echo $plugins

# Verify plugin directory exists
ls $ZSH/plugins/

# Force reload
source ~/.zshrc
```

### Slow shell startup
```bash
# Run health check
./health-check.sh

# Profile startup
PROFILE_SHELL=1 zsh -i -c exit

# Disable all plugins temporarily
export plugins=()
source ~/.zshrc
```

### Math expression errors on macOS
If you see `preexec:1: bad math expression: operator expected at 'N/1000000'`:
```bash
# This is fixed in the latest version, but you can disable timing if needed
export DISABLE_EXEC_TIME=1
source ~/.zshrc
```

## Best Practices

### For New Plugins
1. Check if the plugin exists: `ls $ZSH/plugins/`
2. Add conditionally if it depends on external tools
3. Consider performance impact
4. Document in this file

### For Themes
1. Use Starship for modern, fast prompts
2. Simple prompt in AI agent mode for compatibility
3. Always test in both modes

### For Performance
1. Lazy-load heavy tools (nvm, pyenv, etc.)
2. Use conditional plugin loading
3. Compile frequently-used scripts
4. Monitor startup time regularly

## Configuration Files

- `common/shell-performance.sh` - Performance optimizations
- `common/zsh-normal-config` - Full-featured configuration
- `common/zsh-agent-config` - Minimal AI agent configuration
- `zsh/zshrc` - Main entry point with conflict resolution

## Quick Commands

```bash
# Test without Starship (AI agent mode)
AI_AGENT_CONTEXT=1 zsh

# Normal mode (with Starship)
zsh

# Enable fun plugins
export ENABLE_FUN_PLUGINS=true && source ~/.zshrc

# Profile shell startup
PROFILE_SHELL=1 zsh -i -c 'zprof'
```