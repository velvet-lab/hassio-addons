## 1.0.0-rc.3

### Add-on

- Update the RustFS add-on to version 1.0.0-rc.3
- Reintroduce `access_key` / `secret_key` as add-on options (set in the Home Assistant UI)
- Make `secret_key` a required option (generate a strong value with `openssl rand -hex 64` / 128 hex chars); the add-on aborts startup when it is empty instead of falling back to a generated, persisted random value
- Expose `console_enable` as an add-on option to toggle the web console

### RustFS

- Update RustFS to the latest release candidate
- For detailed release notes, see the [official RustFS changelog](https://github.com/rustfs/rustfs/blob/main/CHANGELOG.md)

## 1.0.0-rc.2-preview.1

### Add-on

- Update the RustFS add-on to version 1.0.0-rc.2-preview.1
- Configuration is now an editable `rustfs.env` file at `/homeassistant/addons/rustfs/rustfs.env` (mapped via `homeassistant_config`)

### RustFS

- Update RustFS to the latest preview release
- Improve S3 protocol compatibility
- Enhanced web console
- Various stability and performance improvements

## 1.0.0-rc.1

### Add-on

- Initial release candidate
- Configurable log levels
- Configurable access and secret keys

### RustFS

- Add RustFS distributed object storage
- S3 compatible API
- Web-based administration console
- Reverse proxy support

---

> [!NOTE]
> The add-on version follows the
> [RustFS release](https://github.com/rustfs/rustfs/releases).
> For detailed release notes, see the
> [official RustFS changelog](https://github.com/rustfs/rustfs/blob/main/CHANGELOG.md).
