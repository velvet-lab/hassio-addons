## 0.1.0

### Add-on

- Switch the add-on to semantic versioning (semver): the add-on version no longer tracks the bundled OpenBao version and now starts at `0.1.0`. The bundled product version is documented in this changelog and in `DOCS.md`.
- Initial release of the OpenBao add-on
- Install OpenBao via the official Debian package repository
- Add Web UI access on port 8200 (toggleable via the `ui_enable` option)
- Automatically initialize OpenBao on first start and unseal on every start
- Persist unseal keys and root token in `/data/openbao/unseal.keys`
- Print the root token to the add-on log on first start
- Provide an editable default OpenBao configuration at `/homeassistant/addons/openbao/openbao.hcl`
- Add a `.devcontainer/` folder for local development against the add-on image

### OpenBao

- Bundled OpenBao version: **2.6.2**
- For detailed release notes, see the official [OpenBao changelog](https://github.com/openbao/openbao/blob/main/CHANGELOG.md).

---
> [!NOTE]
> The add-on uses semantic versioning and is independent of the bundled OpenBao version.
> This release bundles OpenBao 2.6.2.
