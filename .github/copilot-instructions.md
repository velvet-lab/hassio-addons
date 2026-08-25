# Project Guidelines

## Overview

This repository provides Home Assistant add-ons under `velvet-lab/hassio-addons`. Each add-on lives in its own top-level folder (`davis/`, `dns/`, `mongodb/`, `rustfs/`, ...) and follows the standard Home Assistant add-on layout: `config.yaml`, `Dockerfile`, `build.yaml`, `DOCS.md`, `README.md`, `CHANGELOG.md`, `translations/`, an optional `rootfs/` with the s6-overlay scripts, and a `.devcontainer/` folder for local development.

## Code Style

- The add-ons are built with the Home Assistant add-on conventions:
  - `config.yaml` defines `name`, `version`, `stage`, `slug`, `description`, `arch`, `startup`, `homeassistant`, and the `options`/`schema` pair.
  - `build.yaml` references the base images per architecture (e.g. `ghcr.io/home-assistant/amd64-base-debian:trixie`).
  - Shell scripts run under the s6-overlay init system (`rootfs/etc/s6-overlay/s6-rc.d/`).
- Keep configuration and documentation in English.
- Prefer explicit, declarative configuration over adding logic in scripts.

## Conventions

### Add-on versioning

- The `version` in `config.yaml` is the **add-on version** and follows **semantic versioning (semver)**, starting at `0.1.0`. It is **independent** of the bundled product's version. Keep the add-on version stable unless the add-on itself (Dockerfile, s6, AppArmor, config options) changes; bump it per semver rules (patch/minor/major). This lets Home Assistant's update mechanism pick up add-on fixes without requiring a reinstall.
- **Automatically bump the add-on version on every change to an add-on.** Whenever you modify an add-on (Dockerfile, s6 scripts, AppArmor, config options, templates, build files, etc.), increment the `version` in `config.yaml` and add a matching `CHANGELOG.md` entry. Decide the bump type yourself based on the nature of the change:
  - **patch** (`0.1.0` → `0.1.1`): bug fixes, small corrections, dependency/build tweaks without user-facing change.
  - **minor** (`0.1.1` → `0.2.0`): new feature, new config option, or a user-facing enhancement.
  - **major** (`0.2.0` → `1.0.0`): breaking change, incompatible config/schema change, or a significant rework.
  - Only documentation-only edits (README/DOCS/translations wording with no add-on code/config change) do **not** require a version bump.
- The bundled **product version** is **not** reflected in the add-on version; it is recorded in the documentation and the changelog instead (e.g. in `DOCS.md`/`README.md` and the changelog's `### <Product>` section).
- The `CHANGELOG.md` uses this structure per release:

  ```
  ## <add-on-semver-version>

  ### Add-on
  - ...

  ### <Product>
  - Bundled <product> version: **<product-version>**
  - short summary of product changes ...

  ---
  > [!NOTE]
  > The add-on uses semantic versioning and is independent of the bundled <product> version.
  > This release bundles <product> <product-version>.
  ```

- Add-on-specific changes (Dockerfile, s6, AppArmor, config options) go under `### Add-on`.
- Product changes are kept as a short summary only (plus the bundled version); link to the official product changelog instead of duplicating it.
- `docs/`/`DOCS.md` add-on documentation should stay accurate when options or ports change, and should state the bundled product version near the top.

### Keep changelogs current

- Update `CHANGELOG.md` whenever the add-on version changes.
- If the add-on is deprecated, note it in the changelog with a `> [!WARNING]` or `> [!NOTE]` callout.

### Translations

- User-facing strings are defined in `translations/<lang>.yaml` (e.g. `en.yaml`). Keep keys in sync with `config.yaml` options and the documentation.

### User-editable service configuration

For services that expose a server configuration file (OpenBao `.hcl`, Qdrant `production.yaml`, MongoDB `config.conf`, ...), follow the established pattern:

- **UI options vs editable file — the most important / REQUIRED settings MUST be exposed as add-on UI options** (in `config.yaml` `options`/`schema`), e.g. credentials (`access_key`/`secret_key`), `log_level`, or a console/web UI toggle. The editable file under `/homeassistant/addons/<slug>/` exists so users can fine-tune advanced settings; do NOT push every setting into the UI, and do NOT bury required/core settings only in the file. When you are unsure whether a given setting belongs in the UI options or in the editable file, ask the user instead of guessing.
- **Anything that looks like a secret MUST be a UI option** because Home Assistant stores option values in its encrypted vault: passwords, secret keys, API keys, tokens, credentials and similar secrets (e.g. `admin_password`, `secret_key`, `access_key`, `mail_password`) must be in `options`/`schema` (with proper `password`/`password?` type where relevant) so HA encrypts them at rest. Do NOT put secrets into the editable file or the template; Home Assistant cannot encrypt them there, they would sit in plain text in `/homeassistant/addons/<slug>/`.
- Declare `map: [ { type: homeassistant_config, read_only: false } ]` in `config.yaml` so the add-on can read/write `/homeassistant`.
- **Do NOT use multiline (multi_line / `|` literal block) strings in `options`** – Home Assistant refuses to load the add-on when an option is a multiline string.
- **Any option that is NOT optional (no `?` in schema) MUST be in the `options` list.** If there is no sensible default, put `null` (e.g. a required secret is `options: secret_key: null` + `schema: secret_key: password`). Required options with a real default (e.g. `log_level: info`) also go under `options:`.
- **Optional options go in `schema` ONLY with a trailing `?`, never in `options`.** An optional option (e.g. `secret_key`, `admin_password`) must NOT appear in the `options` list; it belongs only in `schema` as `secret_key: "password?"` / `admin_password: "password?"`. Home Assistant reads the empty/default value from the `?` marker.
- **Required options MUST abort startup when unset — never initialize with a default.** For every non-optional option that has no real default (a secret declared as `options: <name>: null` + `schema: <name>: password`), the `*-pre/run` script must check `bashio::var.has_value "$(bashio::config '<name>')"` and `exit 1` with a clear `bashio::log.error` message when it is empty. Do **NOT** fall back to generating/persisting a random secret or any other default for a required option — that diverges from what the user configured and usually breaks sessions/cookies after a restart. (An explicit `exit 1` is used instead of `bashio::config.require.password`, which logs but does not reliably abort an s6 oneshot.) Example:

  ```bash
  if ! bashio::var.has_value "$(bashio::config 'admin_password')"; then
      bashio::log.error "The 'admin_password' option is required but empty."
      bashio::log.error "Set a strong value and restart the add-on."
      exit 1
  fi
  ```

- **Config folder is dissolved; config lives volatile under `/etc/<app>`, user file under `/homeassistant/addons/<app>`.** Do NOT create a separate `/data/<slug>/config` folder and don't use a `conf` short form. The application loads its configuration from the volatile destination `/etc/<app>` (linux-like), which is rendered fresh every container start.
- Keep a bundled default template under `rootfs/etc/default/<app-config-name>` named **exactly as the application names its config file** (no `.template` suffix), so users can relate it to the app's documentation, e.g. `app.ini` (Gogs), `openbao.hcl` (OpenBao), `production.yaml` (Qdrant), `settings.yml` (SearXNG), `valkey.conf` (Valkey), `newapi.env` (NewAPI), `rustfs.env` (RustFS), `davis.env` (Davis). It can be re-created by the add-on if the user deletes their editable copy.
- **Canonical per-add-on config flow:**
  - `*-pre/run` prepares everything and writes ALL runtime values (secrets, ports, resolved service URLs, booleans, ...) into the s6 container environment as **one file per variable** at `/var/run/s6/container_environment/<VARNAME>`. It MUST always also write the three identity/location variables:
    - `APP_NAME` = the app name, e.g. `echo -n "gogs" > /var/run/s6/container_environment/APP_NAME`
    - `APP_CONFIG_SOURCE` = `/homeassistant/addons/<app>` (the user-editable folder)
    - `APP_CONFIG_DEST` = `/etc/<app>` (the volatile runtime destination)
  - `*-pre/run` creates both `APP_CONFIG_SOURCE` and `APP_CONFIG_DEST` dirs, and on first start copies the bundled template into `APP_CONFIG_SOURCE` with a plain `cp` (NOT envsubst) so the user can edit it (e.g. via VS Code). If deleted, it is re-created on the next start.
  - `*-core/run` (longrun) renders **every file** in `APP_CONFIG_SOURCE` into `APP_CONFIG_DEST` with `envsubst`, then starts the app from `APP_CONFIG_DEST`. Render ALL the time — even when the bundled template has no `${VAR}` placeholders, because the user may have added their own references that must be expanded with the full s6 container environment. Example:

    ```bash
    config_source="${APP_CONFIG_SOURCE:-/homeassistant/addons/<app>}"
    config_dest="${APP_CONFIG_DEST:-/etc/<app>}"
    mkdir -p "${config_dest}"
    for file in "${config_source}"/*; do
        name=$(basename "${file}")
        envsubst < "${file}" > "${config_dest}/${name}"
        chmod 644 "${config_dest}/${name}"
    done
    ```

  - **Exception — render in `*-pre/run` only when a pre-side step consumes the rendered output** (e.g. OpenBao's init/temporary server reads the config in `pre`, Davis migrations run in `pre`, RustFS parses its rendered env file in `pre`). In that case render into `APP_CONFIG_DEST` in `pre` and also `export` any variable needed by `envsubst` in the same `pre` script (writing to the container env alone is not enough — it is only loaded at script start).
- `gettext-base` (for `envsubst`) must be installed in the image.
- **Internal listen ports are fixed.** The application always listens on `0.0.0.0:<its own default port>` (e.g. Gogs `3000`, OpenBao `8200`, Qdrant `6333`/`6334`, SearXNG `8080`). Do **NOT** read the port with `bashio::addon.port` and write it into the app config — that port is only the *exposed* port in the Home Assistant UI and has nothing to do with where the app should listen. If the app template needs a port, hardcode the application's own default.
- Document the editable file location in `DOCS.md` and note that a restart is required after changes.

  - When documenting network configuration, put the *exposed* port mapping in `README.md`/`DOCS.md` only; never inject `bashio::addon.port` into runtime config files. The Supervisor's exposed port is a mapping only.
  - Add a short, unique build marker string that is logged at container startup (for example `gogs-build-v2-config`). Since `rootfs/` is baked into images via `COPY rootfs /`, script/template changes only take effect after a fresh image rebuild — the build marker helps confirm which image is actually running.

### s6 overlay & technical pitfalls

- s6 **longrun** services are started by the service manager and must use `exec` as the final command (like `exec /usr/sbin/...`), so s6 owns and terminates the process. Do not start the daemon in the background and `wait` on it in the run script.
- s6 **oneshot** services that do work-then-exit (e.g. init or unseal) MUST end with `exit 0`, otherwise s6 treats them as "unable to start service ... command exited N" and aborts the whole container bring-up (`rc.init: fatal: stopping the container`).
- Dependencies between units are declared with empty files in `<service>/dependencies.d/`; bundles reference their members in `<bundle>/contents.d/`; the top-level bundle is referenced by `user/contents.d/<bundle>`.
- Runtime values shared with longrun services are exported via the s6 container environment as **one file per variable** at `/var/run/s6/container_environment/<VARNAME>`. The `with-contenv` mechanism turns each filename into an environment variable available to all services. Do **not** write a single `.env`-style file there.
- **Required env vars are read with the `:?` idiom — never a silent `:-` fallback.** When a consumer (e.g. `*-core/run` or a migration oneshot) reads a variable that `*-pre/run` must have written (like `APP_CONFIG_SOURCE`, `APP_CONFIG_DEST`, `RUSTFS_VOLUMES`), read it as `${VAR:?VAR is not set (<pre> did not run)}` so a missing/unset variable aborts with a clear message instead of silently substituting an empty value or a hardcoded default. Do NOT use `${VAR:-default}` for values that are required (a fallback would mask a broken pre step). Add `# shellcheck disable=SC2153` above such lines since the vars are injected by `with-contenv`.
- The rootfs is baked into the image via `Dockerfile COPY rootfs /`, so script changes only take effect after a **fresh image rebuild**, not on a plain container restart. Add a unique build marker logged at startup to verify which build is running.
- Prefer the HTTP API (`curl http://127.0.0.1:<port>/...`) over parsing CLI text output for readiness checks; CLI text parsing can hang when a service is uninitialized.

 - On oneshot secrets/config rendering helpers: avoid pipelines that consume endless streams inside command substitution (for example `cat /dev/urandom | tr -dc '...' | head -c N` inside `$(...)`) — these can fail with `SIGPIPE` and cause the oneshot to exit non‑zero. Prefer `openssl rand -hex 32` as the primary generator and a short, deterministic fallback such as `date +%s%N | sha256sum` when `openssl` is unavailable. Persist generated secrets under `/data/<slug>/` with strict permissions (e.g. `chmod 600`) and export them via `/var/run/s6/container_environment/` for runtime consumption.

### Consuming another add-on's service

- When using a service provided by another add-on (MySQL, Redis, MQTT, ...), check availability with `bashio::services.available '<name>'` (the function is `.available`, **not** `.exists`), then read the connection with `bashio::services '<name>' '<key>'` (e.g. `host`, `port`, `password`).
- The consuming add-on must declare `services: [ <name>: want ]` (or `need`) in `config.yaml`. Both sides must match: the **provider** add-on must register that service with `services: [ <name>: provide ]`. A third-party add-on that does not register the service will **not** be discovered automatically via `bashio::services`; in that case read the connection from user-configurable options (`<name>_host`, `<name>_port`, `<name>_password`) instead, and treat the dependency as optional.
- **Read the add-on options first, then fall back to a service.** `bashio::services.available` can return `true` even when the provider does not actually register the service, which makes the next `bashio::services '<name>' 'host'` call fail with a `/services/<name> was not found` error (or return `null`). To avoid that, prefer reading the user-configurable options (`<name>_host`/`<name>_port`/`<name>_password`) as the primary source, and only fall back to `bashio::services` when a service is genuinely present. Guard the service host against `null`/empty before building a connection string.
- Verify from the upstream docs whether a backing store is actually required. For example, SearXNG's limiter/bot protection needs a Valkey/Redis connection, but with `valkey.url: false` (and `limiter: false`) it runs fine entirely without one — keep such dependencies optional.

### Upstream install scripts in Dockerfiles

- Upstream installation scripts (e.g. SearXNG's `utils/searxng.sh install all`) usually target a full OS host: they need `systemd`/`uWSGI`/`nginx`, `sudo`, and create a dedicated service user. They do **not** run as-is inside an s6 container.
- Instead, replicate only the relevant granular steps in the `Dockerfile` — typically the OS `apt` package list (`install packages`) and the Python/virtualenv setup (`install pyenv`) — and adapt the app-server/init to the container (e.g. Granian or uWSGI directly under s6).

### Line endings

- `rootfs/` shell scripts and config templates must use **LF** line endings (not CRLF), because Linux/s6 fails to run CRLF scripts. CRLF is easy to reintroduce when editing; verify and normalize before committing.

 - We provide a helper to normalize line endings on Windows: `.github/write-lf.ps1`. Run it from PowerShell to convert files or folders to LF immediately after creating or modifying `rootfs/` or `.devcontainer/` files. Example:

 ```powershell
 # convert a single file
 .github\write-lf.ps1 .\gogs\rootfs\etc\s6-overlay\gogs-pre\run

 # convert a whole folder recursively
 .github\write-lf.ps1 .\gogs\rootfs
 ```

 - Verify `CRLF=0` for shell scripts before committing; CI or manual checks should fail commits that introduce CRLF in `rootfs/`.

### Devcontainer

Every add-on ships a `.devcontainer/` folder for local development against the actual add-on image:

- `devcontainer.json` mounts the local `.devcontainer/mounts/data` onto `/data` and `.devcontainer/mounts/config` onto `/homeassistant` (both `bind`), builds the add-on `Dockerfile` directly (args `BUILD_FROM`, `BUILD_ARCH`, typically `amd64`), sets `privileged: true`, exposes `forwardPorts` (the add-on's internal ports), and wires the `postCreate`/`postStart`/`postAttach` scripts.
- `mounts/data/options.json` holds the add-on options so `bashio::config '...'` works in the devcontainer (mirror the keys from the add-on `options`/`schema`, e.g. `log_level`). It is linked into place by `post-create.sh`.
- `mounts/data/` may also pre-create the add-on's `/data/<slug>` storage subfolders as empty dirs.
- `mounts/config/` only needs a `.gitkeep`; the first start of the add-on writes `/homeassistant/addons/<slug>/...` to it.
- `post-create.sh`: installs `procps`, then symlinks `/data/options.json` to `/tmp/.bashio/addons.self.options.config.cache` so bashio reads the dev options.
- `post-start.sh`: runs the container via `unshare --pid --fork --kill-child=SIGTERM --mount-proc ... -- /init` so s6 becomes PID 1 and the add-on boots normally.
- `post-attach.sh`: usually an empty script (just the header).
- When adding a new add-on, copy this `devcontainer` folder from an existing add-on (e.g. openbao or qdrant) and adapt: `name`, `forwardPorts`, and `options.json` keys.

### Secrets / keys generated at runtime

- **Anything that looks like a secret goes in the add-on UI options** (Home Assistant encrypts options): passwords, secret keys, tokens, API keys, mail passwords (see the "User-editable service configuration" section). Never store secrets in the editable template under `/homeassistant/addons/<slug>/` — HA does not encrypt them there.
- For services that need a random secret on first start (Gogs `SECRET_KEY`, RustFS `secret_key`, NewAPI `session_secret`, OpenBao, SearXNG), **secrets are REQUIRED add-on options** — never declare them optional. Declare them BOTH in `options` (as `secret_key: null` / `session_secret: null`) AND in `schema:` as `secret_key: password` / `session_secret: password` (no `?`), so the user MUST provide a value; Home Assistant stores it encrypted. Only genuinely conditional secrets (e.g. `mail_password` when mail is disabled, `redis_password` when built-in search works without Redis) may keep the trailing `?`.
- **Document how to generate a key and its length.** In the add-ons `DOCS.md`, tell the user to generate a strong random key, e.g. with `openssl rand -hex 32` (64 hex chars / 256-bit) or `openssl rand -hex 64` (128 hex chars / 512-bit), and state the required/expected length. Do NOT embed weak defaults.
- **Do NOT use the `cat /dev/urandom | tr -dc '...' | head -c N` pipeline** inside a `$(...)` command substitution — when `head` closes the pipe early, `cat` (or upstream) gets `SIGPIPE` and the pipeline can exit non-zero (observed: exit code 128), which makes an s6 oneshot fail and abort the whole container bring-up. Use `openssl rand -hex 32` instead (available in the base images), with a simple fallback that does not rely on an endless stream (e.g. `date +%s%N | sha256sum`).

## Build and Test

- Validation happens on the Home Assistant Supervisor; there is no unit-test harness in this repository.
- Before proposing changes, verify that `config.yaml` and its `schema` stay consistent, and that referenced files (`Dockerfile`, `build.yaml`, `rootfs/`) exist.
- New add-ons should include a `.devcontainer/` folder (copy from an existing add-on and adapt name/ports/options).
- When editing YAML, preserve the existing option ordering and keep options/schema aligned.

## Doing Work

- Explain what you changed and why, especially when bumps the add-on version or alters user-facing configuration.
- Do not invent changelog entries or product release notes; reference the upstream product's changelog instead.