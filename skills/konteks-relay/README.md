# openclaw-skill-konteks

OpenClaw skill that connects your self-hosted OpenClaw instance to the [Konteks](https://konteks.app) iOS app.

## What it does

Relays messages between your local OpenClaw Gateway and the Konteks iOS app via [Convex](https://convex.dev) real-time sync. No port forwarding, no VPN, no Tailscale — just scan a QR code and you're connected.

## Install

```bash
clawhub install konteks-relay
```

## Pair

```bash
openclaw konteks pair
```

Scan the QR code from the Konteks iOS app. That's it.

## How it works

```
Your OpenClaw (local) ←WS→ konteks-relay ←Convex→ Konteks App (anywhere)
```

Both sides connect **outbound** to Convex — no firewall configuration needed.

## Security

- Open source — audit the code yourself
- Gateway token never leaves your machine
- Only message content is synced (no keys, no config)
- Pairing codes expire after 5 minutes
- All Convex traffic is TLS-encrypted

## License

MIT
