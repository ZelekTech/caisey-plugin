# Caisey by Tech Garrison

Public store manifests for the **Caisey** remote MCP server. Caisey is an AI agent for managed service providers (MSPs) that works on enrolled client PCs. Through MCP, an AI client can list PCs and chats, read transcripts, send prompts to run work on remote machines, and answer operator questions and command approvals.

| | |
| --- | --- |
| **Display name** | Caisey by Tech Garrison |
| **Publisher** | Zelek |
| **Website** | https://helpforsupport.com |
| **Documentation** | https://helpforsupport.com/docs/remote-mcp |
| **Support** | feedback@helpforsupport.com |
| **Privacy** | https://helpforsupport.com/privacy |
| **Terms** | https://helpforsupport.com/terms |
| **Remote MCP URL** | https://helpforsupport.com/mcp |
| **License** | Apache-2.0 (see [LICENSE](LICENSE) and [NOTICE](NOTICE)) |

**Logo:** `assets/logo.png` (512×512) and `assets/logo.svg` are **placeholders** — a black square with a white “C” — until final brand assets ship.

## Authentication

The production MCP endpoint uses **OAuth 2.1** with **Dynamic Client Registration (DCR)**, **PKCE S256**, and scope **`caisey.mcp`**. Each client completes OAuth in the host (Cursor, Grok Build, ChatGPT, and so on); do not put client secrets or tokens in this repository.

Live tool metadata (including MCP annotations) is published at:

- Production: https://helpforsupport.com/.well-known/mcp/server-card.json  
- Development (newest annotations): https://dev.helpforsupport.com/.well-known/mcp/server-card.json  

## Important disclosure (command approvals)

An MCP client authenticated as a **member of your Caisey organization** can **answer pending command approvals**, including approvals triggered by **its own session**. Approvals are recorded in the audit log with origin **`mcp/<client>`**. Operators should **keep a human in the loop**: review commands before approving, use workspace approval policies, and monitor the audit log (`read_audit_log`).

## MCP tools (19)

Annotations below match the production server card at publish time. For the canonical list, use the server card URLs above.

| Tool | Title | Read-only | Destructive |
| --- | --- | --- | --- |
| `list_devices` | List Caisey PCs | Yes | No |
| `get_device` | Get a Caisey PC | Yes | No |
| `list_sessions` | List Caisey chats | Yes | No |
| `read_transcript` | Read a Caisey chat | Yes | No |
| `send_prompt` | Send a prompt to a Caisey PC | No | Yes |
| `get_version` | Read the Caisey build version | Yes | No |
| `stop_session` | Stop a Caisey chat turn | No | Yes |
| `list_permission_rules` | List Caisey permission rules | Yes | No |
| `revoke_permission_rule` | Revoke a Caisey permission rule | No | Yes |
| `get_session_live` | Get live Caisey chat | Yes | No |
| `watch_session` | Watch a live Caisey chat | Yes | No |
| `wait_for_messages` | Wait for Caisey chat messages | Yes | No |
| `list_pending_approvals` | List pending Caisey command approvals | Yes | No |
| `respond_to_approval` | Answer a Caisey command approval | No | No |
| `list_pending_questions` | List pending Caisey questions | Yes | No |
| `answer_question` | Answer a Caisey operator question | No | No |
| `list_org_pending` | List pending Caisey approvals and questions | Yes | No |
| `read_audit_log` | Read the Caisey audit log | Yes | No |
| `get_session_status` | Get Caisey chat status | Yes | No |

## Repository layout

| Path | Purpose |
| --- | --- |
| `.cursor-plugin/plugin.json` | Cursor Marketplace manifest |
| `mcp.json` | Cursor remote MCP declaration |
| `.grok-plugin/plugin.json` | Grok / xAI plugin source manifest |
| `.mcp.json` | Grok / xAI MCP declaration (`type`: `http`) |
| `openai/` | OpenAI ChatGPT plugin ZIP contents (`plugin.json`, `mcp.json`, `assets/`) |
| `xai/marketplace-entry.example.json` | Example remote entry for [xai-org/plugin-marketplace](https://github.com/xai-org/plugin-marketplace) |
| `assets/` | Shared logos |
| `scripts/validate.sh` | Local validation |
| `scripts/build-openai-zip.sh` | Build `dist/caisey-openai-plugin.zip` |

## Install by client

### Cursor

1. Use this repository as the plugin source (after it is accepted on the [Cursor Marketplace](https://cursor.com/marketplace/publish)).
2. Manifest: `.cursor-plugin/plugin.json`; MCP: root `mcp.json` pointing at `https://helpforsupport.com/mcp`.
3. On install, sign in with OAuth (DCR + PKCE) and grant scope `caisey.mcp`.

Reference: [Cursor plugins reference](https://cursor.com/docs/reference/plugins).

### Grok Build (xAI marketplace)

This repo is the **upstream source** for a remote catalog entry in [xai-org/plugin-marketplace](https://github.com/xai-org/plugin-marketplace):

1. Add an entry to `.grok-plugin/marketplace.json` with `source.url` = `https://github.com/ZelekTech/caisey-plugin.git` and a **40-character lowercase commit `sha`** (pin the release commit; do not use a branch or tag).
2. Regenerate `.grok-plugin/plugin-index.json` with that repo’s scripts.
3. See `xai/marketplace-entry.example.json` for a template.

Required files in **this** repo: `.grok-plugin/plugin.json`, `.mcp.json`, `README.md`, license.

Reference: [CONTRIBUTING.md](https://github.com/xai-org/plugin-marketplace/blob/main/CONTRIBUTING.md).

### OpenAI ChatGPT / Codex

1. Build the upload ZIP: `bash scripts/build-openai-zip.sh` → `dist/caisey-openai-plugin.zip`.
2. Upload via ChatGPT **Plugins** (do not submit until you are ready for review).
3. Connect the remote MCP server in the portal, complete **domain verification** for `helpforsupport.com`, and run the tool scan.
4. OAuth is declared in `openai/mcp.json` (`client.mode`: `dcr`, scope `caisey.mcp`).

Reference: [Package your plugin](https://developers.openai.com/plugins/build/plugins) and [Upload and submit](https://developers.openai.com/plugins/deploy/submission).

## Validation

Run local checks:

```bash
bash scripts/validate.sh
```

This validates JSON, required paths, Cursor/Grok/OpenAI field sanity, and builds the OpenAI ZIP. Full store validation still happens in each marketplace’s CI or upload portal (see script output for links).

## Publisher

**Zelek** publishes Caisey by Tech Garrison. Copyright Zelek — see [NOTICE](NOTICE).
