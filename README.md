# openclaw-skill-fastclaw

OpenClaw skill that connects your self-hosted OpenClaw instance to the [FastClaw](https://fastclaw.app) iOS app.

## What it does

Relays messages between your local OpenClaw Gateway and the FastClaw iOS app via [Convex](https://convex.dev) real-time sync. No port forwarding, no VPN, no Tailscale — just scan a QR code and you're connected.

## Install

**ClawHub**: [clawhub.ai/jamesalmeida/fastclaw-relay](https://clawhub.ai/jamesalmeida/fastclaw-relay)

```bash
clawhub install fastclaw-relay
```

## Pair

```bash
openclaw fastclaw pair
```

Scan the QR code from the FastClaw iOS app. That's it.

## How it works

```
Your OpenClaw (local) ←WS→ fastclaw-relay ←Convex→ FastClaw App (anywhere)
```

Both sides connect **outbound** to Convex — no firewall configuration needed.

## Background Service

Use launchd to keep the relay running in the background, auto-start on login, and come back after reboots.

```bash
./scripts/install-service.sh
```

This installs `~/Library/LaunchAgents/com.fastclaw.relay.plist` from `scripts/com.fastclaw.relay.plist`, fills in your local paths, loads it with `launchctl`, and starts:

```bash
node scripts/relay.mjs
```

Logs are written to:

- `~/.openclaw/fastclaw/logs/relay.out.log`
- `~/.openclaw/fastclaw/logs/relay.err.log`

To remove the service:

```bash
./scripts/uninstall-service.sh
```

## Security

- Open source — audit the code yourself
- Gateway token never leaves your machine
- Only message content is synced (no keys, no config)
- Pairing codes expire after 5 minutes
- All Convex traffic is TLS-encrypted

## License

MIT
