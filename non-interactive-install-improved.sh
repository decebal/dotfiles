#!/usr/bin/env bash

# Non-Interactive Dotfiles Installation Script
# For automated/CI/CD environments

set -euo pipefail

# Configuration
DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
LOG_FILE="${LOG_FILE:-$DOTFILES/install-auto.log}"
SHELL_TYPE="${SHELL_TYPE:-zsh}"  # Can be overridden: bash, zsh, or both

# Logging functions (silent by default, verbose with DEBUG=1)
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
    [ "${DEBUG:-0}" = "1" ] && echo "$1"
}

error() {
    echo "[ERROR] $1" | tee -a "$LOG_FILE" >&2
    exit 1
}

# Create backup
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
                cp -r "$file" "$BACKUP_DIR/$basename" 2>/dev/null || true
                log "Backed up $file"
            fi
        done
    fi
}

# Initialize submodules
init_submodules() {
    log "Initializing git submodules..."

    if [ -f "$DOTFILES/.gitmodules" ]; then
        cd "$DOTFILES"
        git submodule init >> "$LOG_FILE" 2>&1
        git submodule update --recursive >> "$LOG_FILE" 2>&1
        log "Git submodules initialized"
    fi
}

# Create local directories
create_local_dirs() {
    log "Creating local directory structure..."

    mkdir -p "$DOTFILES/local"

    local local_files=(
        "aliases"
        "functions"
        "paths"
        "zsh-config"
        "bash-config"
        "master-config.sh"
        "zsh-setup"
    )

    for file in "${local_files[@]}"; do
        touch "$DOTFILES/local/$file"
    done

    log "Local directory structure created"
}

# Setup shells based on SHELL_TYPE
setup_shells() {
    log "Setting up shell configuration for: $SHELL_TYPE"

    case "$SHELL_TYPE" in
        bash)
            [ -e "$HOME/.bashrc" ] && rm -f "$HOME/.bashrc"
            ln -sf "$DOTFILES/bash/bashrc" "$HOME/.bashrc"
            log "Bash configuration linked"
            ;;
        zsh)
            [ -e "$HOME/.zshrc" ] && rm -f "$HOME/.zshrc"
            [ -e "$HOME/.oh-my-zsh" ] && rm -rf "$HOME/.oh-my-zsh"
            ln -sf "$DOTFILES/zsh/zshrc" "$HOME/.zshrc"
            ln -sf "$DOTFILES/zsh/oh-my-zsh" "$HOME/.oh-my-zsh"
            log "Zsh configuration linked"
            ;;
        both)
            [ -e "$HOME/.bashrc" ] && rm -f "$HOME/.bashrc"
            [ -e "$HOME/.zshrc" ] && rm -f "$HOME/.zshrc"
            [ -e "$HOME/.oh-my-zsh" ] && rm -rf "$HOME/.oh-my-zsh"
            ln -sf "$DOTFILES/bash/bashrc" "$HOME/.bashrc"
            ln -sf "$DOTFILES/zsh/zshrc" "$HOME/.zshrc"
            ln -sf "$DOTFILES/zsh/oh-my-zsh" "$HOME/.oh-my-zsh"
            log "Both Bash and Zsh configurations linked"
            ;;
        *)
            error "Invalid SHELL_TYPE: $SHELL_TYPE (use bash, zsh, or both)"
            ;;
    esac
}

# Setup Vim
setup_vim() {
    log "Setting up Vim configuration..."

    [ -e "$HOME/.vim" ] && rm -rf "$HOME/.vim"
    [ -e "$HOME/.vimrc" ] && rm -f "$HOME/.vimrc"
    [ -e "$HOME/.gvimrc" ] && rm -f "$HOME/.gvimrc"

    ln -sf "$DOTFILES/vim/vim-sources" "$HOME/.vim"
    ln -sf "$DOTFILES/vim/vimrc" "$HOME/.vimrc"
    ln -sf "$DOTFILES/vim/gvimrc" "$HOME/.gvimrc"

    log "Vim configuration linked"
}

# Setup Git
setup_git() {
    log "Setting up Git configuration..."

    # Use include.path instead of appending
    git config --global include.path "$DOTFILES/git/gitconfig"
    git config --global core.excludesfile "$DOTFILES/git/gitignore_global"

    # Set default user if provided via environment
    if [ -n "${GIT_USER_NAME:-}" ]; then
        git config --global user.name "$GIT_USER_NAME"
        log "Git user name set: $GIT_USER_NAME"
    fi

    if [ -n "${GIT_USER_EMAIL:-}" ]; then
        git config --global user.email "$GIT_USER_EMAIL"
        log "Git user email set: $GIT_USER_EMAIL"
    fi

    log "Git configuration completed"
}

# Validate installation
validate() {
    log "Validating installation..."

    local validation_passed=true

    # Check critical symlinks based on shell type
    if [[ "$SHELL_TYPE" == *"zsh"* ]]; then
        if [ ! -L "$HOME/.zshrc" ]; then
            error "Zsh configuration not properly linked"
        fi
    fi

    if [[ "$SHELL_TYPE" == *"bash"* ]]; then
        if [ ! -L "$HOME/.bashrc" ]; then
            error "Bash configuration not properly linked"
        fi
    fi

    log "Installation validated"
}

# Main installation
main() {
    echo "Starting non-interactive dotfiles installation..."
    echo "Log file: $LOG_FILE"

    # Start fresh log
    echo "" > "$LOG_FILE"
    log "Non-interactive installation started"
    log "Dotfiles directory: $DOTFILES"
    log "Shell type: $SHELL_TYPE"

    # Check prerequisites
    if [ ! -d "$DOTFILES" ]; then
        error "Dotfiles directory not found: $DOTFILES"
    fi

    if ! command -v git &> /dev/null; then
        error "Git is required but not installed"
    fi

    # Run installation steps
    backup_existing
    init_submodules
    create_local_dirs
    setup_shells
    setup_vim
    setup_git
    validate

    log "Installation completed successfully"
    echo "Installation completed. Check $LOG_FILE for details."

    # Return success
    exit 0
}

# Run main
main "$@"