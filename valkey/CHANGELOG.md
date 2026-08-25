## 0.1.0

### Add-on

- Switch the add-on to semantic versioning (semver): the add-on version no longer tracks the bundled Valkey version and now starts at `0.1.0`. The bundled product version is documented in this changelog and in `DOCS.md`.
- Initial release of the Valkey add-on
- Bundle the official prebuilt Valkey binary artifacts (amd64 and aarch64)
- Add a required `password` option (maps to `requirepass`) to protect the server
- Add a configurable `log_level`
- Expose the Valkey port `6379`
- Provide an editable default Valkey configuration at `/homeassistant/addons/valkey/valkey.conf`
- Register Valkey as a `redis` Home Assistant service, so other add-ons and integrations can connect to it as a drop-in Redis server
- Add a `.devcontainer/` folder for local development against the add-on image

### Valkey

- Bundled Valkey version: **9.1.1**
- For detailed release notes, see the [official Valkey changelog](https://github.com/valkey-io/valkey/releases).

---
> [!NOTE]
> The add-on uses semantic versioning and is independent of the bundled Valkey version.
> This release bundles Valkey 9.1.1.