# Project Guidelines

## Overview

This repository provides Home Assistant add-ons under `velvet-lab/hassio-addons`. Each add-on lives in its own top-level folder (`davis/`, `dns/`, `mongodb/`, `rustfs/`, ...) and follows the standard Home Assistant add-on layout: `config.yaml`, `Dockerfile`, `build.yaml`, `DOCS.md`, `README.md`, `CHANGELOG.md`, `translations/`, and an optional `rootfs/` with the s6-overlay scripts.

## Code Style

- The add-ons are built with the Home Assistant add-on conventions:
  - `config.yaml` defines `name`, `version`, `stage`, `slug`, `description`, `arch`, `startup`, `homeassistant`, and the `options`/`schema` pair.
  - `build.yaml` references the base images per architecture (e.g. `ghcr.io/home-assistant/amd64-base-debian:trixie`).
  - Shell scripts run under the s6-overlay init system (`rootfs/etc/s6-overlay/s6-rc.d/`).
- Keep configuration and documentation in English.
- Prefer explicit, declarative configuration over adding logic in scripts.

## Conventions

### Add-on versioning

- The `version` in `config.yaml` is the **product version** of the bundled service where the add-on tracks an upstream product (Davis follows the Davis server version, MongoDB runs as 7.0.x). Versions must be bumped whenever the bundled product changes, otherwise Home Assistant will not offer an update.
- For add-ons that track an upstream product, the `CHANGELOG.md` uses this structure per release:

  ```
  ## <product-version>

  ### Add-on
  - ...

  ### <Product>
  - short summary of product changes ...

  ---
  > [!NOTE]
  > The add-on version follows the <product> version.
  > For detailed release notes, see the official changelog.
  ```

- Add-on-specific changes (Dockerfile, s6, AppArmor, config options) go under `### Add-on`.
- Product changes are kept as a short summary only; link to the official product changelog instead of duplicating it.
- `docs/`/`DOCS.md` add-on documentation should stay accurate when options or ports change.

### Keep changelogs current

- Update `CHANGELOG.md` whenever the add-on version changes.
- If the add-on is deprecated, note it in the changelog with a `> [!WARNING]` or `> [!NOTE]` callout.

### Translations

- User-facing strings are defined in `translations/<lang>.yaml` (e.g. `en.yaml`). Keep keys in sync with `config.yaml` options and the documentation.

### User-editable service configuration

For services that expose a server configuration file (OpenBao `.hcl`, Qdrant `production.yaml`, MongoDB `config.conf`, ...), follow the established pattern:

- Declare `map: [ { type: homeassistant_config, read_only: false } ]` in `config.yaml` so the add-on can read/write `/homeassistant`.
- **Do NOT use multiline (multi_line / `|` literal block) strings in `options`** – Home Assistant refuses to load the add-on when an option is a multiline string.
- Keep a bundled default template under `rootfs/etc/default/<name>.template` (use the `.template` suffix so it never collides with the actual runtime file, e.g. `openbao.template`, `production.template`). It can be re-created by the add-on if the user deletes their editable copy.
- On first start the `*-pre/run` script does a plain `cp /etc/default/<name>.template /homeassistant/addons/<slug>/<name>` (NOT envsubst), giving the user an editable file (e.g. via VS Code). If deleted, it is re-created on the next start.
- On every start the `*-pre/run` script renders the final config: `envsubst < /homeassistant/addons/<slug>/<name> > /data/<slug>/config/<name>`.
- This requires `gettext-base` installed in the image (for `envsubst`).
- Ports the user can change in the UI are read at start with `bashio::addon.port '<port>/tcp'` and exported so `envsubst` substitutes the placeholder (e.g. `BAO_PORT`, `QDRANT_HTTP_PORT`).
- Document the editable file location in `DOCS.md` and note that a restart is required after changes.

### s6 overlay & technical pitfalls

- s6 **longrun** services are started by the service manager and must use `exec` as the final command (like `exec /usr/sbin/...`), so s6 owns and terminates the process. Do not start the daemon in the background and `wait` on it in the run script.
- s6 **oneshot** services that do work-then-exit (e.g. init or unseal) MUST end with `exit 0`, otherwise s6 treats them as "unable to start service ... command exited N" and aborts the whole container bring-up (`rc.init: fatal: stopping the container`).
- Dependencies between units are declared with empty files in `<service>/dependencies.d/`; bundles reference their members in `<bundle>/contents.d/`; the top-level bundle is referenced by `user/contents.d/<bundle>`.
- The rootfs is baked into the image via `Dockerfile COPY rootfs /`, so script changes only take effect after a **fresh image rebuild**, not on a plain container restart. Add a unique build marker logged at startup to verify which build is running.
- Prefer the HTTP API (`curl http://127.0.0.1:<port>/...`) over parsing CLI text output for readiness checks; CLI text parsing can hang when a service is uninitialized.

### Line endings

- `rootfs/` shell scripts and config templates must use **LF** line endings (not CRLF), because Linux/s6 fails to run CRLF scripts. CRLF is easy to reintroduce when editing; verify and normalize before committing.

## Build and Test

- Validation happens on the Home Assistant Supervisor; there is no unit-test harness in this repository.
- Before proposing changes, verify that `config.yaml` and its `schema` stay consistent, and that referenced files (`Dockerfile`, `build.yaml`, `rootfs/`) exist.
- When editing YAML, preserve the existing option ordering and keep options/schema aligned.

## Doing Work

- Explain what you changed and why, especially when bumps the add-on version or alters user-facing configuration.
- Do not invent changelog entries or product release notes; reference the upstream product's changelog instead.