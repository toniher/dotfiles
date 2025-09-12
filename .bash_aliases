# Git aliases
alias gci='git commit'
alias gdf='git diff'
alias glp='git log --pretty=format:"%C(yellow)%h%Creset - %C(green)%an%Creset, %ar : %s"'
alias gst='git status -s'
alias mv='mv -i'

# Conditional aliases and completions (sorted by command)
if command -v atuin &>/dev/null; then
  eval "$(atuin init $MYSHELL)"
fi

# https://www.tecmint.com/bd-go-back-to-linux-directory/
if command -v bd &>/dev/null; then
  alias bd=". bd -si"
fi

if command -v bat &>/dev/null; then
  alias cat="bat -p"
fi

if command -v btm &>/dev/null; then
  alias top="btm -b"
fi

if command -v chezmoi &>/dev/null; then
  eval "$(chezmoi completion $MYSHELL)"
fi

if command -v eza &>/dev/null; then
  alias exa="eza"
  alias l="eza --icons --git -l"
  alias la="eza --icons --git -l --all"
  alias ll="eza --icons --git -l"
  alias ls='my_ls'
  alias lt="eza --icons --git -l --sort modified"
fi

if command -v fd &>/dev/null; then
  # Search hidden and inside gitignore
  alias fd="fd -I -H"
fi

if command -v fnm &>/dev/null; then
  eval "$(fnm env --use-on-cd)"
fi

if command -v microk8s &>/dev/null; then
  alias kubectl="microk8s kubectl"
fi

if command -v nvim &>/dev/null; then
  alias nvim-test="NVIM_APPNAME=\"nvim-test\" nvim"
  alias vim="nvim"
fi

if command -v pistol &>/dev/null; then
  alias fzf="fzf --header 'E to edit' --preview='pistol {}' --bind 'E:execute(nvim {})'"
fi

if command -v pixi &>/dev/null; then
  eval "$(pixi completion --shell $MYSHELL)"
fi

# If procs do autocompletion
if command -v procs &>/dev/null; then
  source <(procs --gen-completion-out $MYSHELL)
fi

if command -v rg &>/dev/null; then
  alias grep="rg"
fi

if command -v starship &>/dev/null; then
  eval "$(starship init $MYSHELL)"
fi

if command -v vectorcode &>/dev/null; then
  eval "$(vectorcode -s $MYSHELL)"
fi

if command -v zoxide &>/dev/null; then
  alias cd="z"
  eval "$(zoxide init $MYSHELL)"
else
  alias z="cd"
fi
