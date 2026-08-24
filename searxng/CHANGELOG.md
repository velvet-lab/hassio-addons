## 2026.8.21

### Add-on

- Make the `secret_key` a **required** add-on option (set a strong random value, e.g. `openssl rand -hex 32` / 64 hex chars). Home Assistant stores it encrypted; the add-on aborts startup with a clear error when it is empty instead of generating one on first start (which would diverge from the configured value and break sessions/cookies). The value is rendered into `server.secret_key` via the `SEARXNG_CUSTOM_SECRET` env var (a name SearXNG does not treat specially — SearXNG's built-in `${SEARXNG_SECRET}` would overwrite `server.secret_key`).
- The `base_url` value is now rendered from `SEARXNG_CUSTOM_BASE_URL` (holding `false` or the configured URL) into the template line `base_url: ${SEARXNG_CUSTOM_BASE_URL}`.
- Add an `instance_name` option (default `Privat-SearXNG`) that is rendered into `general.instance_name`; the name is shown in the search page header / starts page.
- Add an optional `external_url` option for the public-facing URL (e.g. behind a reverse proxy). When set, it becomes `server.base_url` verbatim; when empty, `base_url: false` is rendered so SearXNG derives the instance URL from the incoming request. The previous automatic host detection from the supervisor network info was removed.
- Fix: the `base_url` env placeholder is now `SEARXNG_CUSTOM_BASE_URL` (a name SearXNG does not treat specially). SearXNG's built-in `${SEARXNG_BASE_URL}` env override directly overwrites `server.base_url`, which made SearXNG ignore the configured URL. Like the Valkey variable, a unique `SEARXNG_CUSTOM_BASE_URL` is only substituted into our own template, out of SearXNG's built-in environment handling.
- The `valkey` block for the limiter / bot protection is now always rendered (its `url` is `false` when no Redis is configured), matching the resolved `redis_host` / `redis_port` / `redis_password` options.
- Fix: unset optional `redis_*` options are normalized from the bashio `"null"` literal to empty, so a disabled Redis renders `valkey.url: false` instead of an invalid `valkey://null:null/0` URL that crashed SearXNG at start (`Port could not be cast to integer value as 'null'`).
- Fix: the Redis/Valkey connection env var is now `SEARXNG_VALKEY_CUSTOM_URL` (a name SearXNG does not treat specially). The built-in names collide with SearXNG's own env-override mechanism: `${SEARXNG_REDIS_URL}` maps onto the deprecated `redis.url` setting, and `${SEARXNG_VALKEY_URL}` directly overwrites `valkey.url`. Both made SearXNG treat a disabled Redis as configured and crash with `Valkey URL must specify one of the following schemes ...`. A unique `SEARXNG_VALKEY_CUSTOM_URL` is only substituted into our own template, so it stays out of SearXNG's built-in environment handling.
- Add optional `redis_username` (default `default`) and `redis_db` (default `0`) options. The connection URL is built as `valkey://<username>:<password>@host:port/<db>`. The `redis_db` number lets each app that shares a Redis server use its own database and avoid collisions (e.g. SearXNG vs Gogs).
- Preset `redis_port` (`6379`), `redis_username` (`default`) and `redis_db` (`0`) in the add-on options, and change how Redis activation is detected: Redis is now only considered active when `redis_host` or `redis_password` is set (the prefilled values are no longer an indicator). Once active, both `redis_host` and `redis_password` are required.
- Fix: pass `--host 0.0.0.0 --port 8888` explicitly to Granian. Granian does not read `server.bind_address`/`server.port` from `settings.yml` and would otherwise fall back to its built-in default `127.0.0.1:8000`, making the instance unreachable from the home network. The add-on now always listens on its own internal default `0.0.0.0:8888`.
- Remove the now-redundant `server.port` / `server.bind_address` from the `settings.yml` template since Granian receives its bind host/port via CLI args (`--host 0.0.0.0 --port 8888`).
- Fix: Redis connection is now configured entirely through the add-on options (`redis_host` / `redis_port` / `redis_password`). Redis becomes active as soon as any of the three is set (then all are required); with all three empty it stays cleanly disabled. The previous registered-service fallback (Home Assistant Redis service) was removed.
- Fix: the `limiter.toml` is now created user-editable under `/homeassistant/addons/searxng/limiter.toml` and copied into the runtime config folder on every start (like `settings.yml`). Editing and restarting applies your limiter / bot-detection settings and the "missing config file" warning is gone.
- Remove the resource/network-intensive default engines `ahmia`, `torch` and `wikidata` out of the box so the instance starts reliably in a container (re-enable by editing `use_default_settings` in `settings.yml`).
- Freeze the SearXNG version (`version_frozen`) at build time to avoid runtime `git` lookups and the related "not a git repository" errors.

## 2026.8.20

### Add-on

- Initial release of the SearXNG add-on
- Build SearXNG from the current `master` branch (following the official installation script) and serve it with Granian on the Home Assistant Debian base image
- Add a `settings.yml` configuration file that is user-editable under `/homeassistant/addons/searxng/settings.yml`, using the sensible default settings out of the box
- Optionally use your Redis server for the limiter / bot protection (via `redis_host` / `redis_port` / `redis_password` options); Redis is not required
- Generate and persist a random `secret_key` on first start
- Expose the web interface on port `8080`
- Disable the resource/network-intensive default engines `ahmia`, `torch` and `wikidata` out of the box so the add-on starts reliably in a container (re-enable by removing them from `use_default_settings.engines.remove` in `settings.yml`)
- Freeze the SearXNG version (`version_frozen`) at build time so the instance does not query `git` at runtime (avoids noisy "not a git repository" errors)
- Set `server.base_url` from the Home Assistant host and the configured port at start (override the host in `settings.yml` if needed)
- Ship an editable `limiter.toml` under `/homeassistant/addons/searxng/limiter.toml` to configure bot detection and silence the "missing config file" warning

### SearXNG

SearXNG is a free metasearch engine which aggregates results from many search services without tracking or profiling its users.

---

> [!NOTE]
> The add-on version follows the [SearXNG version](https://github.com/searxng/searxng).
> For detailed release notes, see the
> [official SearXNG changelog](https://github.com/searxng/searxng/blob/master/CHANGELOG.md).
