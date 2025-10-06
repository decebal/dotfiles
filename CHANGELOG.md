# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Starship prompt integration for fast, beautiful prompts
- zsh-autosuggestions plugin for fish-like suggestions
- Comprehensive README with features and installation guide
- MIT License for open source distribution
- CONTRIBUTING.md with detailed contribution guidelines
- GitHub issue templates (bug report, feature request, question)
- GitHub pull request template
- FEATURES.md showcase document
- SOCIAL_MEDIA.md with ready-to-post content for LinkedIn and X
- Enhanced .gitignore with comprehensive patterns
- Changesets for automated release management
- GitHub Actions workflow for automated releases
- RELEASES.md documentation for release process

### Changed
- Updated shell configuration architecture documentation in CLAUDE.md
- Enhanced .gitignore to prevent accidental secret commits
- Replaced Oh-My-Posh with Starship in main configuration

### Fixed
- Improved dual-mode configuration detection for AI agents

## [1.0.0] - 2025-10-07

### Initial Release

This is the first public release of the dotfiles repository.

#### Features
- 🎨 Dual-mode shell configuration (interactive + AI agent modes)
- 🤖 Automatic AI agent detection (Cursor, Copilot, Windsurf, VS Code)
- 🚀 Zsh configuration with extensive plugin support
- 📦 Organized structure with common/, zsh/, bash/, vim/, git/ directories
- 🔒 Security-focused with gitignored local/ directory
- 🧪 Health check script for validation
- 📚 Comprehensive documentation

#### Included Tools
- zsh-syntax-highlighting
- zoxide for smart directory jumping
- fzf for fuzzy finding
- atuin for smart history
- Git enhancements and aliases
- GitHub Copilot CLI integration

#### Configuration
- Smart navigation with z, fzf, atuin
- Auto-suggestions from command history
- Syntax highlighting for valid/invalid commands
- Enhanced git completions
- Machine-specific config support in local/

---

[Unreleased]: https://github.com/decebal/dotfiles/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/decebal/dotfiles/releases/tag/v1.0.0
