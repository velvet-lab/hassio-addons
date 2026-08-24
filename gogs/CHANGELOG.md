## 0.14.3

### Add-on

- Initial release of the Gogs add-on
- Bundle the Gogs pre-built Linux binary (`linux_amd64` / `linux_arm64`)
- Use a built-in SQLite database, so no external database service is required
- Add Web UI and Git HTTP access on port 3000
- Persist repositories, the database, sessions and a generated `SECRET_KEY` in `/data/gogs`
- Expose the Gogs server configuration as an editable file under `/homeassistant/addons/gogs/gogs.ini`
- Add a `secret_key` option to override the generated per-install key
- Make the `secret_key` a required option (set a strong random value, e.g. `openssl rand -hex 32` / 64 hex chars); since it is required, the add-on now uses the option value whenever present
- Add optional Redis backing for sessions and cache via `redis_host` / `redis_port` / `redis_password`: Redis becomes active as soon as any of the three is set (then all are required); leave all empty to keep file sessions and in-memory cache
- Point the upload, avatar and Git LFS storage paths at the persistent `/data/gogs/data` folder (attachments, avatars, `repo-avatars`, `lfs-objects`), matching the existing repository and database paths; the `gogs.ini` template now resolves all data paths absolutely via `GOGS_DATA_PATH`
- Add an optional MySQL/MariaDB database backend via the `use_mysql` option: when enabled, Gogs uses the `mysql` service provided by another add-on (connection resolved automatically and the `gogs` database initialized from the bundled Gogs `mysql.sql` script on first start). The resolved database password is written to the central `/homeassistant/secrets.yaml` (key `gogs_db_password`) so it can be looked up in one place; otherwise it stays on the built-in SQLite database
- Control Gogs' own `[log] LEVEL` from the `log_level` option (HA levels are mapped onto Gogs' `Trace`/`Info`/`Warn`/`Error`/`Fatal`)
- Add an optional `external_url` option to set the public-facing URL (e.g. for a reverse proxy); when set it overrides Gogs' `EXTERNAL_URL`, when empty the URL line stays commented out so Gogs uses its built-in default
- Enable Git LFS: bundle the `git-lfs` client, initialize it system-wide (`git lfs install --system`), and route LFS objects to the persistent `/data/gogs/data/lfs-objects` folder (with `tmp/lfs-objects` for upload staging)
- Add an `instance_name` option (default `Gogs`) that is rendered into `BRAND_NAME` and shown in the Gogs web interface (page title / header)

### Gogs

- Address multiple security vulnerabilities, including reverse proxy impersonation, SSRF via webhooks and repository migration, stored XSS, unauthorized access to private repository attachments, privilege escalation, and remote command execution via pull request rebase merges

---

> [!NOTE]
> The add-on version follows the [Gogs version](https://gogs.io/).
> For detailed release notes, see the
> [official Gogs changelog](https://github.com/gogs/gogs/blob/main/CHANGELOG.md).