# Home Assistant Community Add-on: Obot Tunnel

This add-on bundles **Obot v0.27.0** (tunnel client). The add-on version is independent of the bundled application version and follows semantic versioning (see the [CHANGELOG](CHANGELOG.md)).

## Installation

The installation of this add-on is pretty straightforward and not different in comparison to installing any other Home Assistant add-on.

1.  Start the "Obot Tunnel" add-on.
2.  Check the logs of "Obot Tunnel" to see if everything went well.

## About

**Obot** is an enterprise-grade MCP gateway. *MCP tunnels* let the Obot gateway reach remote HTTP or HTTPS MCP servers that are not directly accessible from the Obot network. An admin deploys and operates the `obot tunnel` client externally, on a machine that can reach both the private MCP server and Obot. The client opens an outbound, authenticated WebSocket connection to Obot's built-in receiving endpoint.

This add-on runs that tunnel client inside Home Assistant, so MCP servers on your home network (or on other add-ons) become reachable for your Obot gateway — without any inbound port on this machine.

Traffic follows this path:

1. The Obot gateway receives a request for a remote MCP server.
2. The remote MCP catalog entry selects an MCP tunnel by its generated ID.
3. Obot sends the HTTP request over that tunnel.
4. The `obot tunnel` process forwards the request to the real MCP server URL and returns its response.

**Note:** MCP tunnels proxy HTTP requests and streaming responses; they are not general-purpose TCP tunnels or VPNs. See the [Obot MCP tunnels documentation](https://docs.obot.ai/functionality/mcp-tunnels/) for details.

## Prerequisites

- An Admin or Owner must create the MCP tunnel in Obot (**MCP Servers > Tunnels**) and configure its allowed URLs.
- The machine running this add-on must be able to reach both the remote MCP server and Obot, and must be allowed to make **outbound** WebSocket connections to Obot (`/tunnel/connect`). No inbound port is needed.
- A reverse proxy in front of Obot must allow WebSocket upgrades and long-lived connections on `/tunnel/connect`.
- The remote catalog entry in Obot must use an exact URL or hostname; URL templates are not supported with tunnels.

## Configuration

### Option: `obot_base_url` (required)

The base URL of your Obot gateway, including the API path, for example:

```text
https://obot.example.com/api
```

The tunnel command converts the Obot URL to the WebSocket endpoint automatically; `https://obot.example.com/api` connects to `wss://obot.example.com/tunnel/connect`.

### Option: `token` (required)

The **complete tunnel secret** of the MCP tunnel. It is created in the Obot UI under **MCP Servers > Tunnels** (Create or Rotate Secret) and shown **only once** — Obot stores only a SHA-256 digest and a shortened preview, the complete secret cannot be retrieved later. Copy it into this option; Home Assistant stores it encrypted in its vault.

If the add-on repeatedly logs `401 Unauthorized`, the secret is incorrect or was rotated in the meantime — rotate it again and update this option.

### Option: `log_level`

The `log_level` option controls the level of log output by the add-on. Possible values are:

*   `trace`: Show every detail, like all called internal functions.
*   `debug`: Shows detailed debug information.
*   `info`: Normal (usually) interesting events.
*   `warning`: Exceptional occurrences that are not errors.
*   `error`: Runtime errors that do not require immediate action.
*   `fatal`: Something went terribly wrong. Add-on becomes unusable.

By default, the `log_level` is set to `info`, which is the recommended setting unless you are troubleshooting.

The tunnel client logs connection changes and each forwarded request; request and response entries share a `request_id`. Headers, query values, and URL fragments are not logged; URL paths are, so do not place secrets in paths.

## Server configuration

The tunnel client environment is managed as a file in your Home Assistant configuration folder:

`/homeassistant/addons/obot-tunnel/obot-tunnel.env`

On first start the add-on copies a default template there, which you can edit directly (for example with Visual Studio Code). Values of the form `${VAR}` are expanded from the add-on environment at runtime.

**Note:** Remember to restart the add-on after changing this file for the changes to take effect.

## Configuring a remote MCP catalog entry

After the tunnel is connected (the add-on logs a successful connection):

1.  In Obot, open **MCP Servers**.
2.  Create or edit a remote MCP catalog entry.
3.  Configure the real MCP endpoint using **Exact URL** or **Hostname** — it must match one of the tunnel's allowed URL rules.
4.  Open **Advanced Configuration** and select this MCP tunnel from the **Tunnel** dropdown, then save.

## Security behavior

- Use HTTPS for Obot in production so the WebSocket uses WSS. The tunnel secret is a **bearer credential**, and forwarded MCP headers may contain credentials.
- A tunnel secret is authorized only to open `GET /tunnel/connect`; it does not grant access to the Obot API or UI.
- Tunneled requests are checked against the current allowed URL rules before forwarding; use the narrowest rules practical (`*` allows any HTTP/HTTPS destination reachable from this machine).
- Same-origin redirects remain inside the tunnel; cross-origin redirect locations are not followed.

## Check live connections

`GET /api/tunnels` on your Obot server returns the tunnels currently connected anywhere in the installation. A tunnel appears only once even with multiple connected clients.

## Architecture notes

- On all architectures the add-on bundles the official self-contained `obot` binary from the GitHub releases, so it runs natively on both amd64 and arm64 (e.g. Raspberry Pi) systems.