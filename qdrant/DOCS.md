# Home Assistant Community Add-on: Qdrant

## Installation

The installation of this add-on is pretty straightforward and not different in comparison to installing any other Home Assistant add-on.

1.  Start the "Qdrant" add-on.
2.  Check the logs of "Qdrant" to see if everything went well.

After starting the add-on, Qdrant is available on port `6333` (HTTP API) and `6334` (gRPC API) of your Home Assistant instance.

## Configuration

The add-on is **pre-configured** out of the box. There is no server configuration file exposed to the user by default; the add-on manages a minimal Qdrant configuration under the `/data/qdrant` folder automatically.

### Option: `log_level`

The `log_level` option controls the level of log output by the add-on and can be changed to be more or less verbose, which might be useful when you are dealing with an unknown issue. Possible values are:

*   `trace`: Show every detail, like all called internal functions.
*   `debug`: Shows detailed debug information.
*   `info`: Normal (usually) interesting events.
*   `warning`: Exceptional occurrences that are not errors.
*   `error`: Runtime errors that do not require immediate action.
*   `fatal`: Something went terribly wrong. Add-on becomes unusable.

Please note that each level automatically includes log messages from a more severe level, e.g., `debug` also shows `info` messages. By default, the `log_level` is set to `info`, which is the recommended setting unless you are troubleshooting.

### Option: `admin_password`

The `admin_password` option sets a password that protects the Qdrant APIs (REST, gRPC and the Web UI). Once set, clients must authenticate with this password as an API key.

To use the Qdrant Python client with a password set:

``` python
from qdrant_client import Qdrant
client = Qdrant(url="http://<your-homeassistant-ip>:6333", api_key="<admin_password>")
```

**Note:** If you leave `admin_password` empty, Qdrant runs without authentication. We recommend setting a password when the add-on is reachable from untrusted networks.

### Configuration

The Qdrant server configuration is managed as a file on your Home Assistant configuration folder:

`/homeassistant/addons/qdrant/production.yaml`

On first start the add-on copies a default configuration there, which you can edit directly (for example with Visual Studio Code). For a reference of all available options, see the [Qdrant configuration documentation](https://qdrant.tech/documentation/ops-configuration/configuration/). The add-on still enforces the `admin_password` (via the `QDRANT__SERVICE__API_KEY` environment variable) unless you set `service.api_key` explicitly in your configuration.

**Note:** Remember to restart the add-on after changing this file for the new configuration to take effect.

The `log_level` line is rendered from the add-on **`log_level` option** on every start, so you normally control it from the add-on configuration UI. If you edit it here directly, your change is lost on the next restart because the add-on re-applies the UI option.

## Data folder

The add-on stores all Qdrant data (storage) and its snapshots in the `/data/qdrant` folder. The storage lives in `/data/qdrant/storage` and snapshots in `/data/qdrant/snapshots`. Please ensure this is included in your backup.

## Backups & Permissions

- **Data backup:** Include `/data/qdrant` (storage and snapshots) in your regular backups so data and snapshots are preserved.
- **Secret files:** If you enable `admin_password`, avoid writing it to unprotected files under `/homeassistant/addons/qdrant`; protect any secret files under `/data/qdrant` with `chmod 600`.
- **Editable config vs UI options:** The recommended way to protect secrets is to place them in the add-on `options` so Home Assistant keeps them encrypted rather than only in the editable `production.yaml` under `/homeassistant/addons/qdrant`.

## Using Qdrant

Qdrant provides a REST API (port `6333`) and a gRPC API (port `6334`). You can create collections, upload vectors, and run semantic search. The Python client, for example, connects like this:

``` python
from qdrant_client import Qdrant
client = Qdrant(url="http://<your-homeassistant-ip>:6333")
```

## Architecture notes

- On **amd64** systems the add-on installs Qdrant from the official `amd64` package distributed by Qdrant.
- On **arm64** (e.g. Raspberry Pi) systems the add-on bundles Qdrant's official `arm64` binary distribution.