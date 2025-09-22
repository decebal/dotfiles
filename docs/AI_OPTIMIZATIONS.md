# AI Tool Optimizations

Your dotfiles are now optimized for AI development tools including GitHub Copilot, VS Code, Windsurf, and other AI assistants.

## 🤖 Features

### Automatic AI Detection
The shell automatically detects when running in AI-enabled environments:
- VS Code terminal (`TERM_PROGRAM=vscode`)
- GitHub Copilot contexts
- Windsurf AI editor
- Cursor and other AI editors

### Optimized Configuration
When AI context is detected, the shell:
- Switches to minimal, fast-loading configuration
- Uses simple prompts for better AI parsing
- Optimizes command completion for AI tools
- Sets consistent terminal dimensions for AI readability

### GitHub Copilot CLI Integration
- Install via: `./install.sh` → Option 4 or 5
- Convenient aliases:
  - `gcs 'description'` - Get command suggestions
  - `gce 'command'` - Explain commands
  - `fix-last` - Fix the last failed command
  - `explain-last` - Explain the last command

### Context Functions
Provide rich context to AI tools:
- `ai-context` or `ctx` - Full AI context summary
- `project-context` or `pctx` - Project type and git status
- `env-context` or `ectx` - Environment information
- `git-context` or `gc` - Git repository status
- `recent-commands` or `rh` - Recent command history

### Status Commands
- `ai-status` - Check AI integration status
- `copilot-status` - GitHub Copilot specific status

## 🔧 Configuration Files

### Main Configuration
- `common/zsh-agent-config` - AI-optimized shell configuration
- `common/copilot-integration.zsh` - GitHub Copilot specific features
- `common/shell-performance.sh` - Performance optimizations

### AI Detection Variables
The system sets these environment variables in AI contexts:
- `AI_AGENT_CONTEXT=1` - General AI context detected
- `VSCODE_CONTEXT=1` - VS Code terminal detected
- `WINDSURF_CONTEXT=1` - Windsurf editor detected
- `GITHUB_COPILOT_TERMINAL=1` - Copilot-optimized terminal

## 🚀 Usage Examples

### Getting Command Suggestions
```bash
# Using GitHub Copilot CLI
gcs "find all JavaScript files modified in the last 7 days"
gcs "compress a directory with tar and gzip"

# Or use the full command
gh copilot suggest "your description here"
```

### Explaining Commands
```bash
# Explain a complex command
gce "find . -name '*.js' -mtime -7 -exec ls -la {} \;"

# Explain the last command you ran
explain-last
```

### Getting Context for AI
```bash
# Full context for AI assistance
ctx

# Just project information
pctx

# Recent commands for context
rh 10
```

### Fixing Failed Commands
```bash
# Some command that fails...
$ complicated-command-that-fails

# Get AI suggestion to fix it
$ fix-last
```

## 🎯 Performance Benefits

### Normal vs AI Mode
- **Normal Mode**: Full features, themes, plugins
- **AI Mode**: Minimal configuration, faster startup, cleaner output

### Optimizations Applied in AI Mode
- Simplified prompt for better parsing
- Reduced plugin set (git, gitfast, ssh-agent, z)
- Faster command completion
- Consistent terminal dimensions
- Optimized history settings

## 🛠️ Customization

### Disable AI Optimizations
```bash
export DISABLE_AI_OPTIMIZATIONS=1
```

### Force AI Mode
```bash
export AI_AGENT_CONTEXT=1
```

### Customize AI Detection
Edit the detection logic in `zsh/zshrc` around line 23:
```bash
if [[ -n "$CURSOR_AGENT" ]] || [[ -n "$GITHUB_COPILOT_AGENT" ]] || [[ -n "$AI_AGENT" ]] || [[ -n "$WINDSURF_PID" ]] || [[ -n "$VSCODE_PID" ]]; then
    # Your custom AI detection logic
fi
```

## 📝 Integration with VS Code

### Terminal Integration
Your configuration automatically detects VS Code terminal and:
- Enables shell integration features
- Optimizes for GitHub Copilot terminal usage
- Sets consistent formatting for AI parsing

### Recommended VS Code Extensions
- GitHub Copilot
- GitHub Copilot Chat
- Terminal extensions that support shell integration

## 🔍 Troubleshooting

### Check AI Detection
```bash
ai-status  # Shows all AI-related environment variables and tool availability
```

### GitHub Copilot Issues
```bash
copilot-status  # Shows Copilot-specific status
gh auth status  # Check GitHub authentication
gh extension list  # List installed extensions
```

### Performance Issues
```bash
# Profile shell startup time
PROFILE_SHELL=1 zsh -i -c exit
```

### Reset to Normal Mode
```bash
unset AI_AGENT_CONTEXT VSCODE_CONTEXT WINDSURF_CONTEXT
source ~/.zshrc
```