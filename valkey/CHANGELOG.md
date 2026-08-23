## 9.1.1

### Add-on

- Initial release of the Valkey add-on
- Bundle the official prebuilt Valkey binary artifacts (amd64 and aarch64)
- Register the add-on as the `redis` service, so other add-ons can connect to it as a Redis server
- Add a required `password` option (maps to `requirepass`) to protect the server
- Add a configurable `log_level`
- Expose the Valkey port `6379`
- Provide an editable default Valkey configuration at `/homeassistant/addons/valkey/valkey.conf`

### Valkey

- Fix a use-after-free in TLS connection handling (CVE-2026-56684)
- Fix handling of corrupt stream RDB files (CVE-2026-63639)
- Various bug fixes and performance improvements

---

> [!NOTE]
> The add-on version follows the [Valkey version](https://github.com/valkey-io/valkey).
> For detailed release notes, see the
> [official Valkey changelog](https://github.com/valkey-io/valkey/releases).