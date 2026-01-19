# Home Assistant Community Add-on: SchildiChat

## Installation

The installation of this add-on is pretty straightforward and not different in comparison to installing any other Home Assistant add-on.

1.  Start the "SchildiChat" add-on.
2.  Check the logs of "SchildiChant" to see if everything went well.
3.  Open the Web Admin UI by open Url `http://your-homeassistant-ip:57096`.

**Note**: The add-on is **pre-configured** out of the box! There is no need to add/change/update the server connection settings!

## Configuration

On first start, the add-on will copy its default configuration file to the `/homeassistant/addons/schildichat` folder. You can
then modify the configuration by adding options to the configuration, for example with Visual Studio Code or any text editor.

**Note**: _Remember to restart the add-on when the configuration is changed._

Example add-on configuration:

```
log_level: warning
```

**Note**: _This is just an example, don't copy and paste it! Create your own!_

### Option: `log_level`

The `log_level` option controls the level of log output by the addon and can
be changed to be more or less verbose, which might be useful when you are
dealing with an unknown issue. Possible values are:

*   `trace`: Show every detail, like all called internal functions.
*   `debug`: Shows detailed debug information.
*   `info`: Normal (usually) interesting events.
*   `warning`: Exceptional occurrences that are not errors.
*   `error`: Runtime errors that do not require immediate action.
*   `fatal`: Something went terribly wrong. Add-on becomes unusable.

Please note that each level automatically includes log messages from a
more severe level, e.g., `debug` also shows `info` messages. By default,
the `log_level` is set to `info`, which is the recommended setting unless
you are troubleshooting.

## Data folder

The addon will store most of its configuration in the `/data/conduit` folder. Please ensure this is included in your backup.

## Reverse Proxy

The port Conduit will be running on. You need to set up a reverse proxy in your web server (e.g. apache or nginx), so all requests to /_matrix on port 443 and 8448 will be forwarded to the Conduit instance running on this port
