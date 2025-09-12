rf() {
  if [ -z "$2" ]; then
    rg --files --hidden --no-ignore-vcs | rg "$1"
  else
    rg --files --hidden --no-ignore-vcs "$2" | rg "$1"
  fi
}

rmatch() {
  if [ "$#" -gt "1" ]; then
    rg --files-with-matches --hidden --no-ignore-vcs "$1" "${@:2}"
  else
    rg --files-with-matches --hidden --no-ignore-vcs "$1"
  fi
}

zbat() {
  gzip -cd -- "$@" | bat
}

viewhtml() {
  if [ "$#" -gt "1" ]; then
    pandoc "$1" --to markdown | mdcat "${@:2}"
  else
    pandoc "$1" --to markdown | mdcat
  fi
}

my_ls() {
  # Initialize variables
  local args=()
  local sort_by_modified=false

  # Iterate over all arguments
  for arg in "$@"; do
    local include=true
    if [[ "$arg" == -* && "$arg" == *"t"* && ${#arg} -lt 5 ]]; then
      # Remove 't' from the argument as far is smaller than 4
      arg=${arg/t/}
      # If the argument is just '-', remove it
      if [[ "$arg" == "-" ]]; then
        include=false
      fi
      sort_by_modified=true
    fi
    # Add the processed argument to the args array
    if $include; then
      args+=("$arg")
    fi
  done

  # Shift all arguments
  set -- "${args[@]}"

  # Execute eza with the appropriate options
  if $sort_by_modified; then
    eza --git --icons --sort modified "$@"
  else
    eza --git --icons "$@"
  fi
}
y() {
  if [ -n "$1" ]; then
    if [ -d "$1" ]; then
      yazi "$1"
    else
      yazi "$(zoxide query $1)"
    fi
  else
    yazi
  fi
  return $?
}
# function y() {
#   local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
#   NVIM=1 NVIM_LOG_FILE=1 yazi "$@" --cwd-file="$tmp"
#   if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
#     builtin cd -- "$cwd"
#   fi
#   rm -f -- "$tmp"
# }
