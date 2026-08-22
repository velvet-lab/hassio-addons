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
- **Optional options go in `schema` ONLY with a trailing `?`, never in `options`.** An optional option (e.g. `secret_key`, `admin_password`) must NOT appear in the `options` list; it belongs only in `schema` as `secret_key: "password?"` / `admin_password: password?`. Home Assistant reads the empty/default value from the `?` marker. Required options with defaults go under `options:`.
- Keep a bundled default template under `rootfs/etc/default/<name>.template` (use the `.template` suffix so it never collides with the actual runtime file, e.g. `openbao.template`, `production.template`). It can be re-created by the add-on if the user deletes their editable copy.
- On first start the `*-pre/run` script does a plain `cp /etc/default/<name>.template /homeassistant/addons/<slug>/<name>` (NOT envsubst), giving the user an editable file (e.g. via VS Code). If deleted, it is re-created on the next start.
- On every start the `*-pre/run` script renders the final config: `envsubst < /homeassistant/addons/<slug>/<name> > /data/<slug>/config/<name>`.
- This requires `gettext-base` installed in the image (for `envsubst`).
- **Internal listen ports are fixed.** The application always listens on `0.0.0.0:<its own default port>` (e.g. Gogs `3000`, OpenBao `8200`, Qdrant `6333`/`6334`, SearXNG `8080`). Do **NOT** read the port with `bashio::addon.port` and write it into the app config — that port is only the *exposed* port in the Home Assistant UI and has nothing to do with where the app should listen. If the app template needs a port, hardcode the application's own default.
- Document the editable file location in `DOCS.md` and note that a restart is required after changes.

  - When documenting network configuration, put the *exposed* port mapping in `README.md`/`DOCS.md` only; never inject `bashio::addon.port` into runtime config files. The Supervisor's exposed port is a mapping only.
  - Add a short, unique build marker string that is logged at container startup (for example `gogs-build-v2-config`). Since `rootfs/` is baked into images via `COPY rootfs /`, script/template changes only take effect after a fresh image rebuild — the build marker helps confirm which image is actually running.

### s6 overlay & technical pitfalls

- s6 **longrun** services are started by the service manager and must use `exec` as the final command (like `exec /usr/sbin/...`), so s6 owns and terminates the process. Do not start the daemon in the background and `wait` on it in the run script.
- s6 **oneshot** services that do work-then-exit (e.g. init or unseal) MUST end with `exit 0`, otherwise s6 treats them as "unable to start service ... command exited N" and aborts the whole container bring-up (`rc.init: fatal: stopping the container`).
- Dependencies between units are declared with empty files in `<service>/dependencies.d/`; bundles reference their members in `<bundle>/contents.d/`; the top-level bundle is referenced by `user/contents.d/<bundle>`.
- Runtime values shared with longrun services are exported via the s6 container environment as **one file per variable** at `/var/run/s6/container_environment/<VARNAME>`. The `with-contenv` mechanism turns each filename into an environment variable available to all services. Do **not** write a single `.env`-style file there.
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

- For services that need a random secret on first start (Gogs `SECRET_KEY`, OpenBao, SearXNG), **generate it once and persist it** (e.g. `/data/<slug>/secret` or similar, `chmod 600`) so sessions/cookies survive restarts; do NOT regenerate on every start.
- **Do NOT use the `cat /dev/urandom | tr -dc '...' | head -c N` pipeline** inside a `$(...)` command substitution — when `head` closes the pipe early, `cat` (or upstream) gets `SIGPIPE` and the pipeline can exit non-zero (observed: exit code 128), which makes an s6 oneshot fail and abort the whole container bring-up. Use `openssl rand -hex 32` instead (available in the base images), with a simple fallback that does not rely on an endless stream (e.g. `date +%s%N | sha256sum`).

## Build and Test

- Validation happens on the Home Assistant Supervisor; there is no unit-test harness in this repository.
- Before proposing changes, verify that `config.yaml` and its `schema` stay consistent, and that referenced files (`Dockerfile`, `build.yaml`, `rootfs/`) exist.
- New add-ons should include a `.devcontainer/` folder (copy from an existing add-on and adapt name/ports/options).
- When editing YAML, preserve the existing option ordering and keep options/schema aligned.

## Doing Work

- Explain what you changed and why, especially when bumps the add-on version or alters user-facing configuration.
- Do not invent changelog entries or product release notes; reference the upstream product's changelog instead.