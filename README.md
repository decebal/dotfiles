# 🚀 Modern Dotfiles

> A powerful, well-organized dotfiles repository for developers who love productivity

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Shell: Zsh](https://img.shields.io/badge/Shell-Zsh-green.svg)](https://www.zsh.org/)
[![Prompt: Starship](https://img.shields.io/badge/Prompt-Starship-blueviolet.svg)](https://starship.rs/)
[![Platform: macOS/Linux](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux-lightgrey.svg)]()

A modern, feature-rich dotfiles system with intelligent AI agent detection, beautiful Starship prompt, and comprehensive shell enhancements. Perfect for developers who want a productive terminal experience right out of the box.

---

## ✨ Features

### 🎨 **Beautiful Prompt**
- **[Starship](https://starship.rs/)** - Fast, customizable, minimal prompt
- Git integration with branch and status indicators
- Execution time tracking for long-running commands
- Clean, informative design

### 🤖 **AI Agent Optimized**
- Automatic detection of AI coding assistants (Cursor, GitHub Copilot, Windsurf, VS Code)
- Dual configuration system: minimal for AI agents, full-featured for interactive use
- GitHub Copilot CLI integration with helper functions
- Optimized command history and completion for AI context

### 🔧 **Developer Tools**
- **Smart Navigation**: `z` (zoxide), `fzf` for fuzzy finding, `atuin` for smart history
- **Syntax Highlighting**: Real-time command syntax highlighting
- **Auto-suggestions**: Fish-like autosuggestions as you type
- **Git Enhancements**: Better completions, aliases, and integrations
- **Package Managers**: Homebrew, npm, docker completions

### 📦 **Organized Structure**
```
.dotfiles/
├── common/          # Shared configurations
│   ├── aliases     # Shell aliases
│   ├── functions   # Utility functions
│   ├── paths       # PATH configuration
│   ├── zsh-normal-config   # Full interactive config
│   └── zsh-agent-config    # Minimal AI agent config
├── zsh/            # Zsh-specific files
├── bash/           # Bash configurations
├── vim/            # Vim configurations
├── git/            # Git configurations
└── local/          # Machine-specific (gitignored)
```

### 🎯 **Key Highlights**
- ⚡ **Fast startup** - Optimized loading with lazy evaluation
- 🔒 **Secure** - Machine-specific configs in gitignored `local/` directory
- 🧪 **Tested** - Health check script validates installation
- 📚 **Well documented** - Comprehensive guides and inline comments
- 🔄 **Easy updates** - Git submodules for plugin management
- 🌍 **Cross-platform** - Works on macOS and Linux

---

## 🎬 Quick Start

### Prerequisites
- **Git** (version 2.0+)
- **Zsh** (version 5.0+)
- **Homebrew** (macOS) or your system package manager
- **[Nerd Font](https://www.nerdfonts.com/)** - Required for Starship prompt icons. Install one via:
  ```bash
  brew install --cask font-fira-code-nerd-font   # or any other Nerd Font
  ```
  Then set it as your terminal's font.

### Installation

1. **Clone the repository**
   ```bash
   git clone --recursive https://github.com/decebal/dotfiles.git ~/.dotfiles
   ```

2. **Run the installer**
   ```bash
   cd ~/.dotfiles
   ./install.sh
   ```

3. **Restart your shell**
   ```bash
   exec zsh
   ```

### Non-Interactive Installation
For automated setups or CI/CD:
```bash
cd ~/.dotfiles
./non-interactive-install.sh
```

---

## 📖 Usage

### Essential Commands

**Reload Configuration**
```bash
source ~/.zshrc
```

**Health Check**
```bash
cd ~/.dotfiles
./health-check.sh
```

**Update All Plugins**
```bash
cd ~/.dotfiles
git submodule update --remote --merge
```

### Smart Navigation

**Jump to frequently used directories**
```bash
z project      # Jump to ~/Projects/my-project
z docs         # Jump to ~/Documents
```

**Fuzzy find files**
```bash
fzf            # Interactive file finder
Ctrl+R         # Search command history
Ctrl+T         # Find files
Alt+C          # Change directory
```

**Search history intelligently**
```bash
atuin search   # Smart history with context
```

### Git Enhancements

The dotfiles include helpful Git aliases and functions:
```bash
git status     # Enhanced with better formatting
git log        # Beautiful, readable log format
```

### AI Agent Features

When running in AI coding assistants (automatically detected):
```bash
ai-status           # Check AI agent detection status
copilot-status      # GitHub Copilot CLI status
ask-copilot <query> # Ask GitHub Copilot for help
explain-cmd <cmd>   # Explain a command
```

---

## 🎨 Customization

### Starship Prompt

Customize your prompt by creating `~/.config/starship.toml`:
```toml
# Example: minimal prompt
format = "$directory$git_branch$character"

[directory]
truncation_length = 3
truncate_to_repo = true

[git_branch]
symbol = " "
```

Explore presets at [starship.rs/presets](https://starship.rs/presets/)

### Adding Aliases

Edit `~/.dotfiles/common/aliases`:
```bash
# Add your custom aliases
alias myalias="my command"
```

### Adding Functions

Edit `~/.dotfiles/common/functions`:
```bash
# Add your custom functions
myfunction() {
    echo "My custom function"
}
```

### Machine-Specific Config

Create configs in `~/.dotfiles/local/` (gitignored for security):
```bash
# ~/.dotfiles/local/machine-specific.sh
export MY_SECRET_KEY="..."
alias work-vpn="..."
```

---

## 🔌 Included Plugins & Tools

### Core
- **[Starship](https://starship.rs/)** - Minimal, fast, customizable prompt
- **[zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)** - Fish-like suggestions
- **[zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)** - Real-time highlighting

### Navigation
- **[zoxide](https://github.com/ajeetdsouza/zoxide)** - Smart directory jumping
- **[fzf](https://github.com/junegunn/fzf)** - Fuzzy finder
- **[atuin](https://github.com/atuinsh/atuin)** - Magical shell history

### Development
- Git completions and aliases
- Docker completions
- npm/yarn completions
- Homebrew completions

See [COOL-PLUGINS.md](./COOL-PLUGINS.md) for detailed plugin documentation.

---

## 🧪 Testing & Validation

### Run Health Check
```bash
cd ~/.dotfiles
./health-check.sh
```

The health check validates:
- ✅ Zsh installation and version
- ✅ Required tools (git, curl, etc.)
- ✅ Configuration file integrity
- ✅ Plugin installation
- ✅ Symlink correctness

### Test Configuration
```bash
# Test in a clean shell
zsh -c "source ~/.zshrc && echo 'Config loaded successfully'"

# Profile startup time
time zsh -i -c exit
```

---

## 🤝 Contributing

Contributions are welcome! Whether it's:
- 🐛 Bug fixes
- ✨ New features
- 📝 Documentation improvements
- 💡 Suggestions

Please see [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines.

### Quick Contribution Guide

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📚 Documentation

- **[CLAUDE.md](./CLAUDE.md)** - Guide for Claude AI when working with this repo
- **[COOL-PLUGINS.md](./COOL-PLUGINS.md)** - Detailed plugin documentation
- **[SHELL-OPTIMIZATION.md](./SHELL-OPTIMIZATION.md)** - Performance optimization guide
- **[RELEASES.md](./RELEASES.md)** - Release management and versioning guide
- **[CHANGELOG.md](./CHANGELOG.md)** - Version history and changes
- **[TODO.md](./TODO.md)** - Roadmap and future improvements

## 🏷️ Releases & Versioning

This project uses [Changesets](https://github.com/changesets/changesets) for automated version management.

**Latest Release:** [v1.0.0](https://github.com/decebal/dotfiles/releases/latest)

**Creating a release:**
```bash
# 1. Make your changes
# 2. Create a changeset
bun run changeset

# 3. Commit and push
git add . && git commit -m "feat: your feature"
git push

# 4. GitHub Actions will create a Release PR automatically
# 5. Merge the Release PR to publish
```

See [RELEASES.md](./RELEASES.md) for detailed release process documentation.

---

## 🛠️ Troubleshooting

### Shell errors after installation
```bash
# Run health check
./health-check.sh

# Bypass directory warnings
ZSH_DISABLE_COMPFIX=true zsh
```

### Plugin not working
```bash
# Update submodules
git submodule update --init --recursive

# Force reinstall
cd ~/.dotfiles
./install.sh
```

### AI agent mode not detected
```bash
# Check environment variables
echo $AI_AGENT_CONTEXT
echo $WINDSURF_PID
echo $CURSOR_AGENT

# Check status
ai-status
```

### Starship not loading
```bash
# Verify installation
starship --version

# Reinstall
brew install starship
source ~/.zshrc
```

---

## 🌟 Inspiration & Credits

This dotfiles system stands on the shoulders of giants:

- [Dotfiles Guide](http://dotfiles.github.io/) - Community best practices
- [Starship](https://starship.rs/) - The minimal, blazing-fast prompt
- [Zsh](https://www.zsh.org/) - The powerful shell
- [Awesome Zsh Plugins](https://github.com/unixorn/awesome-zsh-plugins) - Plugin inspiration

Special thanks to all contributors and the open source community!

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

---

## 💬 Get in Touch

- **Issues**: [GitHub Issues](https://github.com/decebal/dotfiles/issues)
- **Discussions**: [GitHub Discussions](https://github.com/decebal/dotfiles/discussions)
- **LinkedIn**: Share your setup and tag me!
- **X/Twitter**: Tweet about your experience with #dotfiles

---

## ⭐ Show Your Support

If you find this helpful, please:
- ⭐ **Star this repository**
- 🐦 **Share on social media**
- 🍴 **Fork and customize** for your needs
- 🤝 **Contribute** improvements back

---

<p align="center">
  <i>Happy coding! 🚀</i>
</p>
