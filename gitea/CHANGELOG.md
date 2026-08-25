## 0.1.2

### Add-on

- Fix Gitea refusing to start as root: since the add-on container runs the whole s6 stack as root (like the sibling add-ons), the rendered `app.ini` now sets `I_AM_BEING_UNSAFE_RUNNING_AS_ROOT = true` in the `[DEFAULT]` section. Gitea aborts with `Gitea is not supposed to be run as root` otherwise. `RUN_USER` stays `root` so it matches Gitea's run-user check (enforced when `INSTALL_LOCK` is set).

### Gitea

- Bundled Gitea version: **1.27.2**
- No product change in this release.

---
> [!NOTE]
> The add-on uses semantic versioning and is independent of the bundled Gitea version.
> This release bundles Gitea 1.27.2.

## 0.1.1

### Add-on

- Fix the AppArmor profile for the Gitea add-on (`apparmor.txt`): the profile was incomplete and ended before the closing `}`, so the supervisor could not load it (`Can't load profile ... exit status 1`) and the add-on failed to install. The file now contains the full ruleset (Gitea/Git/`/data/gitea` access rules plus the docker `ptrace`/`signal` peers) with valid AppArmor syntax.

### Gitea

- Bundled Gitea version: **1.27.2**
- No product change in this release.

---
> [!NOTE]
> The add-on uses semantic versioning and is independent of the bundled Gitea version.
> This release bundles Gitea 1.27.2.

## 0.1.0

### Add-on

- Switch the add-on to semantic versioning (semver): the add-on version no longer tracks the bundled Gitea version and now starts at `0.1.0`. The bundled product version is documented in this changelog and in `DOCS.md`.
- Initial release of the Gitea add-on
- Bundle the Gitea pre-built Linux binary (`linux-amd64` / `linux-arm64`)
- Use a built-in SQLite database, so no external database service is required
- Add Web UI and Git HTTP access on port 3000
- Persist repositories, the database, sessions, avatars, attachments, LFS objects and SSH host keys in `/data/gitea`
- Expose the Gitea server configuration as an editable file under `/homeassistant/addons/gitea/app.ini`
- Add required `secret_key` (Gitea `[security] SECRET_KEY`) and `internal_token` (Gitea `[security] INTERNAL_TOKEN`) options; both are stored encrypted by Home Assistant and must be set to a strong random value (e.g. `openssl rand -hex 32`)
- Disable the Gitea web installer (`INSTALL_LOCK = true`) and enable self-registration (`DISABLE_REGISTRATION = false`): the first user to register automatically becomes the administrator
- Add required SMTP mail options (`email_host` / `email_from` / `email_user` / `email_password`); Gitea's `[mailer]` section is rendered from them and the protocol is inferred from the SMTP port
- Add an optional `external_url` option (e.g. for a reverse proxy); when set it overrides Gitea's `ROOT_URL`, when empty the URL line stays commented out so Gitea uses its built-in default. `DOMAIN` and `SSH_DOMAIN` are derived from it
- Add optional MySQL/MariaDB database backend via the `use_mysql` option: when enabled, Gitea uses the `mysql` service provided by another add-on (connection resolved automatically and the `gitea` database created on first start); otherwise it stays on the built-in SQLite database
- Add optional Redis backing for sessions and cache via `redis_host` / `redis_port` / `redis_password`: Redis becomes active as soon as any of the three is set (then all are required); leave all empty to keep file sessions and in-memory cache
- Add a `redis_db` option (default `0`, prefilled in the UI) so each app that shares a Redis server can use its own database and avoid collisions (e.g. Gitea vs SearXNG)
- Add an `instance_name` option (default `Gitea`) that is rendered into `APP_NAME` and shown in the Gitea web interface
- Control Gitea's own `[log] LEVEL` from the `log_level` option (HA levels are mapped onto Gitea's `Trace`/`Info`/`Warn`/`Error`/`Fatal`)
- Enable the builtin SSH server by default (`START_SSH_SERVER = true`, `DISABLE_SSH = false`, port `22`); SSH host keys are stored under `/data/gitea/data/ssh` so they stay stable across restarts
- Enable Git LFS: bundle the `git-lfs` client, initialize it system-wide (`git lfs install --system`), and route LFS objects to the persistent `/data/gitea/data/lfs` folder
- Add a `.devcontainer/` folder for local development against the add-on image

### Gitea

- Bundled Gitea version: **1.27.2**
- Gitea is a painless, self-hosted Git service written in Go (a community fork of Gogs).
- For detailed release notes, see the official [Gitea changelog](https://blog.gitea.com/).

---
> [!NOTE]
> The add-on uses semantic versioning and is independent of the bundled Gitea version.
> This release bundles Gitea 1.27.2.
