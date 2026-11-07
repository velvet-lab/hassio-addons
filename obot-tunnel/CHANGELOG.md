## 0.1.0

### Add-on

- Initial release of the Obot Tunnel add-on
- Runs the official `obot tunnel` client under the s6 overlay with an
  outbound-only WebSocket connection to the Obot gateway (`/tunnel/connect`)
- Required options `obot_base_url` (url) and `token` (password, stored
  encrypted by Home Assistant); startup aborts with a clear error when unset
- Optional `log_level` option (default `info`)
- User-editable environment template at
  `/homeassistant/addons/obot-tunnel/obot-tunnel.env`, rendered via `envsubst`
  into the volatile `/etc/obot-tunnel` on every start
- Bundles the self-contained `obot` binary from the official GitHub releases
  for amd64 and arm64

### Obot

- Bundled Obot version: **v0.27.0**
- Initial support for MCP tunnels. See the official
  [MCP tunnels documentation](https://docs.obot.ai/functionality/mcp-tunnels/)
  and changelog for details.

---
> [!NOTE]
> The add-on uses semantic versioning and is independent of the bundled Obot version.
> This release bundles Obot v0.27.0.