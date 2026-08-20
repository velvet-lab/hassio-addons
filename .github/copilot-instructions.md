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

## Build and Test

- Validation happens on the Home Assistant Supervisor; there is no unit-test harness in this repository.
- Before proposing changes, verify that `config.yaml` and its `schema` stay consistent, and that referenced files (`Dockerfile`, `build.yaml`, `rootfs/`) exist.
- When editing YAML, preserve the existing option ordering and keep options/schema aligned.

## Doing Work

- Explain what you changed and why, especially when bumps the add-on version or alters user-facing configuration.
- Do not invent changelog entries or product release notes; reference the upstream product's changelog instead.