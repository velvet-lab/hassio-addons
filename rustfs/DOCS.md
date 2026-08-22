# Home Assistant Community Add-on: RustFS

## Installation

The installation of this add-on is pretty straightforward and not different in comparison to installing any other Home Assistant add-on.

1.  Start the "RustFS Server" add-on.
2.  Check the logs of "RustFS Server" to see if everything went well.
3.  Open the Web Admin UI at `http://your-homeassistant-ip:9001`.

**Note**: The add-on is **pre-configured** out of the box! There is no need to add/change/update the server connection settings!

## Configuration

The most important settings are configured directly in the add-on options (see below): the access/secret key and the log level. For fine-tuning there is an editable environment file, `rustfs.env`, which is created on first start at:

`/homeassistant/addons/rustfs/rustfs.env`

**Note**: _Remember to restart the add-on when the configuration is changed._

This file is a copy of the bundled template. If you delete it, a fresh copy is re-created on the next start. It carries the advanced server settings (volume path, console, CORS, logging) that are not exposed as UI options:

- `RUSTFS_VOLUMES` — the storage volume path (defaults to `/data/rustfs`).
- `RUSTFS_ADDRESS` / `RUSTFS_CONSOLE_ADDRESS` — the internal listen ports. These are fixed (`:9000` / `:9001`) and unrelated to the exposed ports in the Home Assistant UI.
- `RUSTFS_OBS_LOGGER_LEVEL` — the RustFS log level (`trace`, `debug`, `info`, `warning`, `error`).

## Option: `access_key`

The access key for authenticating with the RustFS service.

## Option: `secret_key`

The secret key for authenticating with the RustFS service. This option is **required** — RustFS rejects the well-known default `rustfsadmin` since 1.0.0-beta.10. Generate a strong, random value, for example with:

```
openssl rand -hex 64
```

This produces a 128-character hexadecimal key (512 bits). Home Assistant stores it encrypted. It must match the `RUSTFS_SECRET_KEY` value in the `rustfs.env` file described above.

## Option: `console_enable`

Enable or disable the RustFS web console. Defaults to `true`.

## Option: `log_level`

The `log_level` option controls the level of log output by the add-on and can be changed to be more or less verbose, which might be useful when you are troubleshooting. Possible values are:

*   `trace`: Show every detail, like all called internal functions.
*   `debug`: Shows detailed debug information.
*   `info`: Normal (usually) interesting events.
*   `warning`: Exceptional occurrences that are not errors.
*   `error`: Runtime errors that do not require immediate action.
*   `fatal`: Something went terribly wrong. Add-on becomes unusable.

Please note that each level automatically includes log messages from a more severe level, e.g., `debug` also shows `info` messages. By default, the `log_level` is set to `info`, which is the recommended setting unless you are troubleshooting.

## Data folder

The add-on will store most of its data in the `/data/rustfs` folder. Please ensure this is included in your backup.

## Backups & Permissions

- **Data backup:** Include `/data/rustfs` in your regular backups to preserve volumes and object storage data.
- **Secret files:** Protect secret files (e.g. `unseal`/`secret_key`) with strict permissions (`chmod 600`) and restrict access to the runtime user.
- **Editable config vs UI options:** Avoid storing required secrets only in editable files under `/homeassistant/addons/rustfs` — Home Assistant does not encrypt those. Use the `secret_key` add-on option so Home Assistant stores it encrypted.

## Reverse Proxy

Run RustFS behind a reverse proxy like Nginx/Apache or others to enable secure access via HTTPS. Redirect traffic from standard ports (443 for HTTPS) to the RustFS service port (9000).
