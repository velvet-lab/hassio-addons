# Home Assistant Community Add-on: OpenBao

## Installation

The installation of this add-on is pretty straightforward and not different in comparison to installing any other Home Assistant add-on.

1.  Start the "OpenBao" add-on.
2.  Check the logs of "OpenBao" to see if everything went well.

After starting the add-on, OpenBao is available on port `8200` of your Home Assistant instance. The built-in Web UI is served at that address.

## Configuration

The add-on is **pre-configured** out of the box. There is no server configuration file exposed to the user by default; the add-on manages a minimal OpenBao configuration under the `/data/openbao` folder automatically.

### Option: `log_level`

The `log_level` option controls the level of log output by the add-on and can be changed to be more or less verbose, which might be useful when you are dealing with an unknown issue. Possible values are:

*   `trace`: Show every detail, like all called internal functions.
*   `debug`: Shows detailed debug information.
*   `info`: Normal (usually) interesting events.
*   `warning`: Exceptional occurrences that are not errors.
*   `error`: Runtime errors that do not require immediate action.
*   `fatal`: Something went terribly wrong. Add-on becomes unusable.

Please note that each level automatically includes log messages from a more severe level, e.g., `debug` also shows `info` messages. By default, the `log_level` is set to `info`, which is the recommended setting unless you are troubleshooting.

## Data folder

The add-on stores the OpenBao configuration and its file storage backend in the `/data/openbao` folder. Please ensure this is included in your backup.

## First steps

OpenBao is sealed by default and needs to be initialized and unsealed before it can be used. Use the built-in Web UI or the `bao` CLI inside the add-on container:

1.  Open `http://<your-homeassistant-ip>:8200`.
2.  Follow the initialization wizard to generate the root token and unseal keys.
3.  Store the unseal keys and root token in a safe place.
