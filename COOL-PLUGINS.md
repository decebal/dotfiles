# Shell Plugins & Tools Guide

Your dotfiles include amazing productivity tools! Here's what each one does and how to use them.

## 🎨 Prompt

### Starship - Fast, Customizable Prompt
The modern, blazing-fast prompt written in Rust.

**Features:**
- Git branch and status
- Execution time tracking
- Exit code indicators
- Language version indicators (Node, Python, Go, etc.)

**Configuration:**
```bash
# Create custom config
mkdir -p ~/.config
starship preset <preset-name> > ~/.config/starship.toml

# Available presets:
starship preset --list
```

**Customize:**
Edit `~/.config/starship.toml` - see [starship.rs](https://starship.rs/config/)

---

## 🚀 Navigation & Directory Management

### `zoxide` (z) - Smart Directory Jumping
Jump to frequently used directories with just a few letters!

```bash
# Visit directories normally:
cd ~/Documents/Projects/awesome-project
cd ~/Downloads
cd ~/Desktop

# Later, jump instantly:
z awesome    # Goes to ~/Documents/Projects/awesome-project
z down       # Goes to ~/Downloads
z desk       # Goes to ~/Desktop

# Interactive selection:
zi <query>   # Opens interactive picker

# See all tracked directories:
zoxide query -l
```

**How it works:**
- Learns your most-used directories
- Ranks by "frecency" (frequency + recency)
- Fuzzy matching for typos

---

## 🔍 Search & History

### `fzf` - Fuzzy Finder
Powerful fuzzy finder for files, command history, and more.

**Key Bindings:**
- `Ctrl+R` - Search command history
- `Ctrl+T` - Find files in current directory
- `Alt+C` - Change to a directory

**Examples:**
```bash
# Use fzf directly
fzf  # Interactive file picker

# Pipe to fzf
cat file.txt | fzf

# Use in commands
vim $(fzf)  # Open selected file in vim
cd $(find . -type d | fzf)  # cd to selected directory
```

**Custom searches:**
```bash
# Search with preview
fzf --preview 'cat {}'

# Multi-select
fzf -m
```

### `atuin` - Magical Shell History
Supercharged history search with context and sync.

```bash
# Search history (replaces Ctrl+R)
<type some command and press Ctrl+R>

# Search specific command
atuin search docker

# Search with time filter
atuin search --before "1 week ago" git

# View statistics
atuin stats

# Import history
atuin import auto
```

**Features:**
- Contextual history (knows what directory you were in)
- Full-text search
- Optional cloud sync
- Statistics tracking

---

## 💡 Auto-Suggestions

### `zsh-autosuggestions` - Fish-like Suggestions
Real-time suggestions from your command history.

**Usage:**
```bash
# Start typing:
git sta█
       ↳ git status  # Gray suggestion appears

# Press → (right arrow) to accept
# Press → then Tab to accept one word
# Keep typing to ignore
```

**Customization:**
```bash
# Change suggestion color (in ~/.zshrc or local config)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
```

---

## 🎨 Syntax Highlighting

### `zsh-syntax-highlighting` - Real-time Command Validation
Highlights commands as you type them.

**Colors:**
- **Green**: Valid command
- **Red**: Invalid command or typo
- **Yellow**: Aliases
- **Blue**: Built-ins
- **Magenta**: Parameters

**Benefits:**
- Catch typos before running commands
- Learn which commands are available
- See which arguments are recognized

---

## 📁 Enhanced Directory Listing

### `k` - Git-Enhanced Directory Listing
Beautiful, git-aware directory listing.

```bash
# Use instead of ls
k

# Show hidden files
k -a

# Sort by time
k -t

# Reverse order
k -r
```

**Features:**
- Git status indicators
- File size human-readable
- Color-coded by file type
- Shows file age
- Permission indicators

---

## 🔧 Shell Enhancements

### Enhanced History Search
Navigate history with arrow keys:

```bash
# Type partial command:
git <press up arrow>

# Cycles through commands starting with "git"
# Down arrow goes forward
```

### Auto-pushd
Directory stack automatically maintained:

```bash
cd ~/project1
cd ~/project2
cd ~/project3

# Jump back:
cd -      # Last directory (project2)
cd -2     # Two directories back (project1)

# View stack:
dirs -v

# Use number:
cd ~2     # Jump to stack position 2
```

---

## 🎯 Quick Reference

### Navigation
```bash
z <query>           # Smart jump to directory
zi <query>          # Interactive directory picker
cd -                # Previous directory
dirs -v             # Show directory stack
```

### Search
```bash
Ctrl+R              # Search history (fzf/atuin)
Ctrl+T              # Find files (fzf)
Alt+C               # Find directories (fzf)
atuin search <q>    # Search with context
```

### Files
```bash
k                   # Enhanced ls with git info
fzf                 # Interactive file picker
```

### History
```bash
atuin stats         # History statistics
history | fzf       # Fuzzy search history
```

---

## ⚙️ Configuration

### Enable/Disable Features

All features are enabled by default. To customize:

**Disable auto-suggestions:**
```bash
# Add to ~/.dotfiles/local/zsh-config
unset ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE
```

**Customize fzf:**
```bash
# Add to ~/.dotfiles/local/zsh-config
export FZF_DEFAULT_OPTS="--height 50% --border --preview 'cat {}'"
```

**Customize Starship:**
```bash
# Edit ~/.config/starship.toml
starship config
```

---

## 🚀 Pro Tips

### Combine Tools
```bash
# fzf + vim
v() { vim $(fzf) }

# zoxide + fzf
zf() { cd $(zoxide query -l | fzf) }

# atuin + grep
hist-docker() { atuin search docker | grep -i "$1" }
```

### Keyboard Efficiency
```bash
# Accept partial autosuggestion
# Type command → Press Alt+F to accept one word

# Multi-select with fzf
# Use Tab to select multiple, Enter to confirm

# Quick directory navigation
# cd with just partial name works (if unique)
cd Doc<TAB>  # Completes to Documents/
```

### History Power User
```bash
# Search specific time range
atuin search --before "yesterday" --after "last week" deploy

# Search in specific directory
atuin search --cwd ~/projects git commit

# Export history
atuin export > my_history.txt
```

---

## 🛠️ Troubleshooting

### Auto-suggestions not working
```bash
# Check if loaded
echo $ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE

# Reinstall
cd ~/.dotfiles
git submodule update --init --recursive
```

### fzf not binding keys
```bash
# Check if fzf is installed
command -v fzf

# Reinstall keybindings
source <(fzf --zsh)
```

### zoxide not tracking
```bash
# Check if initialized
zoxide query -l

# Re-initialize
eval "$(zoxide init zsh)"
```

### Starship not showing
```bash
# Check if installed
starship --version

# Test manually
starship init zsh

# Reinstall
brew install starship
```

---

## 📚 Learn More

- **Starship**: [starship.rs](https://starship.rs)
- **zoxide**: [github.com/ajeetdsouza/zoxide](https://github.com/ajeetdsouza/zoxide)
- **fzf**: [github.com/junegunn/fzf](https://github.com/junegunn/fzf)
- **atuin**: [atuin.sh](https://atuin.sh)
- **zsh-autosuggestions**: [github.com/zsh-users/zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- **zsh-syntax-highlighting**: [github.com/zsh-users/zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)

---

**Enjoy your supercharged shell!** 🚀
