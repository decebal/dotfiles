#!/usr/bin/env bash

# Dotfiles Installation Script
# Enhanced version with better error handling, backups, and user experience

set -euo pipefail  # Exit on error, undefined variables, and pipe failures

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
LOG_FILE="$DOTFILES/install.log"

# Helper functions
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE" >&2
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

# Check prerequisites
check_prerequisites() {
    log "Checking prerequisites..."

    local missing_deps=()

    # Check for required commands
    for cmd in git curl; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_deps+=("$cmd")
        fi
    done

    if [ ${#missing_deps[@]} -ne 0 ]; then
        error "Missing required dependencies: ${missing_deps[*]}"
        error "Please install them and run the script again."
        exit 1
    fi

    # Check if we're in the dotfiles directory
    if [ ! -f "$DOTFILES/install.sh" ]; then
        error "This script must be run from the dotfiles directory"
        error "Current directory: $(pwd)"
        exit 1
    fi

    log "Prerequisites check passed ✓"
}

# Create backup of existing dotfiles
backup_existing() {
    log "Creating backup of existing dotfiles..."

    local files_to_backup=(
        "$HOME/.bashrc"
        "$HOME/.zshrc"
        "$HOME/.vimrc"
        "$HOME/.vim"
        "$HOME/.gitconfig"
        "$HOME/.oh-my-zsh"
    )

    local backup_needed=false
    for file in "${files_to_backup[@]}"; do
        if [ -e "$file" ] && [ ! -L "$file" ]; then
            backup_needed=true
            break
        fi
    done

    if [ "$backup_needed" = true ]; then
        mkdir -p "$BACKUP_DIR"
        for file in "${files_to_backup[@]}"; do
            if [ -e "$file" ] && [ ! -L "$file" ]; then
                local basename=$(basename "$file")
                info "Backing up $file to $BACKUP_DIR/$basename"
                cp -r "$file" "$BACKUP_DIR/$basename" 2>/dev/null || true
            fi
        done
        log "Backup created at: $BACKUP_DIR"
    else
        log "No backup needed - existing files are already symlinks or don't exist"
    fi
}

# Initialize git submodules
init_submodules() {
    log "Initializing git submodules..."

    if [ -f "$DOTFILES/.gitmodules" ]; then
        cd "$DOTFILES"
        git submodule init
        git submodule update --recursive
        log "Git submodules initialized ✓"
    else
        warning "No .gitmodules file found, skipping submodule initialization"
    fi
}

# Create local directory structure
create_local_dirs() {
    log "Creating local directory structure..."

    mkdir -p "$DOTFILES/local"

    # Create empty local config files if they don't exist
    local local_files=(
        "aliases"
        "functions"
        "paths"
        "zsh-config"
        "bash-config"
        "master-config.sh"
    )

    for file in "${local_files[@]}"; do
        if [ ! -f "$DOTFILES/local/$file" ]; then
            touch "$DOTFILES/local/$file"
            info "Created local/$file"
        fi
    done

    log "Local directory structure created ✓"
}

# Setup shell configuration
setup_shell() {
    log "Setting up shell configuration..."

    echo ""
    echo "Which shell would you like to configure?"
    echo "  1) Bash"
    echo "  2) Zsh (recommended)"
    echo "  3) Both"
    echo "  4) Skip shell setup"
    echo ""
    read -p "Enter your choice [1-4]: " shell_choice

    case $shell_choice in
        1)
            setup_bash
            ;;
        2)
            setup_zsh
            ;;
        3)
            setup_bash
            setup_zsh
            ;;
        4)
            log "Skipping shell setup"
            ;;
        *)
            warning "Invalid choice, skipping shell setup"
            ;;
    esac
}

setup_bash() {
    log "Setting up Bash configuration..."

    # Remove existing file/link if it exists
    [ -e "$HOME/.bashrc" ] && rm -f "$HOME/.bashrc"

    ln -sf "$DOTFILES/bash/bashrc" "$HOME/.bashrc"
    log "Bash configuration linked ✓"
}

setup_zsh() {
    log "Setting up Zsh configuration..."

    # Remove existing files/links if they exist
    [ -e "$HOME/.zshrc" ] && rm -f "$HOME/.zshrc"
    [ -e "$HOME/.oh-my-zsh" ] && rm -rf "$HOME/.oh-my-zsh"

    ln -sf "$DOTFILES/zsh/zshrc" "$HOME/.zshrc"
    ln -sf "$DOTFILES/zsh/oh-my-zsh" "$HOME/.oh-my-zsh"

    # Check if zsh is installed
    if command -v zsh &> /dev/null; then
        log "Zsh configuration linked ✓"

        # Offer to set as default shell
        if [ "$SHELL" != "$(which zsh)" ]; then
            read -p "Would you like to set Zsh as your default shell? [y/N]: " set_default
            if [[ "$set_default" =~ ^[Yy]$ ]]; then
                chsh -s "$(which zsh)" || warning "Failed to set default shell. You may need to run: chsh -s $(which zsh)"
            fi
        fi
    else
        warning "Zsh is not installed. Please install it for the configuration to work."
    fi
}

# Setup Vim configuration
setup_vim() {
    log "Setting up Vim configuration..."

    read -p "Would you like to setup Vim configuration? [Y/n]: " setup_vim_choice
    if [[ ! "$setup_vim_choice" =~ ^[Nn]$ ]]; then
        # Remove existing files/links
        [ -e "$HOME/.vim" ] && rm -rf "$HOME/.vim"
        [ -e "$HOME/.vimrc" ] && rm -f "$HOME/.vimrc"
        [ -e "$HOME/.gvimrc" ] && rm -f "$HOME/.gvimrc"

        ln -sf "$DOTFILES/vim/vim-sources" "$HOME/.vim"
        ln -sf "$DOTFILES/vim/vimrc" "$HOME/.vimrc"
        ln -sf "$DOTFILES/vim/gvimrc" "$HOME/.gvimrc"

        log "Vim configuration linked ✓"
    else
        log "Skipping Vim setup"
    fi
}

# Setup Git configuration
setup_git() {
    log "Setting up Git configuration..."

    read -p "Would you like to setup Git configuration? [Y/n]: " setup_git_choice
    if [[ ! "$setup_git_choice" =~ ^[Nn]$ ]]; then
        # Backup existing gitconfig if it exists and isn't from our dotfiles
        if [ -f "$HOME/.gitconfig" ]; then
            if ! grep -q "dotfiles/git/gitconfig" "$HOME/.gitconfig" 2>/dev/null; then
                cp "$HOME/.gitconfig" "$HOME/.gitconfig.backup"
                info "Backed up existing .gitconfig to .gitconfig.backup"
            fi
        fi

        # Check if gitconfig already has our configuration
        if [ -f "$HOME/.gitconfig" ] && grep -q "dotfiles/git/gitconfig" "$HOME/.gitconfig" 2>/dev/null; then
            info "Git configuration already includes dotfiles settings"
        else
            # Add include directive instead of appending
            git config --global include.path "$DOTFILES/git/gitconfig"
            log "Git configuration included via include.path ✓"
        fi

        # Set global gitignore
        git config --global core.excludesfile "$DOTFILES/git/gitignore_global"
        log "Global gitignore configured ✓"

        # Prompt for user details if not set
        if [ -z "$(git config --global user.name)" ]; then
            read -p "Enter your Git username: " git_username
            git config --global user.name "$git_username"
        fi

        if [ -z "$(git config --global user.email)" ]; then
            read -p "Enter your Git email: " git_email
            git config --global user.email "$git_email"
        fi
    else
        log "Skipping Git setup"
    fi
}

# Install optional tools
install_optional_tools() {
    log "Checking optional tools..."

    echo ""
    echo "Would you like to install/check optional development tools?"
    echo "  1) Node Version Manager (nvm)"
    echo "  2) Python Version Manager (pyenv)"
    echo "  3) Oh My Posh (prompt theme)"
    echo "  4) All of the above"
    echo "  5) None"
    echo ""
    read -p "Enter your choice [1-5]: " tools_choice

    case $tools_choice in
        1)
            check_nvm
            ;;
        2)
            check_pyenv
            ;;
        3)
            check_oh_my_posh
            ;;
        4)
            check_nvm
            check_pyenv
            check_oh_my_posh
            ;;
        5)
            log "Skipping optional tools"
            ;;
        *)
            warning "Invalid choice, skipping optional tools"
            ;;
    esac
}

check_nvm() {
    if [ ! -d "$HOME/.nvm" ]; then
        read -p "NVM is not installed. Would you like to install it? [y/N]: " install_nvm
        if [[ "$install_nvm" =~ ^[Yy]$ ]]; then
            info "Installing NVM..."
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
            log "NVM installed ✓"
        fi
    else
        log "NVM is already installed ✓"
    fi
}

check_pyenv() {
    if ! command -v pyenv &> /dev/null; then
        read -p "Pyenv is not installed. Would you like to install it? [y/N]: " install_pyenv
        if [[ "$install_pyenv" =~ ^[Yy]$ ]]; then
            info "Installing pyenv..."
            curl https://pyenv.run | bash
            log "Pyenv installed ✓"
        fi
    else
        log "Pyenv is already installed ✓"
    fi
}

check_oh_my_posh() {
    if ! command -v oh-my-posh &> /dev/null; then
        read -p "Oh My Posh is not installed. Would you like to install it? [y/N]: " install_omp
        if [[ "$install_omp" =~ ^[Yy]$ ]]; then
            info "Please install Oh My Posh manually from: https://ohmyposh.dev/docs/installation/linux"
            info "For macOS: brew install jandedobbeleer/oh-my-posh/oh-my-posh"
        fi
    else
        log "Oh My Posh is already installed ✓"
    fi
}

# Validate installation
validate_installation() {
    log "Validating installation..."

    local validation_passed=true

    # Check symlinks
    local links_to_check=(
        "$HOME/.zshrc:$DOTFILES/zsh/zshrc"
        "$HOME/.bashrc:$DOTFILES/bash/bashrc"
        "$HOME/.vimrc:$DOTFILES/vim/vimrc"
    )

    for link_pair in "${links_to_check[@]}"; do
        IFS=':' read -r link target <<< "$link_pair"
        if [ -L "$link" ]; then
            if [ "$(readlink "$link")" = "$target" ]; then
                info "✓ $link correctly linked"
            else
                warning "✗ $link exists but points to wrong target"
                validation_passed=false
            fi
        fi
    done

    if [ "$validation_passed" = true ]; then
        log "Installation validation passed ✓"
    else
        warning "Some validation checks failed. Please review the warnings above."
    fi
}

# Main installation flow
main() {
    clear
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "           Dotfiles Installation Script v2.0            "
    echo "════════════════════════════════════════════════════════"
    echo ""

    # Start logging
    echo "" > "$LOG_FILE"
    log "Starting dotfiles installation..."
    log "Dotfiles directory: $DOTFILES"

    # Run installation steps
    check_prerequisites
    backup_existing
    init_submodules
    create_local_dirs
    setup_shell
    setup_vim
    setup_git
    install_optional_tools
    validate_installation

    # Final message
    echo ""
    echo "════════════════════════════════════════════════════════"
    log "Installation completed successfully! 🎉"
    echo ""
    info "Next steps:"
    info "  1. Restart your shell or run: source ~/.zshrc (or ~/.bashrc)"
    info "  2. Check the log file for details: $LOG_FILE"
    if [ -d "$BACKUP_DIR" ]; then
        info "  3. Your old configuration was backed up to: $BACKUP_DIR"
    fi
    info "  4. Customize your local settings in: $DOTFILES/local/"
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo ""
}

# Run main function
main "$@"