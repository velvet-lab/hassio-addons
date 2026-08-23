# Home Assistant Community Add-on: SearXNG

## Installation

The installation of this add-on is straightforward and not different in comparison to installing any other Home Assistant add-on.

1.  Start the "SearXNG" add-on.
2.  Check the logs of "SearXNG" to see if everything went well.

After starting the add-on, SearXNG is available on port `8080` of your Home Assistant instance.

## Configuration

The add-on is **pre-configured** out of the box: it uses the sensible defaults shipped with SearXNG. Search engines that are resource- or network-intensive and can fail on a fresh container (`ahmia`, `torch`, `wikidata`) are **removed** by default so the instance starts reliably; you can re-enable them by removing them from `use_default_settings.engines.remove` in your `settings.yml`. SearXNG runs fine without a Redis server; Redis is only needed for the optional limiter / bot protection.

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

The hostname or IP address of the Redis server SearXNG uses for the optional limiter / bot protection, for example the [Valkey add-on](https://github.com/velvet-lab/hassio-addons/tree/main/valkey) in the same system. Redis is **optional** and disabled as long as all three options are empty. As soon as any of `redis_host`, `redis_port` or `redis_password` is set, the other two become **required**.

### Option: `redis_port`

The port of the Redis server (default `6379`).

### Option: `redis_password`

The password of the Redis server, if it requires one (`requirepass` in Redis). Required once Redis is configured.

## Configuration file

The SearXNG server configuration is managed as a file on your Home Assistant configuration folder:

`/homeassistant/addons/searxng/settings.yml`

On first start the add-on copies a default configuration there, which you can edit directly (for example with Visual Studio Code). The default uses `use_default_settings: true`, so you only need to override the options you care about (instance name, engines, UI theme, the limiter, and so on). For a reference of all available options, see the [SearXNG settings documentation](https://docs.searxng.org/admin/settings/index.html).

**Important:** With `use_default_settings: true`, only add the keys/sections you actually want to override. Do **not** add a section with no real keys in it (for example a bare `search:` followed only by comments) — an empty YAML mapping is parsed as `null` and will clobber the defaults, making SearXNG fail to start. Delete the empty section or give it at least one real key.

**Note:** Remember to restart the add-on after changing this file for the new configuration to take effect.

The `server.base_url` in the default `settings.yml` is `http://${SEARXNG_HOST}:${SEARXNG_PORT}/`. At startup the add-on replaces `${SEARXNG_HOST}` with the Home Assistant host address and `${SEARXNG_PORT}` with SearXNG's internal default port `8080`, so the instance is reachable out of the box. If you need a different base URL (e.g. behind a proxy/reverse proxy or with a custom external hostname), put the full URL there and remove the placeholders.

The bot-detection / limiter configuration lives in:

`/homeassistant/addons/searxng/limiter.toml`

Like `settings.yml`, it is created on first start and is user-editable. On every start it is copied into the runtime config folder, so a restart is required after you edit it. For the reference of all options, see the [SearXNG limiter documentation](https://docs.searxng.org/admin/searx.limiter.html).

If you upgraded from an earlier version that shipped an empty-section `settings.yml` (which made SearXNG fail with `Invalid settings.yml`), delete `/homeassistant/addons/searxng/settings.yml` once and restart the add-on — it is re-created from the corrected template.

The add-on generates a random `secret_key` on first start and stores it under `/data/searxng` so sessions and cookies stay valid across restarts. You normally don't need to touch it.

## Redis (limiter / bot protection)  [optional]

Redis is **not required** for SearXNG to run. It is only used for the limiter and bot protection when you enable `server.limiter: true` in your `settings.yml`. Without Redis the instance works normally, just without rate limiting. To use the limiter, set the connection via the add-on options: `redis_host`, `redis_port` and `redis_password`. Redis becomes active as soon as any of the three is set; all three are then required, or leave all empty to keep it disabled.

The resolved connection is written into the rendered `valkey.url` of the runtime `settings.yml` (it becomes `false` when no Redis is configured).

## Using SearXNG

Open `http://<your-homeassistant-ip>:8080` in your browser and start searching. SearXNG aggregates results from many search services without tracking or profiling its users.

SearXNG also exposes a [search API](https://docs.searxng.org/dev/search_api.html) (e.g. `?format=json` or `?format=rss`) that can be called from Home Assistant automations or scripts.

## Data folder

The add-on stores its runtime configuration in the `/data/searxng` folder. Please ensure this is included in your backup.

## Backups & Permissions

- **Data backup:** Include `/data/searxng` in your regular backups so runtime configuration and persisted secrets are preserved.
- **Secret files:** Protect secret files (for example the generated `secret_key`) with strict permissions, e.g. `chmod 600 /data/searxng/<file>`.
- **Editable config vs UI options:** Do not place secrets only in the editable files under `/homeassistant/addons/searxng` — Home Assistant does not encrypt those. Use add-on `options` for secrets so Home Assistant stores them encrypted.
