# Home Assistant Community Add-on: OpenBao

## Installation

The installation of this add-on is pretty straightforward and not different in comparison to installing any other Home Assistant add-on.

1.  Start the "OpenBao" add-on.
2.  Check the logs of "OpenBao" to see if everything went well.

After starting the add-on, OpenBao is available on port `8200` of your Home Assistant instance. The built-in Web UI is served at that address.

## Configuration

The add-on is **pre-configured** out of the box. The most important settings are configured in the add-on options (log level, web console); advanced server settings can be fine-tuned in an editable `openbao.hcl` file (see below).

### Option: `log_level`

The `log_level` option controls the level of log output by the add-on and can be changed to be more or less verbose, which might be useful when you are dealing with an unknown issue. Possible values are:

*   `trace`: Show every detail, like all called internal functions.
*   `debug`: Shows detailed debug information.
*   `info`: Normal (usually) interesting events.
*   `warning`: Exceptional occurrences that are not errors.
*   `error`: Runtime errors that do not require immediate action.
*   `fatal`: Something went terribly wrong. Add-on becomes unusable.

Please note that each level automatically includes log messages from a more severe level, e.g., `debug` also shows `info` messages. By default, the `log_level` is set to `info`, which is the recommended setting unless you are troubleshooting.

### Option: `ui_enable`

Enable or disable the built-in OpenBao web console. Defaults to `true`.

### Configuration

The OpenBao server configuration is managed as a file on your Home Assistant configuration folder:

`/homeassistant/addons/openbao/openbao.hcl`

On first start the add-on copies a default configuration there, which you can edit directly (for example with Visual Studio Code). OpenBao uses the HCL format; see the [OpenBao configuration documentation](https://openbao.org/docs/configuration/) for all available options. The add-on still applies the `log_level` (via `BAO_LOG_LEVEL`), automatic initialization and unsealing.

**Note:** Remember to restart the add-on after changing this file for the new configuration to take effect.

## Data folder

The add-on stores the OpenBao configuration and its file storage backend in the `/data/openbao` folder. Please ensure this is included in your backup.

## First steps

OpenBao is automatically initialized and unsealed by the add-on on first start.

- On first start the add-on initializes OpenBao, stores the unseal key(s) and the root token in `/data/openbao/unseal.keys`, and prints the **root token to the log** so you can copy it.
- On every start the add-on unseals OpenBao automatically using the stored unseal key(s), so the server comes up unsealed and ready to use.

To authenticate, use the root token from the add-on log (the line labelled `OpenBao root token:`) in the built-in Web UI or with the `bao` CLI.

**Note:** The file `/data/openbao/unseal.keys` contains your root token and unseal key(s) in plain text. Treat it as a secret and make sure the `/data` folder is included in and protected by your backups.
