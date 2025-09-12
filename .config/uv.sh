#!/usr/bin/env sh
set -e

# Ensure uv is installed
if ! command -v uv &>/dev/null; then
  echo "Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# Uv tool installations
uv_tools=(
  csvkit
  "git+https://github.com/54yyyu/zotero-mcp.git"
  "git+https://github.com/doobidoo/mcp-memory-service.git"
  "git+https://github.com/rudra-ravi/wikipedia-mcp.git"
  "huggingface_hub[cli]"
  llm
  nf-core
  pip
  "vectorcode[lsp,mcp]"
  youtube_transcript_api
  "yt-dlp[default,curl-cffi]"
)

echo "Installing/upgrading uv tools..."
for tool in "${uv_tools[@]}"; do
  uv tool install --upgrade "$tool"
done

# Ensure llm is installed before installing plugins
if command -v llm &>/dev/null; then
  llm_plugins=(
    llm-anthropic
    llm-cmd
    llm-fragments-github
    llm-fragments-pdf
    llm-fragments-site-text
    llm-gemini
    llm-ollama
    llm-tools-rag
  )

  echo "Installing/upgrading llm plugins..."
  for plugin in "${llm_plugins[@]}"; do
    llm install -U "$plugin"
  done
else
  echo "llm not found; skipping llm plugin installation."
fi
