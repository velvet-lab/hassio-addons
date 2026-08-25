# Home Assistant Community Add-on: Gitea

## Installation

The installation of this add-on is pretty straightforward and not different in comparison to installing any other Home Assistant add-on.

1.  Start the "Gitea" add-on.
2.  Check the logs of "Gitea" to see if everything went well.

After starting the add-on, Gitea is available on port `3000` of your Home Assistant instance. The Gitea web setup wizard is disabled (`INSTALL_LOCK`); instead, the first user who **registers** automatically becomes the administrator.

## Configuration

The add-on is **pre-configured** out of the box with a SQLite database, so it does not require any external database service. Optionally, a MySQL/MariaDB service can be used instead — see the `use_mysql` option below.

### Option: `log_level`

The `log_level` option controls the level of log output by the add-on and can be changed to be more or less verbose, which might be useful when you are dealing with an unknown issue. Possible values are:

*   `trace`: Show every detail, like all called internal functions.
*   `debug`: Shows detailed debug information.
*   `info`: Normal (usually) interesting events.
*   `warning`: Exceptional occurrences that are not errors.
*   `error`: Runtime errors that do not require immediate action.
*   `fatal`: Something went terribly wrong. Add-on becomes unusable.

Please note that each level automatically includes log messages from a more severe level, e.g., `debug` also shows `info` messages. By default, the `log_level` is set to `info`, which is the recommended setting unless you are troubleshooting.

The `log_level` also controls Gitea's own internal logging (`[log] LEVEL` in the editable `app.ini`). The available Gitea levels differ slightly from Home Assistant's, so they are mapped as follows:

*   `trace` / `debug` → Gitea `Trace`
*   `info` / `notice` → Gitea `Info`
*   `warning` → Gitea `Warn`
*   `error` → Gitea `Error`
*   `fatal` → Gitea `Fatal`

### Option: `secret_key`

The `secret_key` option is **required**: Gitea uses it to encrypt sensitive data such as cookie values, two-factor authentication secrets and similar. Provide a strong, random value — for example generated with:

```
openssl rand -hex 32
```

This produces a 64-character hexadecimal key (256 bits). Home Assistant stores it encrypted. It must match the `[security] SECRET_KEY` value in the editable Gitea configuration file described below.

### Option: `internal_token`

The `internal_token` option is **required**: Gitea uses it to authenticate internal communication (for example between the web server and Git hooks and LFS). Because the web installer that would normally generate it is disabled, you must provide a value — for example generated with:

```
openssl rand -hex 32
```

Home Assistant stores it encrypted. It must match the `[security] INTERNAL_TOKEN` value in the editable `app.ini`.

### Option: `instance_name`

The brand name shown in the Gitea web interface (page title / header). The default is `Gitea`; you can set any name for your installation (e.g. your company or team name). It is rendered into `APP_NAME` in the editable `app.ini`.

### Option: `redis_host`

The address of the Redis server used for Gitea sessions and cache. When you run the [Valkey add-on](https://github.com/velvet-lab/hassio-addons/tree/main/valkey) in the same system, use its add-on hostname.

Redis is **optional** and disabled by default. It becomes active as soon as `redis_host` **or** `redis_password` is set; the prefilled `redis_port` / `redis_db` values are no indicator on their own. Once Redis is active, both `redis_host` and `redis_password` are **required**. Leave `redis_host` and `redis_password` empty to keep Gitea on file-based sessions and the in-memory cache.

### Option: `use_mysql`

Use MySQL/MariaDB as database backend instead of the default SQLite. Set to `true` to use MySQL/MariaDB, or `false` to use SQLite. By default, SQLite is used. If you enable this option, make sure you have a MariaDB add-on installed and configured properly.

> [!NOTE]
> The MariaDB add-on connection is resolved automatically — you do not enter a host, port or credentials here. On first start Gitea creates its `gitea` database (utf8mb4); existing databases are left untouched on subsequent starts (Gitea runs its own schema migrations on startup).

### Option: `external_url`

The public-facing URL of Gitea, used for login redirects and clone URLs. Leave it empty to let Gitea use its built-in default (derived from the server's protocol, domain and port). Set it explicitly when Gitea is served through a **reverse proxy** — for example `https://git.example.com/`.

When set, Gitea uses this value verbatim for `ROOT_URL`; when empty, the `ROOT_URL` line in the rendered configuration stays commented out.

### Option: `redis_port`

The port of the Redis server (default `6379`, prefilled in the UI).

### Option: `redis_password`

The password required to authenticate against the Redis server. Home Assistant stores it encrypted. Required once Redis is configured (i.e. once `redis_host` is set).

### Option: `redis_db`

The number of the Redis database to use (default `0`, prefilled in the UI). Give each app that shares a Redis server its **own database number** — for example Gitea `2` and SearXNG `1` — so sessions/cache keys of one app do not collide with another.

> [!NOTE]
> Redis is used here only for Gitea **sessions and cache**, not for the Git/issue data, which stays in the configured database (SQLite by default, or MySQL when `use_mysql` is enabled).

### Option: `email_host`

The SMTP server address and port, e.g. `smtp.example.com:587`. **Required** — Gitea needs a working mailer for sending notifications and (optionally) registration mails. If no port is given, it defaults to `587`. Gitea infers the used protocol (`smtp` / `smtps` / `smtp+starttls`) from the port.

### Option: `email_from`

The sender address used in outgoing mails. May include a display name, e.g. `Gitea <gitea@example.com>`. **Required**.

### Option: `email_user`

The SMTP username used for authentication (usually the full email address). **Required**.

### Option: `email_password`

The SMTP password used for authentication. **Required**. Home Assistant stores it encrypted.

> Advanced SMTP settings (e.g. `PROTOCOL`, `HELO_HOSTNAME`, `FORCE_TRUST_SERVER_CERT`, `SUBJECT_PREFIX`, `SEND_AS_PLAIN_TEXT`) can be edited in the `[mailer]` section of the editable `app.ini` (see below).

## Configuration

The Gitea server configuration is managed as a file on your Home Assistant configuration folder:

`/homeassistant/addons/gitea/app.ini`

On first start the add-on copies a default configuration there, which you can edit directly (for example with Visual Studio Code). Gitea uses the INI format; see the [Gitea configuration cheat sheet](https://docs.gitea.com/administration/config-cheat-sheet/) for all available options.

At every start this file is rendered (placeholders of the form `${VAR}` are expanded from the add-on's environment) and placed into Gitea's *custom* configuration directory at `/etc/gitea/conf/app.ini`. Gitea finds that file automatically because the add-on sets the `GITEA_CUSTOM` environment variable to `/etc/gitea` — it is the actual `app.ini` that the running Gitea instance reads.

The web server listens on `0.0.0.0` on its default port `3000`. The port shown in the add-on configuration is only the *exposed* port that Home Assistant forwards to the add-on; it does not change where Gitea itself listens.

The `ROOT_URL` and `DOMAIN` settings control the public URL used for login redirects and clone URLs. If you access the add-on from a different host than the one running Home Assistant (for example through a reverse proxy), set the `external_url` add-on option instead — it overrides `ROOT_URL` here, and `DOMAIN` is derived from it automatically (the host/port without the `http(s)://` scheme and without any path, e.g. `https://git.example.com/` → `git.example.com`). When `external_url` is unset, `DOMAIN` falls back to `localhost`. You can also adjust `ROOT_URL`/`DOMAIN` directly in this file; note that a non-empty `external_url` option always takes precedence over the values in this file.

**Note:** Remember to restart the add-on after changing this file for the new configuration to take effect.

## Git LFS

Git LFS storage is active: the add-on bundles the `git-lfs` client and registers it system-wide (`git lfs install --system`) at start, and Gitea serves the Git LFS endpoints. Large files tracked with Git LFS are stored on the server under `/data/gitea/data/lfs`.

To use Git LFS in your repositories, install the Git LFS client on your machine (`sudo apt install git-lfs`, then `git lfs install`), track the large file patterns with `git lfs track` and commit the resulting `.gitattributes`. See the [Git LFS documentation](https://docs.gitea.com/administration/git-lfs-setup/) for details.

## Git over SSH

Git over SSH uses Gitea's **builtin Go SSH server**: it is **enabled by default** (`START_SSH_SERVER = true` / `DISABLE_SSH = false` in the rendered `app.ini`) and listens on port `22`, which is exposed by the add-on (see the `22/tcp` port mapping). Users can add their public keys in the Gitea web UI and then clone with `git clone ssh://git@<host>:22/<user>/<repo>.git`.

The SSH host keys are stored persistently under `/data/gitea/data/ssh/` (see `APP_DATA_PATH` in `app.ini`), so they stay stable across restarts and your clients do not get a "host key changed" warning.

> [!NOTE]
> To disable Git over SSH, edit `/homeassistant/addons/gitea/app.ini`, set `DISABLE_SSH = true` and `START_SSH_SERVER = false` under `[server]`, then restart the add-on.

## Data folder

The add-on stores the Gitea data in the `/data/gitea` folder:

- `repositories` — the Git repositories themselves.
- `data/gitea.db` — the SQLite database (only when SQLite is used).
- `data/sessions` — file-based session data (when Redis is not configured).
- `data/attachments` — file attachments uploaded to issues, comments and releases.
- `data/avatars` and `data/repo-avatars` — custom user and repository avatars.
- `data/lfs` — objects stored with Git LFS.
- `data/ssh` — SSH host keys for the builtin SSH server.

Please ensure `/data/gitea` is included in your backups.

## Backups & Permissions

- **Data backup:** Include `/data/gitea` in your regular backups to preserve repositories and the database.
- **Editable config vs UI options:** Do not store sensitive secrets only in the editable file under `/homeassistant/addons/gitea` — Home Assistant does not encrypt those. Use the `secret_key` and `internal_token` add-on options so the values are stored encrypted by Home Assistant.

## First steps

- Set the required options (`secret_key`, `internal_token` plus the SMTP mail options `email_host` / `email_from` / `email_user` / `email_password`) and restart the add-on.
- Open the Gitea web interface on port `3000` and **register the first account** — Gitea automatically makes the very first registered user an administrator.
- Use the web interface to create repositories; clone/push works over HTTP and HTTPS using the `ROOT_URL`.
