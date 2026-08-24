## 1.19.0

### Add-on

- Initial release of the Qdrant add-on
- Install Qdrant from the official distribution:
  - amd64: via the official package
  - arm64: via the official binary distribution
- Add HTTP (6333) and gRPC (6334) API ports
- Add `admin_password` option to protect the Qdrant API and Web UI
- Provide an editable default Qdrant configuration at `/homeassistant/addons/qdrant/production.yaml`
- Add `log_level` option that is applied to the Qdrant configuration (mapped from syslog-style to Qdrant's log levels)
- Fix aarch64 installation: the release tarball is a bare `qdrant` binary (no wrapping directory), so extraction no longer uses `--strip-components=1` (which extracted nothing and left a dangling `/usr/bin/qdrant` symlink)
- Fix configuration loading: Qdrant resolves its config relative to the working directory and never reads a bare `production.yaml` from the binary folder. The add-on now passes `--config-path /etc/qdrant/production.yaml` so the rendered (and user-editable) config is actually loaded.

### Qdrant

- Include TurboQuant 4-bit as a primary vector storage datatype
- Unify memory usage strategy for collection components
- Various performance and reliability improvements

---

> [!NOTE]
> The add-on version follows the [Qdrant version](https://github.com/qdrant/qdrant).
> For detailed release notes, see the
> [official Qdrant changelog](https://github.com/qdrant/qdrant/releases).