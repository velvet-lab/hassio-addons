## 0.1.0

### Add-on

- Switch the add-on to semantic versioning (semver): the add-on version no longer tracks the bundled Gogs version and now starts at `0.1.0`. The bundled product version is documented in this changelog and in `DOCS.md`.
- Initial release of the Gogs add-on
- Bundle the Gogs pre-built Linux binary (`linux_amd64` / `linux_arm64`)
- Use a built-in SQLite database, so no external database service is required
- Add Web UI and Git HTTP access on port 3000
- Persist repositories, the database, sessions and a generated `SECRET_KEY` in `/data/gogs`
- Expose the Gogs server configuration as an editable file under `/homeassistant/addons/gogs/app.ini`
- Make the `secret_key` a required option (set a strong random value, e.g. `openssl rand -hex 32` / 64 hex chars)
- Add optional Redis backing for sessions and cache via `redis_host` / `redis_port` / `redis_password`
- Add an optional MySQL/MariaDB database backend via the `use_mysql` option
- Add optional SMTP mail configuration (`email_host` / `email_from` / `email_user` / `email_password`) — required to send registration and notification emails
- Add an optional `external_url` option and an `instance_name` option
- Enable the builtin SSH server on port `22` and Git LFS
- Add a `.devcontainer/` folder for local development against the add-on image

> [!WARNING]
> **Known issue (upstream Gogs 0.14.3):** organization/team *leave* / *join* / *remove* buttons fail with `Bad Request: no CSRF token present`. Not fixable via add-on config; resolved upstream in Gogs 0.15.0 ([#8300](https://github.com/gogs/gogs/pull/8300) removes CSRF). See the **Known Issues** section in `README.md`. On the 0.15.0 bump, verify it is fixed and remove this notice.

### Gogs

- Bundled Gogs version: **0.14.3**
- For detailed release notes, see the official [Gogs changelog](https://github.com/gogs/gogs/blob/main/CHANGELOG.md).

---
> [!NOTE]
> The add-on uses semantic versioning and is independent of the bundled Gogs version.
> This release bundles Gogs 0.14.3.