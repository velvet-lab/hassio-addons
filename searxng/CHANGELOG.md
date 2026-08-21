## 2026.8.20

## 2026.8.20

### Add-on

- Initial release of the SearXNG add-on
- Build SearXNG from source (pip + Granian) on the Home Assistant Debian base image
- Add a `settings.yml` configuration file that is user-editable under `/homeassistant/addons/searxng/settings.yml`, using the sensible default settings out of the box
- Use your Redis server for the limiter / bot protection (via a Home Assistant Redis service or the `redis_host` / `redis_port` / `redis_password` options)
- Generate and persist a random `secret_key` on first start
- Expose the web interface on port `8080`

### SearXNG

SearXNG is a free metasearch engine which aggregates results from many search services without tracking or profiling its users.

---

> [!NOTE]
> The add-on version follows the [SearXNG version](https://github.com/searxng/searxng).
> For detailed release notes, see the
> [official SearXNG changelog](https://github.com/searxng/searxng/blob/master/CHANGELOG.md).
