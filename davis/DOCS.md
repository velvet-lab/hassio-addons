# Home Assistant Community Add-on: Davis

## Installation

The installation of this add-on is pretty straightforward and not different in comparison to installing any other Home Assistant add-on.

1.  Set a custom `admin_login` and `admin_password`
2.  Start the "Davis Server" add-on.
3.  Check the logs of "Davis Server" to see if everything went well.
4.  Open the Web Admin UI by open Url `http://your-homeassistant-ip:8080`.

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

### Option: `log_level`

The `log_level` option controls the level of log output by the addon and can be changed to be more or less verbose, which might be useful when you are dealing with an unknown issue. Possible values are:

*   `trace`: Show every detail, like all called internal functions.
*   `debug`: Shows detailed debug information.
*   `info`: Normal (usually) interesting events.
*   `warning`: Exceptional occurrences that are not errors.
*   `error`: Runtime errors that do not require immediate action.
*   `fatal`: Something went terribly wrong. Add-on becomes unusable.

Please note that each level automatically includes log messages from a more severe level, e.g., `debug` also shows `info` messages. By default, the `log_level` is set to `info`, which is the recommended setting unless you are troubleshooting.

### Option: `app_timezone`

This must comply with the [official list](https://www.php.net/manual/en/timezones.php)

### Option: `birthday_reminder_offset`

For Birthday calendars, what should be the reminder offset ? The default is PT9H, 9am on the day of the event. You must specify a relative duration, as specified in the [RFC 5545 specification](https://www.rfc-editor.org/rfc/rfc5545.html#section-3.3.6). By default, if the var is not set or empty, we use PT9H (9am on the date of the birthday).

### Option: `caldav_enabled`

Enable or disable CalDAV support. Set to `true` to enable calendar synchronization via CalDAV, or `false` to disable it. By default, CalDAV is enabled.

### Option: `carddav_enabled`

Enable or disable CardDAV support. Set to `true` to enable contact synchronization via CardDAV, or `false` to disable it. By default, CardDAV is enabled.

### Option: `webdav_enabled`

Enable or disable WebDAV support. Set to `true` to enable file synchronization via WebDAV, or `false` to disable it. By default, WebDAV is disabled.

### Option: `home_enabled`

By default, home directories are disabled totally. If needed, data for each user will be stored in his own directory and cannot be accessed by other users. By default, home directories are disabled.

### Option: `public_calendars_enabled`

Do we allow calendars to be public. By default, public calendars are enabled. That doesn't mean that all calendars are public by default — it just means that you have an option, upon calendar creation, to set the calendar public (but it's not public by default).

### Option: `admin_login`

The login username for the admin user

### Option: `admin_password`

The login password for the admin user

### Option: `invite_from_address`

The email address that your invites are going to be sent from

### Option: `use_mysql`

Use MySQL/MariaDB as database backend instead of the default SQLite. Set to `true` to use MySQL/MariaDB, or `false` to use SQLite. By default, SQLite is used.

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

The addon will store most of its data in the `/data/davis` folder. Please ensure this is included in your backup.

## Reverse Proxy

Run Davis behind a reverse proxy like Nginx/Apache or others to enable secure access via HTTPS. Redirect traffic from standard ports (443 for HTTPS) to the Davis port (8080).

## Possible Urls to connect

Following Urls can be used to connect to the Davis Web Admin UI:

Base Url to access Davis is `http://your-homeassistant-ip:8080/dav`. Data will be stored in the common folder accessible to all users.

To access user home folder use `http://your-homeassistant-ip:8080/dav/<user>`. Replace `<user>` with the actual username. Data will be stored in the respective user home folder only for that user.