# Home Assistant Community Add-on: New API

## Installation

The installation of this add-on is pretty straightforward and not different in comparison to installing any other Home Assistant add-on.

1.  Start the "New API" add-on.
2.  Check the logs of "New API" to see if everything went well.

After starting the add-on, New API is available on port `3000` of your Home Assistant instance. The first visit shows the initialization page, which lets you set up the administrator account (only required for the first installation). Upon completion you can log in with the new administrator account.

## Configuration

The add-on is **pre-configured** out of the box with a SQLite database, so it does not require any external database service.

### Option: `log_level`

The `log_level` option controls the level of log output by the add-on and can be changed to be more or less verbose, which might be useful when you are dealing with an unknown issue. Possible values are:

*   `trace`: Show every detail, like all called internal functions.
*   `debug`: Shows detailed debug information.
*   `info`: Normal (usually) interesting events.
*   `warning`: Exceptional occurrences that are not errors.
*   `error`: Runtime errors that do not require immediate action.
*   `fatal`: Something went terribly wrong. Add-on becomes unusable.

Please note that each level automatically includes log messages from a more severe level, e.g., `debug` also shows `info` messages. By default, the `log_level` is set to `info`, which is the recommended setting unless you are troubleshooting.

### Option: `session_secret`

The `session_secret` option is **required**: New API uses it to sign authentication sessions and cookies. Provide a strong, random value, for example with:

```
openssl rand -hex 32
```

This produces a 64-character hexadecimal key (256 bits). Home Assistant stores it encrypted. It must match the `SESSION_SECRET` value in the New API configuration file described below.

### Option: `use_mysql`

When enabled, New API uses the **MySQL/MariaDB** add-on as its database instead of the built-in SQLite database. The connection is resolved automatically from the MariaDB add-on (`host`, `port`, `username`, `password`) and the `new-api` database is created on first start. Enable this when you prefer a server database for production use.

**Note:** Include the MariaDB add-on in your backups; uninstalling it removes your New API data.

### Option: `redis_host`

Host of a Redis-compatible server (for example the **Valkey** add-on). Redis is used by New API for caching, rate limiting and sessions, which improves performance and shares rate limits across instances.

Redis is **optional** and activated only when you fill in `redis_host` **and** `redis_password` (leaving both empty disables Redis). Once one of them is set, the other is required.

### Option: `redis_port`

Port of the Redis-compatible server. Default `6379`.

### Option: `redis_password`

Password for the Redis-compatible server. Required when Redis is activated.

### Option: `redis_username`

Username for the Redis-compatible server (usually `default`). Defaults to `default`.

### Option: `redis_db`

Redis database index to use. This lets multiple add-ons share one Redis server without collisions (for example New API vs SearXNG). Default `0`.

## Configuration

The New API server configuration is managed as a file on your Home Assistant configuration folder:

`/homeassistant/addons/newapi/newapi.env`

On first start the add-on copies a default configuration there, which you can edit directly (for example with Visual Studio Code). This is a standard dotenv (`KEY=VALUE`) file; see the [official New API documentation](https://www.newapi.ai/en/docs/installation/config-maintenance/environment-variables) for the full list of available variables.

The web server listens on `0.0.0.0` on its default port `3000`. The port shown in the add-on configuration is only the *exposed* port that Home Assistant forwards to the add-on; it does not change where New API itself listens.

The `SQL_DSN` and `REDIS_CONN_STRING` variables are rendered from the add-on options above — enabling `use_mysql` fills `SQL_DSN` with the MariaDB connection string, and setting the Redis options fills `REDIS_CONN_STRING`. You can instead set `SQL_DSN` manually in this file (for example to use PostgreSQL or an external MySQL server).

**Note:** Remember to restart the add-on after changing this file for the new configuration to take effect.

## Data folder

The add-on stores the New API data in the `/data/newapi` folder: the SQLite database and log files. Please ensure this is included in your backup.

## Backups & Permissions

- **Data backup:** Include `/data/newapi` in your regular backups to preserve the database and logs.
- **Secret files:** Protect any secret material (for example `SESSION_SECRET` if persisted) with `chmod 600` and restrict access.
- **Editable config vs UI options:** Do not store required secrets only in `/homeassistant/addons/newapi`; prefer add-on `options` for secrets so Home Assistant stores them encrypted.

## First steps

- Set the required `session_secret` option and restart the add-on.
- Open the New API web interface on port `3000` and complete the initialization wizard to create the administrator account.
- Use the web interface to configure channels, models, tokens and quota.