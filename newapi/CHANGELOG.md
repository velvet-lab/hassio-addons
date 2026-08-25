## 0.1.0

### Add-on

- Switch the add-on to semantic versioning (semver): the add-on version no longer tracks the bundled New API version and now starts at `0.1.0`. The bundled product version is documented in this changelog and in `DOCS.md`.
- Initial release of the New API add-on
- Bundle the official New API pre-built Linux binary
- Use a built-in SQLite database, so no external database service is required
- Add the New API web interface and OpenAI/Claude/Gemini-compatible API endpoints on port 3000
- Persist the database and log files in `/data/newapi`
- Expose the New API server configuration as an editable `.env` file under `/homeassistant/addons/newapi/newapi.env`
- Make `session_secret` a required option (set a strong random value, e.g. `openssl rand -hex 32` / 64 hex chars); the add-on aborts startup when it is empty
- Add an optional MySQL/MariaDB database backend via the `use_mysql` option
- Add optional Redis-compatible caching via `redis_host` / `redis_port` / `redis_password` (plus `redis_username` / `redis_db`)
- Add a `.devcontainer/` folder for local development against the add-on image

### New API

- Bundled New API version: **1.0.0-rc.25**
- For detailed release notes, see the official [New API changelog](https://github.com/QuantumNous/new-api/releases).

---
> [!NOTE]
> The add-on uses semantic versioning and is independent of the bundled New API version.
> This release bundles New API 1.0.0-rc.25.