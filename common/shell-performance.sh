#!/usr/bin/env bash
# Shell Performance Optimization Settings
# Source this file in your shell config for better performance

# ============================================================================
# Zsh Performance Optimizations
# ============================================================================

if [ -n "$ZSH_VERSION" ]; then
    # Compile zsh scripts for faster loading
    zcompile_if_needed() {
        local file="$1"
        if [[ -f "$file" && ! -f "$file.zwc" ]] || [[ "$file" -nt "$file.zwc" ]]; then
            zcompile "$file" 2>/dev/null
        fi
    }

    # Compile important files
    zcompile_if_needed "$HOME/.zshrc"
    zcompile_if_needed "$DOTFILES/common/aliases"
    zcompile_if_needed "$DOTFILES/common/functions"

    # Faster completion initialization - only if not already done
    if [[ -z "$_COMPINIT_LOADED" ]]; then
        autoload -Uz compinit
        
        # Only check for insecure directories once a day
        if [[ -n "$ZSH_COMPDUMP" ]]; then
            compdump_file="$ZSH_COMPDUMP"
        else
            compdump_file="${ZDOTDIR:-$HOME}/.zcompdump"
        fi
        
        if [[ $compdump_file(Nmh+24) ]]; then
            compinit -C  # Skip security check for cached completions
        else
            # Try secure compinit first, fallback to insecure if needed
            compinit -u 2>/dev/null || compinit -C
        fi
        
        export _COMPINIT_LOADED=1
    fi

    # Optimization flags
    setopt NO_BEEP              # Disable beep
    setopt COMBINING_CHARS      # Combine zero-length chars with base chars
    setopt RC_QUOTES            # Allow 'Henry''s Garage' instead of 'Henry'\''s Garage'
    setopt MAIL_WARNING         # Don't print warning if mail file accessed

    # History optimizations
    setopt HIST_FIND_NO_DUPS    # Don't show duplicates in history search
    setopt HIST_REDUCE_BLANKS   # Remove superfluous blanks
    setopt SHARE_HISTORY        # Share history between sessions
    setopt EXTENDED_HISTORY     # Save timestamp and duration

    # Directory navigation
    setopt AUTO_PUSHD           # Push directories onto stack
    setopt PUSHD_IGNORE_DUPS    # Don't push duplicates
    setopt PUSHD_MINUS          # Exchange + and - meanings
fi

# ============================================================================
# NVM Lazy Loading (significant performance improvement)
# ============================================================================

if [ -d "$HOME/.nvm" ] && [ -z "$NVM_LOADED" ]; then
    export NVM_DIR="$HOME/.nvm"

    # Lazy load nvm - only when needed
    nvm() {
        unset -f nvm node npm npx
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
        export NVM_LOADED=1
        nvm "$@"
    }

    node() {
        unset -f nvm node npm npx
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        export NVM_LOADED=1
        node "$@"
    }

    npm() {
        unset -f nvm node npm npx
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        export NVM_LOADED=1
        npm "$@"
    }

    npx() {
        unset -f nvm node npm npx
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        export NVM_LOADED=1
        npx "$@"
    }
fi

# ============================================================================
# PyEnv Lazy Loading
# ============================================================================

if command -v pyenv &>/dev/null && [ -z "$PYENV_LOADED" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"

    # Lazy load pyenv
    pyenv() {
        unset -f pyenv
        eval "$(command pyenv init -)"
        export PYENV_LOADED=1
        pyenv "$@"
    }
fi

# ============================================================================
# Oh-My-Posh vs Oh-My-Zsh Theme Resolution
# ============================================================================

setup_prompt_theme() {
    # Detect which prompt system to use
    if command -v oh-my-posh &>/dev/null && [ -z "$DISABLE_OH_MY_POSH" ]; then
        # Oh-My-Posh is available and not disabled
        if [ -n "$ZSH_VERSION" ]; then
            # Disable oh-my-zsh theme when using oh-my-posh
            export ZSH_THEME=""
        fi

        # Load oh-my-posh with performance optimizations
        if [ -f ~/.poshthemes/material.omp.json ]; then
            eval "$(oh-my-posh init zsh --config ~/.poshthemes/material.omp.json)"
        else
            eval "$(oh-my-posh init zsh)"
        fi

        export PROMPT_SYSTEM="oh-my-posh"
    elif [ -n "$ZSH_VERSION" ] && [ -n "$ZSH_THEME" ]; then
        # Use oh-my-zsh theme
        export PROMPT_SYSTEM="oh-my-zsh"
    else
        # Fallback to basic prompt
        export PROMPT_SYSTEM="basic"
    fi
}

# ============================================================================
# Performance Monitoring
# ============================================================================

# Enable shell startup profiling (set PROFILE_SHELL=1 before sourcing)
if [ "${PROFILE_SHELL:-0}" = "1" ]; then
    if [ -n "$ZSH_VERSION" ]; then
        zmodload zsh/zprof
    elif [ -n "$BASH_VERSION" ]; then
        PS4='+ $(date "+%s.%N")\011 '
        exec 3>&2 2>/tmp/bashstart.$$.log
        set -x
    fi
fi

# Function to measure command execution time
# Set DISABLE_EXEC_TIME=1 to disable this feature
if [ -n "$ZSH_VERSION" ] && [ "${DISABLE_EXEC_TIME:-0}" != "1" ]; then
    # Check if we're on macOS or Linux for proper time measurement
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS: Use perl for millisecond precision
        preexec() {
            timer=$(perl -MTime::HiRes=time -e 'printf "%.0f", time * 1000')
        }

        precmd() {
            if [ $timer ]; then
                now=$(perl -MTime::HiRes=time -e 'printf "%.0f", time * 1000')
                elapsed=$(($now-$timer))

                # Show execution time for commands that take > 3 seconds
                if [ $elapsed -gt 3000 ]; then
                    export RPS1="%F{yellow}${elapsed}ms%f"
                else
                    unset RPS1
                fi
                unset timer
            fi
        }
    elif command -v date &>/dev/null && date +%s%N &>/dev/null 2>&1; then
        # Linux: Use nanosecond precision
        preexec() {
            timer=$(($(date +%s%N)/1000000))
        }

        precmd() {
            if [ $timer ]; then
                now=$(($(date +%s%N)/1000000))
                elapsed=$(($now-$timer))

                # Show execution time for commands that take > 3 seconds
                if [ $elapsed -gt 3000 ]; then
                    export RPS1="%F{yellow}${elapsed}ms%f"
                else
                    unset RPS1
                fi
                unset timer
            fi
        }
    else
        # Fallback: Use seconds only
        preexec() {
            timer=$(date +%s)
        }

        precmd() {
            if [ $timer ]; then
                now=$(date +%s)
                elapsed=$(($now-$timer))

                # Show execution time for commands that take > 3 seconds
                if [ $elapsed -gt 3 ]; then
                    export RPS1="%F{yellow}${elapsed}s%f"
                else
                    unset RPS1
                fi
                unset timer
            fi
        }
    fi
fi

# ============================================================================
# GitHub Copilot Terminal Optimizations
# ============================================================================

# Optimize terminal for GitHub Copilot and AI tools
if [[ "$TERM_PROGRAM" == "vscode" ]] || [[ -n "$VSCODE_PID" ]] || [[ -n "$GITHUB_COPILOT_TERMINAL" ]]; then
    # Consistent terminal dimensions for AI parsing
    export COLUMNS=${COLUMNS:-120}
    export LINES=${LINES:-30}
    
    # Optimize command completion for AI
    if [ -n "$ZSH_VERSION" ]; then
        setopt AUTO_MENU
        setopt COMPLETE_IN_WORD
        setopt ALWAYS_TO_END
        setopt LIST_PACKED  # Compact completion lists
        setopt LIST_TYPES   # Show file types in completion
    fi
    
    # Faster history for AI context
    export HISTSIZE=5000  # Reasonable size for AI context
    export SAVEHIST=5000
    
    # Disable slow features in AI mode
    export DISABLE_EXEC_TIME=1  # Disable execution time display
    unset RPS1  # Clear right prompt for cleaner output
fi

# ============================================================================
# Export Performance Settings
# ============================================================================

export SHELL_PERFORMANCE_LOADED=1

# Disable automatic updates for performance
export DISABLE_AUTO_UPDATE=true
export DISABLE_UPDATE_PROMPT=true

# Reduce history size for faster operations
export HISTSIZE=10000
export SAVEHIST=10000

# Enable parallel execution where possible
export MAKEFLAGS="-j$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 1)"