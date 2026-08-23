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

The `log_level` also controls Gogs' own internal logging (`[log] LEVEL` in the editable `gogs.ini`). The available Gogs levels differ slightly from Home Assistant's, so they are mapped as follows:

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

### Option: `redis_host`

The address of the Redis server used for Gogs sessions and cache. When you run the [Valkey add-on](https://github.com/velvet-lab/hassio-addons/tree/main/valkey) in the same system, use its add-on hostname.

Redis is **optional** and disabled by default. It becomes active as soon as any of `redis_host`, `redis_port` or `redis_password` is set; the other two are then **required**. Leave all three empty to keep Gogs on file-based sessions and the in-memory cache.

### Option: `use_mysql`

Use MySQL/MariaDB as database backend instead of the default SQLite. Set to `true` to use MySQL/MariaDB, or `false` to use SQLite. By default, SQLite is used. If you enable this option, make sure you have a MariaDB add-on installed and configured properly.

> [!NOTE]
> The MariaDB add-on connection is resolved automatically — you do not enter a host, port or credentials here. Gogs will create and use a `gogs` database on that service.

### Option: `external_url`

The public-facing URL of Gogs, used for login redirects and clone URLs. This is normally built automatically from the server's protocol, domain and port. Set it explicitly when Gogs is served through a **reverse proxy** — for example `https://git.example.com/`.

Leave it empty to keep the automatic value.

### Option: `redis_port`

The port of the Redis server (default `6379`). Required once Redis is configured.

### Option: `redis_password`

The password required to authenticate against the Redis server. Home Assistant stores it encrypted. Required once Redis is configured.

> [!NOTE]
> Redis is used here only for Gogs **sessions and cache**, not for the Git/issue data, which stays in the configured database (SQLite by default, or MySQL when `use_mysql` is enabled).

## Configuration

The Gogs server configuration is managed as a file on your Home Assistant configuration folder:

`/homeassistant/addons/gogs/gogs.ini`

On first start the add-on copies a default configuration there, which you can edit directly (for example with Visual Studio Code). Gogs uses the INI format; see the [Gogs configuration documentation](https://gogs.io/docs/use/configuration.html) for all available options.

The web server listens on `0.0.0.0` on its default port `3000`. The port shown in the add-on configuration is only the *exposed* port that Home Assistant forwards to the add-on; it does not change where Gogs itself listens.

The `EXTERNAL_URL` and `DOMAIN` settings control the public URL used for login redirects and clone URLs. If you access the add-on from a different host than the one running Home Assistant (for example through a reverse proxy), set the `external_url` add-on option instead — it overrides `EXTERNAL_URL` here. You can also adjust `EXTERNAL_URL`/`DOMAIN` directly in this file; note that a non-empty `external_url` option always takes precedence over the values in this file.

**Note:** Remember to restart the add-on after changing this file for the new configuration to take effect.

## Data folder

The add-on stores the Gogs data in the `/data/gogs` folder:

- `repositories` — the Git repositories themselves.
- `data/gogs.db` — the SQLite database.
- `data/sessions` — file-based session data (when Redis is not configured).
- `data/attachments` — file attachments uploaded to issues, comments and releases.
- `data/avatars` and `data/repo-avatars` — custom user and repository avatars.
- `data/lfs-objects` — objects stored with Git LFS (with temporary upload data under `data/tmp/`).

All paths in the editable `gogs.ini` that point at this data folder are rendered absolute, so uploads, avatars and LFS objects survive restarts. Please ensure `/data/gogs` is included in your backups.

## Backups & Permissions

- **Data backup:** Include `/data/gogs` in your regular backups to preserve repositories and the database.
- **Secret files:** Protect files containing secrets (sessions, keys) with `chmod 600` and restrict access to the container runtime only.
- **Editable config vs UI options:** Do not store sensitive secrets only in the editable file under `/homeassistant/addons/gogs` — Home Assistant does not encrypt those. Use the `secret_key` add-on option so the value is stored encrypted by Home Assistant.

## First steps

- Set the required `secret_key` option and restart the add-on.
- Open the Gogs web interface on port `3000` and complete the install wizard to create the administrator account.
- Use the web interface to create repositories; clone/push works over HTTP and HTTPS using the `EXTERNAL_URL`.