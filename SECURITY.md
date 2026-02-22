# SECURITY.md — Security Posture & Roadmap

*Last updated: 2026-02-21*

---

## ✅ What's Working

### Disk Encryption
- **FileVault: ON** — full disk encryption on Tersono-MacMini
- At-rest protection for all local files

### 1Password Vault
- **Tersono vault** with read/write service account access
- All API keys/tokens stored as individual entries with proper categorization
- Service account token scoped to Tersono vault only

### Git Hygiene
- `.env` files in `.gitignore` across all repos
- Private repos by default
- No known secret commits in git history (not yet audited)

### Network
- Mac Mini on local network (192.168.184.152)
- OpenClaw gateway bound to loopback (127.0.0.1:18789)
- Tailscale: OFF (not currently needed)

### Access Control
- stranger-danger skill installed (challenge-response for sensitive ops)
- OpenClaw allowlist configured for WhatsApp

---

## 🔴 Known Vulnerabilities — Needs Fixing

### 1. OP_SERVICE_ACCOUNT_TOKEN in plaintext (~/.zshrc)
- **Risk: HIGH** — The 1Password service account token sits in `~/.zshrc` as a plaintext export
- This is the master key to the vault. If someone gets shell access, they get everything.
- **Options to explore:**
  - macOS Keychain (`security add-generic-password` / `security find-generic-password`)
  - Encrypted file decrypted at shell startup
  - 1Password desktop app integration (biometric unlock, no static token)
  - Environment variable injected by LaunchAgent with Keychain lookup
- **Priority: HIGH** — defeats the purpose of 1Password if the master key is in a dotfile

### 2. Other secrets still in plaintext (~/.zshrc)
- `THINGS_AUTH_TOKEN` (duplicated 3x!)
- `XAI_API_KEY`
- `HA_TOKEN`
- `X_API_KEY`, `X_API_SECRET`, `X_BEARER_TOKEN`
- **Fix:** Migrate to `op run` / `op read` so these pull from 1Password at runtime instead of sitting in shell config
- **Priority: MEDIUM** — less critical than the OP token itself (these are app-level, not vault-level)

### 3. .env.local files across dev projects
- Found `.env.local` in: `~/clawd/`, `~/dev/sheldn/`, `~/dev/konteks-web/`, `~/dev/fastclaw/`, `~/dev/openclaw-skill-fastclaw/`
- May contain API keys, Convex tokens, Stripe keys, etc.
- **Fix:** Audit contents, migrate secrets to 1Password, use `op run` or `op inject` for local dev
- **Priority: MEDIUM**

### 4. Session logs may contain secrets
- OpenClaw session transcripts capture full conversations including tool output
- If a secret was ever printed in a tool result, it's in the logs
- This conversation itself contains the full 1Password service account token in history
- **Fix:** Audit session log retention policy, consider auto-redaction
- **Priority: MEDIUM**

### 5. THINGS_AUTH_TOKEN duplicated 3x in .zshrc
- Not a security hole per se, but sloppy — indicates .zshrc has been appended to without cleanup
- **Fix:** Deduplicate during the .zshrc secret migration
- **Priority: LOW**

---

## 🟡 Future Hardening Ideas

### Short Term (next session)
- [ ] Move `OP_SERVICE_ACCOUNT_TOKEN` to macOS Keychain
- [ ] Deduplicate .zshrc entries
- [ ] Create `op run` wrapper script for OpenClaw that injects secrets at runtime
- [ ] Audit .env.local files across all dev projects

### Medium Term
- [ ] Set up `op inject` templates for each project's env vars
- [ ] Rotate any keys that were exposed in session logs
- [ ] Configure OpenClaw to pull secrets from 1Password at gateway startup
- [ ] Review session log retention — auto-purge or redact sensitive tool output
- [ ] Audit git history for accidentally committed secrets (`git log -p | grep -i 'sk-'`)

### Long Term / Explore
- [ ] SSH keys managed by 1Password SSH agent (settings enabled, config not wired)
- [ ] Wire `~/.ssh/config` to use 1Password agent socket
- [ ] Secrets rotation schedule (quarterly?)
- [ ] Network segmentation for IoT devices (Home Assistant, cameras)
- [ ] Fail2ban or similar on the Mac Mini if SSH is exposed
- [ ] Consider Tailscale for remote access instead of port forwarding
- [ ] Hardware security key (YubiKey) for critical accounts

---

## 📋 Secret Inventory

### ~/.zshrc (plaintext env exports)
| Secret | In 1Password? | Status |
|--------|---------------|--------|
| OP_SERVICE_ACCOUNT_TOKEN | N/A (is the key) | 🔴 **Critical** — vault master key in plaintext |
| THINGS_AUTH_TOKEN (3x duplicated!) | ✅ | 🟡 Migrate + deduplicate |
| XAI_API_KEY | ✅ | 🟡 Migrate |
| HA_TOKEN | ✅ | 🟡 Migrate |
| X_API_KEY | ✅ | 🟡 Migrate |
| X_API_SECRET | ✅ | 🟡 Migrate |
| X_BEARER_TOKEN | ✅ | 🟡 Migrate |

### ~/.config/ (app-managed config files)
| File | Contents | In 1Password? | Status |
|------|----------|---------------|--------|
| `~/.config/anthropic/api_key` | Anthropic API key (plaintext file) | ✅ | 🟡 Duplicate of vault |
| `~/.config/moltbook/api_key` | Moltbook API key | ❌ | 🟡 Add to vault |
| `~/.config/moltbook/credentials.json` | Agent name, profile URL, verification code | ❌ | 🟡 Add to vault |
| `~/.config/gh/hosts.yml` | GitHub CLI OAuth (managed by `gh auth`) | ❌ | ⚪ Leave (gh-managed) |

### ~/Library/Application Support/openclaw/ (OpenClaw internals)
| File | Contents | Status |
|------|----------|--------|
| `identity/device.json` | Device keypair (public + private) | ⚪ OpenClaw-managed |
| `identity/device-auth.json` | Node + operator tokens, device ID | ⚪ OpenClaw-managed |

### 1Password Vault (Tersono) — ✅ Properly stored
| Entry | Tags |
|-------|------|
| Anthropic Claude | AI, LLM |
| OpenAI | AI, LLM |
| Google Gemini | AI, LLM |
| Moonshot Kimi | AI, LLM |
| xAI Grok | AI, LLM |
| X.com API (ProdTersono) | Social, X |
| Brave Search | Search |
| ElevenLabs | TTS, Voice |
| Telegram Bot | Messaging |
| Home Assistant | Smart Home |
| Things 3 | Productivity |

### .env.local files (project-specific, unaudited)
| File | Status |
|------|--------|
| `~/clawd/.env.local` | 🟡 Audit |
| `~/dev/sheldn/.env.local` | 🟡 Audit |
| `~/dev/konteks-web/.env.local` | 🟡 Audit |
| `~/dev/fastclaw/.env.local` | 🟡 Audit |
| `~/dev/openclaw-skill-fastclaw/.env.local` | 🟡 Audit |

### Not yet in 1Password — needs adding
| Secret | Location |
|--------|----------|
| Moltbook API key | `~/.config/moltbook/api_key` |
| Moltbook credentials | `~/.config/moltbook/credentials.json` |

---

## 🔒 Principles

1. **Secrets never in git** — .env in .gitignore, no exceptions
2. **1Password is source of truth** — all secrets live in the Tersono vault
3. **Runtime injection over static config** — prefer `op run` / `op read` over env exports
4. **Least privilege** — service account scoped to one vault
5. **Encrypt at rest** — FileVault on all machines
6. **Don't log secrets** — be careful with tool output in session transcripts
