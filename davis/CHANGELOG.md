## 0.1.2

### Add-on

- Propagate `log_level` into Davis' own Monolog production logging configuration
- Expose a user-editable `monolog.yaml` template alongside `davis.env`

### Davis

- Bundled Davis version: **5.4.3**
- No product change in this release.

---
> [!NOTE]
> The add-on uses semantic versioning and is independent of the bundled Davis version.
> This release bundles Davis 5.4.3.

## 0.1.1

### Add-on

- Make `log_level` optional and default it to `info` across the add-on services

### Davis

- Bundled Davis version: **5.4.3**
- No product change in this release.

---
> [!NOTE]
> The add-on uses semantic versioning and is independent of the bundled Davis version.
> This release bundles Davis 5.4.3.

## 0.1.0

### Add-on

- Switch the add-on to semantic versioning (semver): the add-on version no longer tracks the bundled Davis version and now starts at `0.1.0`. The bundled product version is documented in this changelog and in `DOCS.md`.
- Initial release of the Davis add-on
- Provide a modern, feature-packed, fully translatable CalDAV, CardDAV and WebDAV server with a web admin dashboard, built on sabre/dav, Symfony 7 and Bootstrap 5
- Expose an editable `davis.env` configuration file at `/homeassistant/addons/davis/davis.env` for fine-tuning (created from a bundled template on first start)
- Add a `.devcontainer/` folder for local development against the add-on image

### Davis

- Bundled Davis version: **5.4.3**
- For detailed release notes, see the official [Davis changelog](https://github.com/tchapi/davis/blob/main/CHANGELOG.md).

---
> [!NOTE]
> The add-on uses semantic versioning and is independent of the bundled Davis version.
> This release bundles Davis 5.4.3.
