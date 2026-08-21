# Home Assistant Community Add-on: SearXNG

## Installation

The installation of this add-on is straightforward and not different in comparison to installing any other Home Assistant add-on.

1.  Start the "SearXNG" add-on.
2.  Check the logs of "SearXNG" to see if everything went well.

After starting the add-on, SearXNG is available on port `8080` of your Home Assistant instance.

## Configuration

The add-on is **pre-configured** out of the box: it uses the sensible defaults shipped with SearXNG (including all available search engines) plus a bundled Valkey server for the limiter / bot protection.

### Option: `log_level`

The `log_level` option controls the level of log output by the add-on and can be changed to be more or less verbose, which might be useful when you are dealing with an unknown issue. Possible values are:

*   `trace`: Show every detail, like all called internal functions.
*   `debug`: Shows detailed debug information.
*   `info`: Normal (usually) interesting events.
*   `warning`: Exceptional occurrences that are not errors.
*   `error`: Runtime errors that do not require immediate action.
*   `fatal`: Something went terribly wrong. Add-on becomes unusable.

Please note that each level automatically includes log messages from a more severe level, e.g., `debug` also shows `info` messages. By default, the `log_level` is set to `info`, which is the recommended setting unless you are troubleshooting.

## Configuration file

The SearXNG server configuration is managed as a file on your Home Assistant configuration folder:

`/homeassistant/addons/searxng/settings.yml`

On first start the add-on copies a default configuration there, which you can edit directly (for example with Visual Studio Code). The default uses `use_default_settings: true`, so you only need to override the options you care about (instance name, engines, UI theme, the limiter, and so on). For a reference of all available options, see the [SearXNG settings documentation](https://docs.searxng.org/admin/settings/index.html).

**Note:** Remember to restart the add-on after changing this file for the new configuration to take effect.

The add-on generates a random `secret_key` on first start and stores it under `/data/searxng` so sessions and cookies stay valid across restarts. You normally don't need to touch it.

## Valkey (limiter / bot protection)

The add-on bundles a Valkey server (`valkey://127.0.0.1:6379/0`) that SearXNG uses for the limiter and bot protection. Since it is included, you can simply set `server.limiter: true` in your `settings.yml` to enable rate limiting without any further setup.

Valkey data lives in `/data/searxng/valkey`.

## Using SearXNG

Open `http://<your-homeassistant-ip>:8080` in your browser and start searching. SearXNG aggregates results from many search services without tracking or profiling its users.

SearXNG also exposes a [search API](https://docs.searxng.org/dev/search_api.html) (e.g. `?format=json` or `?format=rss`) that can be called from Home Assistant automations or scripts.

## Data folder

The add-on stores its runtime configuration and Valkey data in the `/data/searxng` folder. Please ensure this is included in your backup.
