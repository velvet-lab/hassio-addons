## 1.0.0-rc.25

### Add-on

- Initial release of the New API add-on
- Bundle the official New API pre-built Linux binary (`new-api-vX` / `new-api-arm64-vX`)
- Use a built-in SQLite database, so no external database service is required
- Add the New API web interface and OpenAI/Claude/Gemini-compatible API endpoints on port 3000
- Persist the database and log files in `/data/newapi`
- Expose the New API server configuration as an editable `.env` file under `/homeassistant/addons/newapi/newapi.env`
- Add a `session_secret` option to override the generated per-install key
- Make the `session_secret` a required option (set a strong random value, e.g. `openssl rand -hex 32` / 64 hex chars); the add-on aborts startup when it is empty instead of generating a persisted secret

### New API

- Channel testing and gateway administration gain safer workflows, user/group-aware overrides, and request-field passthrough controls
- Improved provider compatibility, Responses API accounting, and recharge/quota reliability

---

> [!NOTE]
> The add-on version follows the New API version.
> For detailed release notes, see the
> [official New API changelog](https://github.com/QuantumNous/new-api/releases).