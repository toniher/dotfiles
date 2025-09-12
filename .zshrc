# Set History and allow dotfiles
setopt histignorealldups sharehistory globdots

# Quality of life options
setopt autocd        # Change directory by typing its name
setopt correct       # Command correction suggestions
setopt no_beep       # Disable terminal bell


# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history
export HISTIGNORE="&:vault*"

fpath+=~/.zfunc
# Use modern completion system
autoload -Uz compinit
compinit

# Default editor
export EDITOR=nvim


# Handling of Paths
# Add $HOME/bin and $HOME/.local/bin to PATH if not already present
case ":$PATH:" in
    *:"$HOME/bin":*) ;;
    *) export PATH="$HOME/bin:$PATH" ;;
esac
case ":$PATH:" in
    *:"$HOME/.local/bin":*) ;;
    *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

# GO
export GOPATH=${HOME}/go
export PATH="/usr/local/go/bin:${PATH}:${GOPATH}/bin"

# PHP Composer
export PATH="$HOME/.config/composer/vendor/bin:$PATH"

# Deno
if [ -d "$HOME/.deno" ]; then
  export DENO_INSTALL="$HOME/.deno"
  export PATH="$DENO_INSTALL/bin:$PATH"
fi

if [ -d "$HOME/.local/share/fzf-tab" ]; then
  . "$HOME/.local/share/fzf-tab/fzf-tab.plugin.zsh"
  # disable sort when completing `git checkout`
  zstyle ':completion:*:git-checkout:*' sort false
  # set descriptions format to enable group support
  # NOTE: don't use escape sequences here, fzf-tab will ignore them
  zstyle ':completion:*:descriptions' format '[%d]'
  # set list-colors to enable filename colorizing
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
  # force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
  zstyle ':completion:*' menu no
  # preview directory's content with eza when completing cd
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
  # switch group using `<` and `>`
  zstyle ':fzf-tab:*' switch-group '<' '>'
fi

[[ -f "$HOME/.bash-preexec.sh" ]] && source "$HOME/.bash-preexec.sh"

# PHP
if command -v php &>/dev/null; then
  export HOST_HAS_PHP=1
else
  export HOST_HAS_PHP=0
fi

if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  . "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  bindkey '^ ' autosuggest-accept
fi
if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  . "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi



# Cargo environement
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

# Programs for multiple versions
# pyenv - Python
if [ -d "$HOME/.pyenv" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
  export GIT_INTERNAL_GETTEXT_TEST_FALLBACKS=1
fi

# jenv - Java
if command -v jenv &>/dev/null; then
  export PATH="$HOME/.jenv/bin:$PATH"
  eval "$(jenv init -)"
fi

# Nvim
if [ -d "$HOME/.local/share/bob" ]; then
  export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
fi

# Extra vars
if test -n "$ZSH_VERSION"; then
  export MYSHELL="zsh"
  export HOSTNAME=$(hostname)
else
  export MYSHELL="bash"
fi

# External files: aliases and functions
if [ -f "$HOME/.secrets.sh" ]; then
    . "$HOME/.secrets.sh"
fi

if [ -f "$HOME/.bash_aliases" ]; then
    . "$HOME/.bash_aliases"
fi

if [ -f "$HOME/.machine_aliases" ]; then
    . "$HOME/.machine_aliases"
fi

if [ -f "$HOME/.shell_functions.sh" ]; then
    . "$HOME/.shell_functions.sh"
fi
