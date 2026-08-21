# Home Assistant Community Add-on: SearXNG

## Installation

The installation of this add-on is straightforward and not different in comparison to installing any other Home Assistant add-on.

1.  Start the "SearXNG" add-on.
2.  Check the logs of "SearXNG" to see if everything went well.

After starting the add-on, SearXNG is available on port `8080` of your Home Assistant instance.

## Configuration

The add-on is **pre-configured** out of the box: it uses the sensible defaults shipped with SearXNG (including all available search engines). SearXNG runs fine without a Redis server; Redis is only needed for the optional limiter / bot protection.

### Option: `log_level`

The `log_level` option controls the level of log output by the add-on and can be changed to be more or less verbose, which might be useful when you are dealing with an unknown issue. Possible values are:

*   `trace`: Show every detail, like all called internal functions.
*   `debug`: Shows detailed debug information.
*   `info`: Normal (usually) interesting events.
*   `warning`: Exceptional occurrences that are not errors.
*   `error`: Runtime errors that do not require immediate action.
*   `fatal`: Something went terribly wrong. Add-on becomes unusable.

Please note that each level automatically includes log messages from a more severe level, e.g., `debug` also shows `info` messages. By default, the `log_level` is set to `info`, which is the recommended setting unless you are troubleshooting.

### Option: `redis_host`

The hostname or IP address of the Redis server SearXNG uses for the optional limiter / bot protection. If a Redis service is provided by another add-on, that service is preferred and this option is ignored. Leave it empty to run without Redis (the limiter stays off).

### Option: `redis_port`

The port of the Redis server. The default is `6379`.

### Option: `redis_password`

Set this to the password of the Redis server, if it requires one (`requirepass` in Redis). Leave it empty if your Redis server runs without authentication.

## Configuration file

The SearXNG server configuration is managed as a file on your Home Assistant configuration folder:

`/homeassistant/addons/searxng/settings.yml`

On first start the add-on copies a default configuration there, which you can edit directly (for example with Visual Studio Code). The default uses `use_default_settings: true`, so you only need to override the options you care about (instance name, engines, UI theme, the limiter, and so on). For a reference of all available options, see the [SearXNG settings documentation](https://docs.searxng.org/admin/settings/index.html).

**Important:** With `use_default_settings: true`, only add the keys/sections you actually want to override. Do **not** add a section with no real keys in it (for example a bare `search:` followed only by comments) — an empty YAML mapping is parsed as `null` and will clobber the defaults, making SearXNG fail to start. Delete the empty section or give it at least one real key.

**Note:** Remember to restart the add-on after changing this file for the new configuration to take effect.

If you upgraded from an earlier version that shipped an empty-section `settings.yml` (which made SearXNG fail with `Invalid settings.yml`), delete `/homeassistant/addons/searxng/settings.yml` once and restart the add-on — it is re-created from the corrected template.

The add-on generates a random `secret_key` on first start and stores it under `/data/searxng` so sessions and cookies stay valid across restarts. You normally don't need to touch it.

## Redis (limiter / bot protection)  [optional]

Redis is **not required** for SearXNG to run. It is only used for the limiter and bot protection when you enable `server.limiter: true` in your `settings.yml`. Without Redis the instance works normally, just without rate limiting. If you want the limiter, the connection is set up in one of two ways:

* **Home Assistant Redis service**: If an installed add-on provides a `redis` service (for example a Redis add-on that registers one), the add-on picks it up automatically via `bashio::services redis`.
* **Add-on options**: Otherwise, set `redis_host`, `redis_port` and (if needed) `redis_password` to point at your Redis server.

The resolved connection is written into the rendered `valkey.url` of the runtime `settings.yml` (it becomes `false` when no Redis is configured).

**Note on the Redis add-on:** the [Redis add-on by fabio-garavini](https://github.com/fabio-garavini/hassio-addons/tree/main/redis) does not register a Home Assistant Redis service, so when using it you configure the connection via the `redis_host` / `redis_port` / `redis_password` options above. Make sure Redis is reachable from this add-on.

## Using SearXNG

Open `http://<your-homeassistant-ip>:8080` in your browser and start searching. SearXNG aggregates results from many search services without tracking or profiling its users.

SearXNG also exposes a [search API](https://docs.searxng.org/dev/search_api.html) (e.g. `?format=json` or `?format=rss`) that can be called from Home Assistant automations or scripts.

## Data folder

The add-on stores its runtime configuration in the `/data/searxng` folder. Please ensure this is included in your backup.
