# Home Assistant Community Add-on: Aspire Dashboard

This add-on bundles **Aspire Dashboard 13.6.0**. The add-on version is independent of the bundled application version and follows semantic versioning (see the [CHANGELOG](CHANGELOG.md)).

## Installation

The installation of this add-on is pretty straightforward and not different in comparison to installing any other Home Assistant add-on.

1.  Start the "Aspire Dashboard" add-on.
2.  Check the logs of "Aspire Dashboard" to see if everything went well.

After starting the add-on, Aspire Dashboard is available on these ports of your Home Assistant instance:

- `18888`: Frontend UI
- `18889`: OTLP/gRPC telemetry ingestion
- `18890`: OTLP/HTTP telemetry ingestion
- `18891`: MCP endpoint

## Configuration

The add-on is pre-configured out of the box. The most important settings are configured in the add-on options (authentication token, persistence mode); advanced dashboard settings can be fine-tuned in an editable `appsettings.json` file (see below).

### Option: `log_level`

The `log_level` option controls the level of log output by the add-on and can be changed to be more or less verbose, which might be useful when you are dealing with an unknown issue. Possible values are:

*   `trace`: Show every detail, like all called internal functions.
*   `debug`: Shows detailed debug information.
*   `info`: Normal (usually) interesting events.
*   `warning`: Exceptional occurrences that are not errors.
*   `error`: Runtime errors that do not require immediate action.
*   `fatal`: Something went terribly wrong. Add-on becomes unusable.

Please note that each level automatically includes log messages from a more severe level, e.g., `debug` also shows `info` messages. By default, the `log_level` is set to `info`, which is the recommended setting unless you are troubleshooting.

### Option: `application_name`

Logical application name used by Aspire Dashboard to partition persisted data and scope browser cookies. Keep this value stable to reuse the same persisted telemetry database.

### Option: `persistence_mode`

Sets the add-on persistence behavior:

*   `Temporary`: no persistence, telemetry is removed after shutdown.
*   `Persistent`: reuses a single persistent DB across restarts.

Default is `Temporary`.

Internal mapping to Aspire Dashboard:

*   `Temporary` -> `None`
*   `Persistent` -> `Resume`

### Option: `browser_token` (required)

Sets the browser token used for frontend authentication (`Dashboard:Frontend:AuthMode=BrowserToken`). This value is required and stored encrypted by Home Assistant.

Generate a strong token, for example:

```bash
openssl rand -hex 32
```

This produces a 64-character hex token (256 bits of entropy).

### Option: `otlp_api_key` (optional)

Optional API key for securing OTLP ingestion (`Dashboard:Otlp:AuthMode=ApiKey`).

- If set, incoming OTLP requests must provide `x-otlp-api-key` with this value.
- If empty, OTLP ingestion runs unsecured (`Dashboard:Otlp:AuthMode=Unsecured`).

Generate a strong API key, for example:

```bash
openssl rand -hex 32
```

## Configuration file

The Aspire Dashboard server configuration is managed as a file on your Home Assistant configuration folder:

`/homeassistant/addons/aspire/appsettings.json`

On first start the add-on copies a default configuration there, which you can edit directly (for example with Visual Studio Code). For a full reference of supported settings, see the official Aspire Dashboard configuration documentation:

- https://aspire.dev/de/dashboard/standalone/
- https://aspire.dev/dashboard/configuration/

On each start, all files from `/homeassistant/addons/aspire` are rendered into `/etc/aspire` using environment substitution. The dashboard is started with:

- `ASPIRE_DASHBOARD_CONFIG_FILE_PATH=/etc/aspire/appsettings.json`

**Note:** Remember to restart the add-on after changing files in `/homeassistant/addons/aspire` for the new configuration to take effect.

## Data folder

The add-on stores telemetry persistence data in:

- `/data/aspire/dashboard-data`

This folder should be included in your backup.

## Backups & Permissions

- **Data backup:** Include `/data/aspire/dashboard-data` in your backups.
- **Sensitive telemetry:** Persisted telemetry can contain sensitive values (logs, attributes, environment values). Restrict access to backups and copied data.
- **Editable config vs UI options:** Secrets should be set in add-on options (`browser_token`, optionally `otlp_api_key`) so Home Assistant stores them encrypted.
