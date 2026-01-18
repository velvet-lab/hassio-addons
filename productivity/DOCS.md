# Home Assistant Community Add-on: Super Productivity

## Installation

The installation of this add-on is pretty straightforward and not different in comparison to installing any other Home Assistant add-on.

1.  Set a custom `unsplash_key`
2.  Start the "Productivity Server" add-on.
3.  Check the logs of "Productivity Server" to see if everything went well.
4.  Open the Web Admin UI by open Url `http://your-homeassistant-ip:8080`.

**Note**: The add-on is **pre-configured** out of the box! There is no need to add/change/update the server connection settings!

## Configuration

**Note**: _Remember to restart the add-on when the configuration is changed._

Example add-on configuration:

```
unsplash_key: skr-0000000000000000000000000000000
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

### Option: `unsplash_key`

The Unsplash API key to fetch random images for the background. You can get your own API key by creating a developer account at [Unsplash Developers](https://unsplash.com/developers). If you don't provide an API key, a default key will be used, but it's recommended to use your own to avoid rate limiting.

## Data folder

The addon will not store any Data. Backup your data directly in the application

## Reverse Proxy

Run RustFS behind a reverse proxy like Nginx/Apache or others to enable secure access via HTTPS. Redirect traffic from standard ports (443 for HTTPS) to the RustFS service port (9000).
