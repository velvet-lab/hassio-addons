## 0.1.0

### Add-on

- Switch the add-on to semantic versioning (semver): the add-on version no longer tracks the bundled SearXNG version and now starts at `0.1.0`. The bundled product version is documented in this changelog and in `DOCS.md`.
- Initial release of the SearXNG add-on
- Build SearXNG from the current `master` branch (following the official installation script) and serve it with Granian on the Home Assistant Debian base image
- Add a `settings.yml` configuration file that is user-editable under `/homeassistant/addons/searxng/settings.yml`
- Make `secret_key` a **required** add-on option (set a strong random value, e.g. `openssl rand -hex 32` / 64 hex chars); Home Assistant stores it encrypted and the add-on aborts startup when it is empty
- Add an `instance_name` option (default `Privat-SearXNG`) and an optional `external_url` option (e.g. behind a reverse proxy)
- Optionally use your Redis server for the limiter / bot protection via the `redis_*` options (Redis is not required; when unset, `valkey.url` stays disabled)
- Expose the web interface on port `8080`
- Disable the resource/network-intensive default engines `ahmia`, `torch` and `wikidata` out of the box
- Freeze the SearXNG version (`version_frozen`) at build time to avoid runtime `git` lookups
- Ship an editable `limiter.toml` under `/homeassistant/addons/searxng/limiter.toml`
- Add a `.devcontainer/` folder for local development against the add-on image

### SearXNG

- Bundled SearXNG version: **2026.8.21**
- SearXNG is a free metasearch engine which aggregates results from many search services without tracking or profiling its users.
- For detailed release notes, see the [official SearXNG changelog](https://github.com/searxng/searxng/blob/master/CHANGELOG.md).

---
> [!NOTE]
> The add-on uses semantic versioning and is independent of the bundled SearXNG version.
> This release bundles SearXNG 2026.8.21.