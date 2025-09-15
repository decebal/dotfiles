#!/usr/bin/env bash

# Dotfiles Health Check Script
# Validates the dotfiles installation and reports any issues

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
ISSUES_FOUND=0

# Helper functions
check_pass() {
    echo -e "${GREEN}✓${NC} $1"
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
}

check_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

check_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

header() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Check symlinks
check_symlinks() {
    header "Checking Symlinks"

    local symlinks=(
        "$HOME/.zshrc:$DOTFILES/zsh/zshrc"
        "$HOME/.bashrc:$DOTFILES/bash/bashrc"
        "$HOME/.vimrc:$DOTFILES/vim/vimrc"
        "$HOME/.vim:$DOTFILES/vim/vim-sources"
        "$HOME/.oh-my-zsh:$DOTFILES/zsh/oh-my-zsh"
    )

    for link_pair in "${symlinks[@]}"; do
        IFS=':' read -r link target <<< "$link_pair"
        if [ -L "$link" ]; then
            actual_target=$(readlink "$link")
            if [ "$actual_target" = "$target" ]; then
                check_pass "$(basename "$link") → correct target"
            else
                check_fail "$(basename "$link") → wrong target (expected: $target, got: $actual_target)"
            fi
        elif [ -e "$link" ]; then
            check_warn "$(basename "$link") exists but is not a symlink"
        else
            check_info "$(basename "$link") not configured"
        fi
    done
}

# Check shell configuration
check_shell_config() {
    header "Checking Shell Configuration"

    # Check current shell
    current_shell=$(basename "$SHELL")
    check_info "Current shell: $current_shell"

    # Check if shell configs are sourced properly
    if [ "$current_shell" = "zsh" ]; then
        if [ -f "$HOME/.zshrc" ]; then
            if grep -q "DOTFILES=" "$HOME/.zshrc" 2>/dev/null; then
                check_pass "Zsh configuration contains DOTFILES variable"
            else
                check_fail "Zsh configuration missing DOTFILES variable"
            fi

            # Check for AI agent detection
            if grep -q "CURSOR_AGENT" "$HOME/.zshrc" 2>/dev/null; then
                check_pass "AI agent detection configured"
            else
                check_warn "AI agent detection not configured"
            fi
        fi
    fi

    if [ "$current_shell" = "bash" ]; then
        if [ -f "$HOME/.bashrc" ]; then
            if grep -q "DOTFILES=" "$HOME/.bashrc" 2>/dev/null; then
                check_pass "Bash configuration contains DOTFILES variable"
            else
                check_fail "Bash configuration missing DOTFILES variable"
            fi
        fi
    fi
}

# Check Git configuration
check_git_config() {
    header "Checking Git Configuration"

    # Check if git is installed
    if command -v git &> /dev/null; then
        check_pass "Git is installed ($(git --version 2>&1 | head -1))"

        # Check global gitignore
        gitignore=$(git config --global core.excludesfile 2>/dev/null || echo "")
        if [ -n "$gitignore" ]; then
            if [[ "$gitignore" == *"dotfiles"* ]]; then
                check_pass "Global gitignore configured with dotfiles"
            else
                check_warn "Global gitignore set but not from dotfiles: $gitignore"
            fi
        else
            check_warn "No global gitignore configured"
        fi

        # Check user configuration
        user_name=$(git config --global user.name 2>/dev/null || echo "")
        user_email=$(git config --global user.email 2>/dev/null || echo "")

        if [ -n "$user_name" ]; then
            check_pass "Git user name configured: $user_name"
        else
            check_warn "Git user name not configured"
        fi

        if [ -n "$user_email" ]; then
            check_pass "Git user email configured: $user_email"
        else
            check_warn "Git user email not configured"
        fi
    else
        check_fail "Git is not installed"
    fi
}

# Check submodules
check_submodules() {
    header "Checking Git Submodules"

    cd "$DOTFILES"

    if [ -f ".gitmodules" ]; then
        # Check for uninitialized submodules
        uninit_count=$(git submodule status | grep -c "^-" || true)
        if [ "$uninit_count" -eq 0 ]; then
            check_pass "All submodules initialized"
        else
            check_warn "$uninit_count submodule(s) not initialized"
            check_info "Run: git submodule update --init --recursive"
        fi

        # Check for modified submodules
        modified_count=$(git submodule status | grep -c "^+" || true)
        if [ "$modified_count" -eq 0 ]; then
            check_pass "No modified submodules"
        else
            check_warn "$modified_count submodule(s) have modifications"
        fi

        # Check for the marker issue
        if git submodule status 2>&1 | grep -q "no submodule mapping found.*marker"; then
            check_fail "Invalid submodule: common/marker (no mapping in .gitmodules)"
            check_info "Consider removing: git rm --cached common/marker"
        fi
    else
        check_info "No submodules configured"
    fi
}

# Check local configuration
check_local_config() {
    header "Checking Local Configuration"

    if [ -d "$DOTFILES/local" ]; then
        check_pass "Local directory exists"

        local expected_files=(
            "aliases"
            "functions"
            "paths"
        )

        for file in "${expected_files[@]}"; do
            if [ -f "$DOTFILES/local/$file" ]; then
                if [ -s "$DOTFILES/local/$file" ]; then
                    check_pass "local/$file exists with content"
                else
                    check_info "local/$file exists but is empty"
                fi
            else
                check_warn "local/$file is missing"
            fi
        done
    else
        check_fail "Local directory missing"
        check_info "Run: mkdir -p $DOTFILES/local"
    fi
}

# Check development tools
check_dev_tools() {
    header "Checking Development Tools"

    # Node/NVM
    if [ -d "$HOME/.nvm" ]; then
        check_pass "NVM is installed"
        if command -v node &> /dev/null; then
            check_pass "Node.js is available ($(node --version))"
        else
            check_info "Node.js not loaded (run: nvm install node)"
        fi
    else
        check_info "NVM not installed"
    fi

    # Python/Pyenv
    if command -v pyenv &> /dev/null; then
        check_pass "Pyenv is installed"
        if command -v python3 &> /dev/null; then
            check_pass "Python3 is available ($(python3 --version))"
        fi
    else
        check_info "Pyenv not installed"
    fi

    # Oh My Posh
    if command -v oh-my-posh &> /dev/null; then
        check_pass "Oh My Posh is installed"
    else
        check_info "Oh My Posh not installed"
    fi
}

# Check for common issues
check_common_issues() {
    header "Checking Common Issues"

    # Check for missing install.py
    if [ ! -f "$DOTFILES/install.py" ]; then
        check_warn "install.py referenced in install.sh but doesn't exist"
    fi

    # Check for broken symlinks in home directory
    broken_links=$(find "$HOME" -maxdepth 1 -type l ! -exec test -e {} \; -print 2>/dev/null | grep -c "$DOTFILES" || true)
    if [ "$broken_links" -eq 0 ]; then
        check_pass "No broken dotfiles symlinks in home directory"
    else
        check_fail "$broken_links broken symlink(s) pointing to dotfiles"
    fi

    # Check permissions
    if [ -x "$DOTFILES/install.sh" ]; then
        check_pass "install.sh is executable"
    else
        check_warn "install.sh is not executable"
        check_info "Run: chmod +x $DOTFILES/install.sh"
    fi
}

# Check AI/LLM optimizations
check_ai_optimizations() {
    header "Checking AI/LLM Optimizations"

    if [ -f "$DOTFILES/.cursorrules" ]; then
        check_pass ".cursorrules file exists"
    else
        check_warn ".cursorrules file missing"
    fi

    if [ -f "$DOTFILES/CLAUDE.md" ]; then
        check_pass "CLAUDE.md documentation exists"
    else
        check_warn "CLAUDE.md documentation missing"
    fi

    if [ -f "$DOTFILES/common/zsh-agent-config" ]; then
        check_pass "AI agent configuration exists"
    else
        check_warn "AI agent configuration missing"
    fi

    # Test AI agent mode detection
    if [ -f "$HOME/.zshrc" ]; then
        CURSOR_AGENT=1 zsh -c 'echo $AI_AGENT_CONTEXT' 2>/dev/null | grep -q "1"
        if [ $? -eq 0 ]; then
            check_pass "AI agent mode detection works"
        else
            check_warn "AI agent mode detection may not be working"
        fi
    fi
}

# Main health check
main() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "         Dotfiles Health Check Report"
    echo "════════════════════════════════════════════════════════"

    check_symlinks
    check_shell_config
    check_git_config
    check_submodules
    check_local_config
    check_dev_tools
    check_common_issues
    check_ai_optimizations

    echo ""
    echo "════════════════════════════════════════════════════════"

    if [ $ISSUES_FOUND -eq 0 ]; then
        echo -e "${GREEN}Health check completed: All checks passed!${NC}"
    else
        echo -e "${YELLOW}Health check completed: $ISSUES_FOUND issue(s) found${NC}"
        echo "Review the warnings and failures above for recommended fixes."
    fi

    echo "════════════════════════════════════════════════════════"
    echo ""

    exit $ISSUES_FOUND
}

# Run main function
main "$@"