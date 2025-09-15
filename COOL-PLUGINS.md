# Cool Oh-My-Zsh Plugins Guide

Your dotfiles now include some amazing productivity plugins! Here's what each one does and how to use them.

## 🚀 Navigation & Directory Management

### `z` - Smart Directory Jumping
Jump to frequently used directories with just a few letters!
```bash
# After visiting directories a few times:
cd ~/Documents/Projects/awesome-project
cd ~/Downloads
cd ~/Desktop

# Later, jump instantly:
z awesome    # Goes to ~/Documents/Projects/awesome-project
z down       # Goes to ~/Downloads
z desk       # Goes to ~/Desktop
```

### `wd` - Warp Directories
Bookmark and jump to directories instantly.
```bash
# Bookmark current directory
wd add work

# Jump to bookmarked directory from anywhere
wd work

# List all bookmarks
wd list

# Remove bookmark
wd rm work
```

### `last-working-dir`
Automatically returns to your last working directory when opening new shells.

### `dircycle`
Navigate directory stack with keyboard shortcuts:
- `Ctrl+Shift+Left` - Go to previous directory
- `Ctrl+Shift+Right` - Go to next directory

## 📁 File Management

### `extract` - Universal Archive Extractor
Extract any archive type with one command!
```bash
extract archive.zip
extract package.tar.gz
extract file.rar
extract document.7z
# Works with: zip, tar, gz, bz2, rar, 7z, xz, and more!
```

### `copyfile` - Copy File Contents
Copy entire file contents to clipboard:
```bash
copyfile ~/.ssh/id_rsa.pub  # Copy SSH key to clipboard
copyfile config.json        # Copy config file
```

### `copypath` - Copy Current Path
Copy current directory path to clipboard:
```bash
copypath           # Copy current directory
copypath filename  # Copy full path to file
```

## 🔍 Search & Web

### `web-search` - Search from Terminal
Search the web directly from your terminal:
```bash
google "how to use zsh plugins"
stackoverflow "bash scripting"
github "dotfiles"
youtube "terminal productivity"
duckduckgo "privacy search"
```

## 🛠️ Development Tools

### `brew` - Homebrew Shortcuts (macOS)
Enhanced Homebrew completions and shortcuts:
```bash
# Better completions for:
brew install <tab>    # Shows available packages
brew uninstall <tab>  # Shows installed packages
```

### `docker` - Docker Completions
Smart Docker command completions:
```bash
docker run <tab>      # Shows available images
docker exec <tab>     # Shows running containers
docker-compose <tab>  # Completes docker-compose commands
```

### `npm` - NPM Completions
Enhanced npm command completions:
```bash
npm install <tab>     # Shows available packages
npm run <tab>         # Shows available scripts
```

## 🎯 Command Enhancements

### `sudo` - ESC ESC Sudo
Press `ESC` twice to add sudo to the current command!
```bash
# Type a command that needs sudo:
systemctl restart nginx

# Press ESC twice, and it becomes:
sudo systemctl restart nginx
```

### `command-not-found` - Smart Suggestions
Get helpful suggestions when you mistype commands:
```bash
$ gi status
Command 'gi' not found, did you mean:
  command 'git' from git-core
```

### `common-aliases` - Useful Shortcuts
Adds many helpful aliases:
```bash
# Directory navigation
..="cd .."
...="cd ../.."
....="cd ../../.."

# File operations
l="ls -lah"
la="ls -lAh"
ll="ls -lh"
lsa="ls -lah"

# And many more!
```

## 📚 History Management

### `per-directory-history` - Separate History Per Directory
Each directory gets its own command history!
- Use `Ctrl+G` to toggle between local and global history
- Perfect for different project contexts

## 🎨 Visual Enhancements

### `colorize` - Syntax Highlighting for Files
Automatically syntax-highlight files when using `cat`:
```bash
cat script.py        # Shows Python syntax highlighting
cat config.json      # Shows JSON syntax highlighting
cat Dockerfile       # Shows Docker syntax highlighting
```

### `autoenv` - Auto-load Environment Files
Automatically source `.env` files when entering directories:
```bash
# Create a .env file in your project:
echo "export PROJECT_NAME=awesome" > .env

# When you cd into the directory, it auto-loads!
cd my-project  # PROJECT_NAME is now set
```

## ⚙️ Configuration Options

### Enable/Disable Features
You can control which plugins load with environment variables:

```bash
# Disable advanced plugins for better performance
export ENABLE_ADVANCED_PLUGINS=false

# Enable fun plugins
export ENABLE_FUN_PLUGINS=true

# Reload shell
source ~/.zshrc
```

## 🏃‍♂️ Quick Start

To activate all these plugins:
```bash
source ~/.zshrc
```

Then try:
```bash
# Navigation
z               # See tracked directories
wd list         # See bookmarked directories

# File operations
extract --help  # See supported formats
copypath        # Copy current directory

# Web search
google "zsh plugins"

# Development
brew --help     # If you have Homebrew
docker --help   # If you have Docker
```

## 🔧 Troubleshooting

### Plugin not working?
```bash
# Check if plugin is loaded
echo $plugins | grep plugin-name

# Reload configuration
source ~/.zshrc

# Run health check
./health-check.sh
```

### Performance issues?
```bash
# Disable advanced plugins
export ENABLE_ADVANCED_PLUGINS=false
source ~/.zshrc

# Profile startup time
time zsh -i -c exit
```

Enjoy your supercharged shell! 🚀