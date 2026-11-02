#!/usr/bin/env bash
# Build the OpenAI / ChatGPT plugin upload ZIP from openai/.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="${ROOT}/dist/caisey-openai-plugin.zip"
mkdir -p "${ROOT}/dist"
(
  cd "${ROOT}/openai"
  zip -r "${OUT}" plugin.json mcp.json assets/
)
echo "Wrote ${OUT}"
