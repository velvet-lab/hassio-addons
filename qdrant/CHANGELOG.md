## 0.1.0

### Add-on

- Switch the add-on to semantic versioning (semver): the add-on version no longer tracks the bundled Qdrant version and now starts at `0.1.0`. The bundled product version is documented in this changelog and in `DOCS.md`.
- Initial release of the Qdrant add-on
- Install Qdrant from the official binary distribution (same release tarball layout on both architectures)
- Add HTTP (6333) and gRPC (6334) API ports
- Bundle the Qdrant Web UI (dashboard) and serve it via `service.static_content_dir`
- Add `api_key` (required) and `read_only_api_key` (optional) options to protect the Qdrant API and Web UI
- Provide an editable default Qdrant configuration at `/homeassistant/addons/qdrant/production.yaml`
- Add a `log_level` option that is applied to the Qdrant configuration
- Add a `.devcontainer/` folder for local development against the add-on image

### Qdrant

- Bundled Qdrant version: **1.19.0**
- For detailed release notes, see the official [Qdrant changelog](https://github.com/qdrant/qdrant/releases).

---
> [!NOTE]
> The add-on uses semantic versioning and is independent of the bundled Qdrant version.
> This release bundles Qdrant 1.19.0.