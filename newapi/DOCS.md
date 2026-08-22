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

## Configuration

The New API server configuration is managed as a file on your Home Assistant configuration folder:

`/homeassistant/addons/newapi/newapi.env`

On first start the add-on copies a default configuration there, which you can edit directly (for example with Visual Studio Code). This is a standard dotenv (`KEY=VALUE`) file; see the [official New API documentation](https://www.newapi.ai/en/docs/installation/config-maintenance/environment-variables) for the full list of available variables.

The web server listens on `0.0.0.0` on its default port `3000`. The port shown in the add-on configuration is only the *exposed* port that Home Assistant forwards to the add-on; it does not change where New API itself listens.

To use an external database (PostgreSQL recommended), comment out `SQLITE_PATH` and set `SQL_DSN`. To enable rate limiting and caching for multi-user deployments, configure `REDIS_CONN_STRING`.

**Note:** Remember to restart the add-on after changing this file for the new configuration to take effect.

## Data folder

The add-on stores the New API data in the `/data/newapi` folder: the SQLite database, log files and the generated session secret. Please ensure this is included in your backup.

## First steps

- On first start the add-on generates a `SESSION_SECRET` and persists it.
- Open the New API web interface on port `3000` and complete the initialization wizard to create the administrator account.
- Use the web interface to configure channels, models, tokens and quota.