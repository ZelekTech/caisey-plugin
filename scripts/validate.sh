#!/usr/bin/env bash
# Validate store manifests in this repo (local checks only; no store submission).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "== JSON syntax =="
for f in \
  .cursor-plugin/plugin.json \
  mcp.json \
  .grok-plugin/plugin.json \
  .mcp.json \
  openai/plugin.json \
  openai/mcp.json; do
  python3 -c "import json; json.load(open('$f'))" && echo "OK $f"
done

echo "== Required paths =="
test -f .cursor-plugin/plugin.json
test -f mcp.json
test -f .grok-plugin/plugin.json
test -f .mcp.json
test -f assets/logo.png
test -f assets/logo.svg
test -s openai/plugin.json
test -s openai/mcp.json
test -f openai/assets/logo.png
echo "OK paths"

echo "== Cursor manifest fields =="
python3 << 'PY'
import json
m = json.load(open(".cursor-plugin/plugin.json"))
assert m["name"] == "caisey"
assert m.get("logo") == "assets/logo.svg"
servers = json.load(open("mcp.json"))["mcpServers"]
assert "caisey" in servers
assert servers["caisey"]["url"] == "https://helpforsupport.com/mcp"
print("OK cursor")
PY

echo "== Grok / xAI manifest fields =="
python3 << 'PY'
import json
m = json.load(open(".grok-plugin/plugin.json"))
servers = json.load(open(".mcp.json"))["mcpServers"]
assert m["name"] == "caisey"
assert servers["caisey"]["type"] == "http"
assert servers["caisey"]["url"] == "https://helpforsupport.com/mcp"
print("OK grok source layout")
PY

echo "== OpenAI package fields =="
python3 << 'PY'
import json
p = json.load(open("openai/plugin.json"))
m = json.load(open("openai/mcp.json"))
iface = p["extensions"]["com.openai"]["interface"]
for key in ("displayName", "developerName", "privacyPolicyURL", "termsOfServiceURL", "websiteURL", "supportURL"):
    assert iface.get(key), key
auth = m["mcpServers"]["caisey"]["extensions"]["com.openai"]["auth"]
assert auth["client"]["mode"] == "dcr"
assert "caisey.mcp" in auth["baseScopes"]
print("OK openai")
PY

echo "== OpenAI ZIP layout =="
bash scripts/build-openai-zip.sh
unzip -l dist/caisey-openai-plugin.zip | grep -E 'plugin.json|mcp.json|assets/logo.png'
echo "OK zip"

echo ""
echo "All local checks passed."
echo ""
echo "Store-specific validation (run outside this repo):"
echo "  Cursor: https://cursor.com/docs/reference/plugins — install plugin from repo; confirm OAuth to https://helpforsupport.com/mcp"
echo "  xAI:    In xai-org/plugin-marketplace, add a remote catalog entry, then:"
echo "          python3 scripts/validate-catalog.py && python3 scripts/generate-plugin-index.py --check"
echo "  OpenAI: Upload dist/caisey-openai-plugin.zip at ChatGPT Plugins; connect MCP and complete domain verification."
