# Home Assistant Community Add-on: Gogs

## Installation

The installation of this add-on is pretty straightforward and not different in comparison to installing any other Home Assistant add-on.

1.  Start the "Gogs" add-on.
2.  Check the logs of "Gogs" to see if everything went well.

After starting the add-on, Gogs is available on port `3000` of your Home Assistant instance. The first visit shows the Gogs install wizard, which lets you create the administrator account. Whoever signs up while there are no other users becomes the admin.

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

The `log_level` also controls Gogs' own internal logging (`[log] LEVEL` in the editable `app.ini`). The available Gogs levels differ slightly from Home Assistant's, so they are mapped as follows:

*   `trace` / `debug` → Gogs `Trace`
*   `info` / `notice` → Gogs `Info`
*   `warning` → Gogs `Warn`
*   `error` → Gogs `Error`
*   `fatal` → Gogs `Fatal`

### Option: `secret_key`

The `secret_key` option is **required**: Gogs uses it to encrypt cookie values, two-factor authentication codes and similar sensitive data. Provide a strong, random value — for example generated with:

```
openssl rand -hex 32
```

This produces a 64-character hexadecimal key (256 bits). Home Assistant stores it encrypted. It must match the `[security] SECRET_KEY` value in the editable Gogs configuration file described below.

### Option: `instance_name`

The brand name shown in the Gogs web interface (page title / header). The default is `Gogs`; you can set any name for your installation (e.g. your company or team name). It is rendered into `BRAND_NAME` in the editable `app.ini`.

### Option: `admin_user`

The **required** username of the initial administrator account. Gogs' web setup page is disabled (`INSTALL_LOCK`), so the add-on creates this account automatically on first start via `gogs admin create-user --admin`. The account is only created when it does not already exist; on later starts the option is ignored.

### Option: `admin_email`

The **required** email address of the initial administrator account.

### Option: `admin_password`

The **required** password of the initial administrator account. Provide a strong, random value — for example:

```
openssl rand -base64 24
```

Home Assistant stores it encrypted. This password is only used when the admin account is first created; changing the option later does **not** change an existing account's password.

### Option: `redis_host`

The address of the Redis server used for Gogs sessions and cache. When you run the [Valkey add-on](https://github.com/velvet-lab/hassio-addons/tree/main/valkey) in the same system, use its add-on hostname.

Redis is **optional** and disabled by default. It becomes active as soon as `redis_host` **or** `redis_password` is set; the prefilled `redis_port` / `redis_db` values are no indicator on their own. Once Redis is active, both `redis_host` and `redis_password` are **required**. Leave `redis_host` and `redis_password` empty to keep Gogs on file-based sessions and the in-memory cache.

### Option: `use_mysql`

Use MySQL/MariaDB as database backend instead of the default SQLite. Set to `true` to use MySQL/MariaDB, or `false` to use SQLite. By default, SQLite is used. If you enable this option, make sure you have a MariaDB add-on installed and configured properly.

> [!NOTE]
> The MariaDB add-on connection is resolved automatically — you do not enter a host, port or credentials here. On first start Gogs initializes its `gogs` database (utf8mb4) from the bundled Gogs setup script; existing databases are left untouched on subsequent starts.

### Option: `external_url`

The public-facing URL of Gogs, used for login redirects and clone URLs. Leave it empty to let Gogs use its built-in default (derived from the server's protocol, domain and port). Set it explicitly when Gogs is served through a **reverse proxy** — for example `https://git.example.com/`.

When set, Gogs uses this value verbatim for `EXTERNAL_URL`; when empty, the `EXTERNAL_URL` line in the rendered configuration stays commented out.

### Option: `redis_port`

The port of the Redis server (default `6379`, prefilled in the UI).

### Option: `redis_password`

The password required to authenticate against the Redis server. Home Assistant stores it encrypted. Required once Redis is configured (i.e. once `redis_host` is set).

### Option: `redis_db`

The number of the Redis database to use (default `0`, prefilled in the UI). Give each app that shares a Redis server its **own database number** — for example Gogs `2` and SearXNG `1` — so sessions/cache keys of one app do not collide with another.

> [!NOTE]
> Redis is used here only for Gogs **sessions and cache**, not for the Git/issue data, which stays in the configured database (SQLite by default, or MySQL when `use_mysql` is enabled).

### Option: `email_host`

The SMTP server address and port, e.g. `smtp.example.com:587`. Setting this value **enables** the Gogs mailer (registration/account emails, issue notifications, password reset). Leave it empty to keep the mailer disabled. When `email_host` is set, `email_from`, `email_user` and `email_password` are **required**.

### Option: `email_from`

The sender address used in outgoing mails. May include a display name, e.g. `Gogs <gogs@example.com>`. Required once `email_host` is set.

### Option: `email_user`

The SMTP username used for authentication (usually the full email address). Required once `email_host` is set.

### Option: `email_password`

The SMTP password used for authentication. Home Assistant stores it encrypted. Required once `email_host` is set.

> Advanced SMTP settings (e.g. `SUBJECT_PREFIX`, `HELO_HOSTNAME`, `SKIP_VERIFY`, `USE_CERTIFICATE`, `CERT_FILE`, `KEY_FILE`, `USE_PLAIN_TEXT`, `ADD_PLAIN_TEXT_ALT`) can be edited in the `[email]` section of the editable `app.ini` (see below).

## Configuration

The Gogs server configuration is managed as a file on your Home Assistant configuration folder:

`/homeassistant/addons/gogs/app.ini`

On first start the add-on copies a default configuration there, which you can edit directly (for example with Visual Studio Code). Gogs uses the INI format; see the [Gogs configuration documentation](https://gogs.io/docs/use/configuration.html) for all available options.

At every start this file is rendered (placeholders of the form `${VAR}` are expanded from the add-on's environment) and placed into Gogs' *custom* configuration directory at `/etc/gogs/conf/app.ini`. Gogs finds that file automatically because the add-on sets the `GOGS_CUSTOM` environment variable to `/etc/gogs` — it is the actual `app.ini` that the running Gogs instance reads. The file is named `app.ini` to match what Gogs itself expects (`custom/conf/app.ini`).

The web server listens on `0.0.0.0` on its default port `3000`. The port shown in the add-on configuration is only the *exposed* port that Home Assistant forwards to the add-on; it does not change where Gogs itself listens.

The `EXTERNAL_URL` and `DOMAIN` settings control the public URL used for login redirects and clone URLs. If you access the add-on from a different host than the one running Home Assistant (for example through a reverse proxy), set the `external_url` add-on option instead — it overrides `EXTERNAL_URL` here, and `DOMAIN` is derived from it automatically (the host/port without the `http(s)://` scheme and without any path, e.g. `https://git.example.com/` → `git.example.com`). When `external_url` is unset, `DOMAIN` falls back to `localhost`. You can also adjust `EXTERNAL_URL`/`DOMAIN` directly in this file; note that a non-empty `external_url` option always takes precedence over the values in this file.

**Note:** Remember to restart the add-on after changing this file for the new configuration to take effect.

## Git LFS

Git LFS is active: the add-on bundles the `git-lfs` client and registers it system-wide (`git lfs install --system`) at start, and Gogs serves the Git LFS endpoints automatically. Large files tracked with Git LFS are stored on the server under `/data/gogs/data/lfs-objects` (temporary upload data under `data/tmp/lfs-objects`), as configured in the `[lfs]` section of `app.ini`.

To use Git LFS in your repositories, install the Git LFS client on your machine (`sudo apt install git-lfs`, then `git lfs install`), track the large file patterns with `git lfs track` and commit the resulting `.gitattributes`. See the [Git LFS documentation](https://gogs.io/advancing/git-lfs) for details.

## Git over SSH

Git over SSH is **disabled by default** (`DISABLE_SSH = true` / `START_SSH_SERVER = false` in the editable `app.ini`). To enable it, edit `/homeassistant/addons/gogs/app.ini` and set:

```ini
[server]
DISABLE_SSH = false
START_SSH_SERVER = true
```

then restart the add-on. The builtin SSH server listens on its default port `22`, which is exposed by the add-on (see the `22/tcp` port mapping). `SSH_PORT` / `SSH_LISTEN_PORT` default to `22`; only change them if you also adjust the port mapping accordingly. Gogs uses its **builtin Go SSH server** (not a system `sshd`), which needs the `ssh-keygen` tool for host-key generation and key parsing — the add-on image now bundles `openssh-client` to provide it.

The SSH host keys are stored persistently under `/data/gogs/data/ssh/` (see `APP_DATA_PATH` in `app.ini`), so they stay stable across restarts and your clients do not get a "host key changed" warning. When you add users' public keys in the Gogs web UI, they can clone with `git clone ssh://git@<host>:22/<user>/<repo>.git`.

## Data folder

The add-on stores the Gogs data in the `/data/gogs` folder:

- `repositories` — the Git repositories themselves.
- `data/gogs.db` — the SQLite database.
- `data/sessions` — file-based session data (when Redis is not configured).
- `data/attachments` — file attachments uploaded to issues, comments and releases.
- `data/avatars` and `data/repo-avatars` — custom user and repository avatars.
- `data/lfs-objects` — objects stored with Git LFS (with temporary upload data under `data/tmp/`).
- `data/ssh` — SSH host keys for the builtin SSH server (only when Git over SSH is enabled).

All paths in the editable `app.ini` that point at this data folder are rendered absolute, so uploads, avatars and LFS objects survive restarts. Please ensure `/data/gogs` is included in your backups.

## Backups & Permissions

- **Data backup:** Include `/data/gogs` in your regular backups to preserve repositories and the database.
- **Secret files:** Protect files containing secrets (sessions, keys) with `chmod 600` and restrict access to the container runtime only.
- **Editable config vs UI options:** Do not store sensitive secrets only in the editable file under `/homeassistant/addons/gogs` — Home Assistant does not encrypt those. Use the `secret_key` add-on option so the value is stored encrypted by Home Assistant.

## First steps

- Set the required `secret_key` option, plus the `admin_user` / `admin_email` / `admin_password` options, and restart the add-on.
- The add-on creates the administrator account automatically on first start (and disables the Gogs web setup page).
- Open the Gogs web interface on port `3000` and log in with the admin credentials.
- Use the web interface to create repositories; clone/push works over HTTP and HTTPS using the `EXTERNAL_URL`.