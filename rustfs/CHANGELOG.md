## 0.2.1

### Add-on

- Make `log_level` optional and default it to `info`

### RustFS

- Bundled RustFS version: **1.0.1**
- No product change in this release.

---
> [!NOTE]
> The add-on uses semantic versioning and is independent of the bundled RustFS version.
> This release bundles RustFS 1.0.1.

## 0.2.0

### Add-on

- Update the bundled RustFS binary to the stable 1.0.1 release (was 1.0.0-rc.3)

### RustFS

- Bundled RustFS version: **1.0.1**
- Stable release with numerous fixes and improvements over the 1.0.0-rc.3 release candidate, including S3 protocol hardening (presigned/header-signed SigV4 request validation, oversize PUT rejection, idempotent multipart completion), replication and heal convergence fixes, storage/ecstore reliability improvements, and a configurable console URL prefix.
- For detailed release notes, see the [official RustFS changelog](https://github.com/rustfs/rustfs/blob/main/CHANGELOG.md).

---
> [!NOTE]
> The add-on uses semantic versioning and is independent of the bundled RustFS version.
> This release bundles RustFS 1.0.1.

## 0.1.0

### Add-on

- Switch the add-on to semantic versioning (semver): the add-on version no longer tracks the bundled RustFS version and now starts at `0.1.0`. The bundled product version is documented in this changelog and in `DOCS.md`.
- Provide a high-performance, enterprise-grade distributed file system and S3-compatible object storage
- Make `secret_key` (and `access_key`) required add-on options (generate a strong value with `openssl rand -hex 64` / 128 hex chars); the add-on aborts startup when they are empty
- Expose `console_enable` as an add-on option to toggle the web console
- Expose the RustFS configuration as an editable `rustfs.env` file at `/homeassistant/addons/rustfs/rustfs.env`
- Configurable log levels
- Add a `.devcontainer/` folder for local development against the add-on image

### RustFS

- Bundled RustFS version: **1.0.0-rc.3**
- For detailed release notes, see the [official RustFS changelog](https://github.com/rustfs/rustfs/blob/main/CHANGELOG.md).

---
> [!NOTE]
> The add-on uses semantic versioning and is independent of the bundled RustFS version.
> This release bundles RustFS 1.0.0-rc.3.
