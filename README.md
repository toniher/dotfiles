Snapshot of my dotfiles

I keep some of them here for instructional purposes.

The contents of this repo may not be always up to date with my present-day configuration.

# Software

- [Alacritty](https://alacritty.org) — GPU-accelerated terminal emulator
- [Ghostty](https://ghostty.org/) — Terminal emulator with native GUI
- [Neovim](https://neovim.io/) — Extensible Vim-based text editor
- [Wezterm](https://wezterm.org/) — GPU-accelerated cross-platform terminal
- [Zellij](https://zellij.dev/) — Terminal multiplexer (tmux alternative)
- [Starship](https://starship.rs/) — Cross-shell prompt customizer

# Shell Configuration

- `.zshrc` — Zsh configuration with:
  - History management and dotfile visibility
  - `fzf-tab` integration for fuzzy completion
  - `zsh-autosuggestions` and `zsh-syntax-highlighting`
  - Multiple runtime managers: pyenv (Python), jenv (Java), bob (Neovim)
  - Package manager shells: micromamba, pixi
- `.bashrc` — Bash configuration
- `.bash_aliases` — Shell aliases for common commands:
  - `bat` for `cat`, `eza` for `ls`, `rg` for `grep`
  - Git shortcuts: `gci`, `gdf`, `glp`, `gst`
  - `zoxide` integration with `z` as `cd` replacement
  - `starship` prompt initialization
- `.shell_functions.sh` — Custom shell functions:
  - `rf` / `rmatch` — Ripgrep file search
  - `zbat` — Read gzipped files with bat
  - `viewhtml` — Convert and preview HTML files
  - `my_ls` — Enhanced eza wrapper
  - `y` — Yazi file picker integration

# Git Configuration

- `.gitconfig` — Git settings featuring:
  - [Delta](https://github.com/dandavison/delta) as pager with Tokyo Night theme
  - Graph alias for visual branch history
  - Submodule recursion enabled
  - Diff3 conflict style

# Terminal Configuration

- `.config/starship.toml` — Starship prompt with hostname, username, git status, and time display
- `.config/alacritty/alacritty.toml` — Alacritty terminal settings
- `.config/ghostty/` — Ghostty terminal configuration
- `.config/zellij/config.kdl` — Zellij multiplexer layout and keybindings
- `.wezterm.lua` — Wezterm terminal configuration

# Neovim Configuration

- `.config/nvim/` — Neovim Lua-based configuration:
  - `init.lua` — Main entry point
  - `lua/` — Modular Lua configuration
  - `ftplugin/` — Filetype-specific plugins
  - [README](.config/nvim/README.md) — Detailed plugin and setup documentation

# Package Manager Lists

Text files listing packages for various tools:
- `.config/cargo.txt` — Rust/Cargo packages
- `.config/go.txt` — Go packages
- `.config/npm.txt` — Node.js packages
- `.config/uv.sh` — UV (Python) environment setup

# Installation Scripts

```
.local/bin/install-packages.sh    # Install system packages
.local/bin/install-nerdfonts.sh  # Install Nerd Fonts
.config/install-ubuntu.sh        # Ubuntu initial setup
```

# Key Tools Integrated

| Category | Tools |
|----------|-------|
| **Shells** | zsh, bash |
| **File navigation** | zoxide, yazi, eza |
| **Search** | fzf, ripgrep (rg), fd |
| **Version managers** | pyenv, fnm, jenv, bob, fnm |
| **Python envs** | uv, micromamba, pixi |
| **Git tools** | delta, atuin (history) |
| **Display** | bat, mdcat |
