#!/bin/zsh
# GitHub Copilot Terminal Integration
# Enhanced zsh configuration for better GitHub Copilot experience

# ============================================================================
# GitHub Copilot CLI Integration
# ============================================================================

# Check if GitHub CLI and Copilot extension are available
if command -v gh &>/dev/null; then
    # Auto-complete for gh copilot commands
    if gh copilot --version &>/dev/null 2>&1; then
        # Create convenient aliases for Copilot CLI
        alias gcs='gh copilot suggest'
        alias gce='gh copilot explain'
        
        # Function to get Copilot suggestions for the last failed command
        fix-last() {
            local last_cmd=$(fc -ln -1)
            if [[ -n "$last_cmd" ]]; then
                echo "Getting Copilot suggestion for: $last_cmd"
                gh copilot suggest "fix this command: $last_cmd"
            else
                echo "No previous command found"
            fi
        }
        
        # Function to explain the last command
        explain-last() {
            local last_cmd=$(fc -ln -1)
            if [[ -n "$last_cmd" ]]; then
                echo "Explaining command: $last_cmd"
                gh copilot explain "$last_cmd"
            else
                echo "No previous command found"
            fi
        }
    fi
fi

# ============================================================================
# Terminal Output Optimization for AI
# ============================================================================

# Configure less for better AI parsing
export LESS='-R -M -i -j3'
export LESSHISTFILE=-

# Configure grep for consistent, AI-friendly output
export GREP_OPTIONS='--color=auto'
export GREP_COLORS='mt=1;32:fn=1;35:ln=1;36:se=1;31'

# Configure ls for consistent output across systems
if ls --color=auto / &>/dev/null 2>&1; then
    # GNU ls (Linux)
    alias ls='ls --color=auto --group-directories-first'
    export LS_COLORS='di=1;34:ln=1;36:so=32:pi=33:ex=1;32:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
else
    # BSD ls (macOS)
    alias ls='ls -G'
    export LSCOLORS='ExGxBxDxCxEgEdxbxgxcxd'
fi

# ============================================================================
# Git Integration for Better AI Context
# ============================================================================

# Enhanced git aliases that provide better context for AI
alias gst='git status --porcelain=v1'  # Consistent format for AI parsing
alias glog='git log --oneline --graph --decorate -10'  # Concise git history
alias gdiff='git diff --no-color'  # Clean diff output for AI analysis
alias gshow='git show --no-color --format=fuller'  # Detailed commit info

# Function to provide git context for AI
git-context() {
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        echo "📁 Repository: $(basename $(git rev-parse --show-toplevel))"
        echo "🌿 Branch: $(git branch --show-current)"
        echo "📊 Status:"
        git status --porcelain=v1 | head -10
        if [[ $(git status --porcelain=v1 | wc -l) -gt 10 ]]; then
            echo "   ... and $(($(git status --porcelain=v1 | wc -l) - 10)) more files"
        fi
        echo "📝 Last commit:"
        git log --oneline -1
    else
        echo "Not in a git repository"
    fi
}

# ============================================================================
# Project Context Detection
# ============================================================================

# Function to detect and display project type and context
project-context() {
    local pwd_basename=$(basename "$PWD")
    echo "📂 Current directory: $pwd_basename"
    
    # Detect project type based on files
    local project_types=()
    
    if [[ -f "package.json" ]]; then
        project_types+=("Node.js")
        if [[ -f "next.config.js" ]] || [[ -f "next.config.mjs" ]]; then
            project_types+=("Next.js")
        fi
        if [[ -d "src/components" ]] || [[ -f "src/App.tsx" ]] || [[ -f "src/App.jsx" ]]; then
            project_types+=("React")
        fi
        if [[ -f "vue.config.js" ]] || [[ -f "vite.config.js" ]]; then
            project_types+=("Vue.js")
        fi
    fi
    
    if [[ -f "go.mod" ]]; then
        project_types+=("Go")
    fi
    
    if [[ -f "Cargo.toml" ]]; then
        project_types+=("Rust")
    fi
    
    if [[ -f "requirements.txt" ]] || [[ -f "pyproject.toml" ]] || [[ -f "setup.py" ]]; then
        project_types+=("Python")
    fi
    
    if [[ -f "composer.json" ]]; then
        project_types+=("PHP")
    fi
    
    if [[ -f "Gemfile" ]]; then
        project_types+=("Ruby")
    fi
    
    if [[ -f "pom.xml" ]]; then
        project_types+=("Java/Maven")
    fi
    
    if [[ -f "build.gradle" ]] || [[ -f "build.gradle.kts" ]]; then
        project_types+=("Java/Gradle")
    fi
    
    if [[ -f "Dockerfile" ]]; then
        project_types+=("Docker")
    fi
    
    if [[ -f "docker-compose.yml" ]] || [[ -f "docker-compose.yaml" ]]; then
        project_types+=("Docker Compose")
    fi
    
    if [[ -f ".terraform" ]] || [[ -f "main.tf" ]]; then
        project_types+=("Terraform")
    fi
    
    if [[ ${#project_types[@]} -gt 0 ]]; then
        echo "🔧 Project type(s): ${(j:, :)project_types}"
    else
        echo "🔧 Project type: Unknown"
    fi
    
    # Show current git context if available
    git-context 2>/dev/null || true
}

# ============================================================================
# Command History Optimization for AI
# ============================================================================

# Function to show recent commands in a format useful for AI context
recent-commands() {
    local count=${1:-10}
    echo "📜 Recent commands (last $count):"
    fc -l -$count | sed 's/^[ ]*[0-9]*[ ]*/   /'
}

# Function to search command history
search-history() {
    if [[ -z "$1" ]]; then
        echo "Usage: search-history <search-term>"
        return 1
    fi
    
    echo "🔍 Commands containing '$1':"
    fc -l 1 | grep -i "$1" | tail -20 | sed 's/^[ ]*[0-9]*[ ]*/   /'
}

# ============================================================================
# Environment Information for AI Context
# ============================================================================

# Function to provide comprehensive environment info
env-context() {
    echo "💻 Environment Information:"
    echo "   OS: $(uname -s) $(uname -r)"
    echo "   Architecture: $(uname -m)"
    echo "   Shell: $SHELL ($ZSH_VERSION)"
    echo "   Terminal: $TERM_PROGRAM ${TERM_PROGRAM_VERSION:-unknown}"
    echo "   PWD: $PWD"
    
    if command -v node &>/dev/null; then
        echo "   Node.js: $(node --version)"
    fi
    
    if command -v npm &>/dev/null; then
        echo "   npm: $(npm --version)"
    fi
    
    if command -v python3 &>/dev/null; then
        echo "   Python: $(python3 --version | cut -d' ' -f2)"
    fi
    
    if command -v git &>/dev/null; then
        echo "   Git: $(git --version | cut -d' ' -f3)"
    fi
    
    if command -v docker &>/dev/null; then
        echo "   Docker: $(docker --version | cut -d' ' -f3 | sed 's/,//')"
    fi
}

# ============================================================================
# Quick Context Function (combines project and environment info)
# ============================================================================

# Main context function that provides comprehensive info for AI
ai-context() {
    echo "🤖 AI Context Summary"
    echo "===================="
    env-context
    echo ""
    project-context
    echo ""
    recent-commands 5
    echo "===================="
}

# ============================================================================
# Export Functions and Settings
# ============================================================================

export COPILOT_INTEGRATION_LOADED=1

# Aliases for quick access
alias ctx='ai-context'
alias pctx='project-context'
alias ectx='env-context'
alias rh='recent-commands'
alias sh='search-history'
alias gc='git-context'