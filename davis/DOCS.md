# Home Assistant Community Add-on: Davis

## Installation

The installation of this add-on is pretty straightforward and not different in comparison to installing any other Home Assistant add-on.

1.  Set a custom `admin_login` and `admin_password`
2.  Start the "Davis Server" add-on.
3.  Check the logs of "Davis Server" to see if everything went well.
4.  Open the Web Admin UI at `http://your-homeassistant-ip:43209`.

**Note**: The add-on is **pre-configured** out of the box! There is no need to add/change/update the server connection settings!

## Configuration

**Note**: _Remember to restart the add-on when the configuration is changed._

Example add-on configuration:

```
admin_login: admin
admin_password: admin
log_level: warning
```

**Note**: _This is just an example, don't copy and paste it! Create your own!_

## Configuration file

The most important settings (admin credentials, protocol toggles, mail, database) are configured in the add-on options below. For fine-tuning there is an editable environment file, `davis.env`, created on first start at:

`/homeassistant/addons/davis/davis.env`

**Note**: _Remember to restart the add-on when the configuration is changed._

This file is a copy of the bundled template. If you delete it, a fresh copy is re-created on the next start. The add-on renders it on every start, so your edits take effect on restart.

### Option: `log_level`

The `log_level` option controls the level of log output by the add-on and can be changed to be more or less verbose, which might be useful when you are troubleshooting. Possible values are:

*   `trace`: Show every detail, like all called internal functions.
*   `debug`: Shows detailed debug information.
*   `info`: Normal (usually) interesting events.
*   `warning`: Exceptional occurrences that are not errors.
*   `error`: Runtime errors that do not require immediate action.
*   `fatal`: Something went terribly wrong. Add-on becomes unusable.

Please note that each level automatically includes log messages from a more severe level, e.g., `debug` also shows `info` messages. By default, the `log_level` is set to `info`, which is the recommended setting unless you are troubleshooting.

### Advanced settings (not exposed in the UI)

The following settings are intentionally not configurable via the add-on UI. They can be edited in the rendered environment file `/homeassistant/addons/davis/davis.env` if you need to change them — a restart of the add-on is required after editing.

- `APP_TIMEZONE`: The add-on automatically detects the system timezone on startup (from `/etc/timezone` or the `/etc/localtime` symlink). Change only via `davis.env` when necessary.
- `BIRTHDAY_REMINDER_OFFSET`: Reminder offset for birthday calendars. The application falls back to its internal default (PT9H) when this value is empty.
- `INVITE_FROM_ADDRESS`: Default From: address for outgoing invitations. Leave empty to use the application's default or set a value in `davis.env`.
- `TRUSTED_PROXIES`: Proxy address used for X-Forwarded-* headers. By default the add-on trusts the immediate remote address (`REMOTE_ADDR`).

### Option: `caldav_enabled`

Enable or disable CalDAV support. Set to `true` to enable calendar synchronization via CalDAV, or `false` to disable it. By default, CalDAV is enabled.

### Option: `carddav_enabled`

Enable or disable CardDAV support. Set to `true` to enable contact synchronization via CardDAV, or `false` to disable it. By default, CardDAV is enabled.

### Option: `webdav_enabled`

Enable or disable WebDAV support. Set to `true` to enable file synchronization via WebDAV, or `false` to disable it. By default, WebDAV is disabled.

### Option: `home_enabled`

By default, home directories are disabled. If enabled, data for each user will be stored in their own directory and cannot be accessed by other users.

### Option: `public_calendars_enabled`

Do we allow calendars to be public. By default, public calendars are enabled. That doesn't mean that all calendars are public by default — it just means that you have an option, upon calendar creation, to set the calendar public (but it's not public by default).

### Option: `admin_login`

The login username for the admin user

### Option: `admin_password`

The login password for the admin user

### Option: `use_mysql`

Use MySQL/MariaDB as database backend instead of the default SQLite. Set to `true` to use MySQL/MariaDB, or `false` to use SQLite. By default, SQLite is used. If you enable this option, make sure you have a MariaDB add-on installed and configured properly.

### Option: `mail_host`

The mail server host address

### Option: `mail_port`

The mail server port

### Option: `mail_username`

The mail server username

### Option: `mail_password`

The mail server password

### Option: `trusted_proxies`

Trust the immediate proxy for X-Forwarded-\* headers including HTTPS detection

## Data folder

The add-on will store most of its data in the `/data/davis` folder. Please ensure this is included in your backup.

## Backups & Permissions

- **Data backup:** Include `/data/davis` in your regular backups so configuration, databases and user data are preserved.
- **Secret files:** Any files under `/data/davis` that contain secrets (tokens, keys, unseal keys, etc.) should be protected with strict permissions, e.g. `chmod 600 /data/davis/<file>` and restricted access.
- **Editable config vs UI options:** Do not store sensitive secrets only in the editable files under `/homeassistant/addons/davis` — Home Assistant does not encrypt those. Put required secrets into the add-on `options` so Home Assistant stores them encrypted.

## Reverse Proxy

Run Davis behind a reverse proxy like Nginx/Apache or others to enable secure access via HTTPS. Redirect traffic from standard ports (443 for HTTPS) to the Davis port (8080).

## Possible URLs to connect

The following URLs can be used to connect to the Davis Web Admin UI:

- **Base URL:** `http://your-homeassistant-ip:8080/dav` (data is stored in the common folder accessible to all users).
- **User home folder:** `http://your-homeassistant-ip:8080/dav/<user>` — replace `<user>` with the actual username to access a user's home folder; data for that user is stored in their respective folder only.