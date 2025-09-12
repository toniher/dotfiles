#!/usr/bin/env bash

FILE=${1:-cargo}
ISNICE=${2:-1}

NICECMD=""

if [ "$ISNICE" -eq 1 ]; then
  NICECMD="nice -n 19"
fi

function read_file_lines {
  local file_path="${HOME}/.config/${FILE}.txt"
  while IFS= read -r line; do
    echo "$line"
    eval "$PROGRAM $line"
  done <"$file_path"
}

case "$FILE" in
cargo)
  PROGRAM="$NICECMD cargo install"
  read_file_lines
  ;;
go)
  PROGRAM="$NICECMD go install"
  read_file_lines
  ;;
npm)
  PROGRAM="$NICECMD npm install -g"
  read_file_lines
  ;;
uv)
  bash "${HOME}/.config/uv.sh" "$ISNICE"
  ;;
*)
  echo "Unknown file type. Choose cargo, go, npm or uv"
  exit 1
  ;;
esac
