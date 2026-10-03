## 0.3.2

### Add-on

- Refactor the s6 startup flow to use a dedicated `neo4j-init` oneshot service between `neo4j-pre` and `neo4j-core`.
- Move pre-start config rendering and `neo4j-admin dbms set-initial-password` logic from `neo4j-pre/run` into `neo4j-init/run`.
- Keep `neo4j-pre/run` focused on environment preparation and file/folder setup.

### Neo4j

- Bundled Neo4j version: **2026.09.0**

---
> [!NOTE]
> The add-on uses semantic versioning and is independent of the bundled Neo4j version.
> This release bundles Neo4j 2026.09.0.

## 0.3.1

### Add-on

- Fix configuration rendering: run `envsubst` in `neo4j-core/run` on every startup (same pattern as other add-ons like Qdrant), so placeholders from `/homeassistant/addons/neo4j/` are always expanded at runtime.
- Fix pre-start rendering for initial password setup: export required `NEO4J_*` variables in `neo4j-pre/run` before calling `envsubst`.

### Neo4j

- Bundled Neo4j version: **2026.09.0**

---
> [!NOTE]
> The add-on uses semantic versioning and is independent of the bundled Neo4j version.
> This release bundles Neo4j 2026.09.0.

## 0.3.0

### Add-on

- Remove the `db_timezone` add-on option from `config.yaml`.
- Set `dbms.db.timezone` to a fixed `SYSTEM` value in the Neo4j configuration template.

### Neo4j

- Bundled Neo4j version: **2026.09.0**

---
> [!NOTE]
> The add-on uses semantic versioning and is independent of the bundled Neo4j version.
> This release bundles Neo4j 2026.09.0.

## 0.2.5

### Add-on

- Expose Neo4j HTTPS (`7473/tcp`) and Bolt (`7687/tcp`) as optional add-on ports in `config.yaml` (disabled by default).
- Derive `server.http.enabled`, `server.https.enabled`, and `server.bolt.enabled` from whether the corresponding add-on port is exposed.

### Neo4j

- Bundled Neo4j version: **2026.09.0**

---
> [!NOTE]
> The add-on uses semantic versioning and is independent of the bundled Neo4j version.
> This release bundles Neo4j 2026.09.0.

## 0.2.3

### Add-on

- Fix startup with Neo4j 2026.x: remove the invalid memory settings `server.memory.off_heap.max_size` and `server.memory.transaction.total.max_size` from the default `neo4j.conf`. Strict configuration validation rejected them. The transaction memory limit is now set via the documented `dbms.memory.transaction.total.max` setting.

### Neo4j

- Bundled Neo4j version: **2026.09.0**
- See the [Neo4j changelog](https://neo4j.com/release-notes/) for details.

---
> [!NOTE]
> The add-on uses semantic versioning and is independent of the bundled Neo4j version.
> This release bundles Neo4j 2026.09.0.

## 0.2.4

### Add-on

- Add optional port-based configuration: `http_port` (default `7474`), `https_port` (optional), and `bolt_port` (optional). The add-on now derives `server.*.enabled` automatically from whether a port is configured — only `http_port` is exposed by default.
- Remove the `fleet_manager_enabled` option (not needed for community edition).
- Add `apoc_enabled` option to optionally download and install the matching APOC plugin for the bundled Neo4j version into `/opt/neo4j/plugins/` at startup. Download failures are logged but do not fail the add-on start.

### Neo4j

- Bundled Neo4j version: **2026.09.0**

---
> [!NOTE]
> The add-on uses semantic versioning and is independent of the bundled Neo4j version.
> This release bundles Neo4j 2026.09.0.

## 0.2.2

### Add-on

- Fix startup with the Neo4j community edition: remove the Enterprise-only settings `server.directories.metrics` and `server.backup.enabled` from the default `neo4j.conf`. Strict configuration validation rejected them, which also broke the initial-password step.
- Fix the start command: `neo4j console` does not support `--home`/`--config` flags. The configuration directory is now passed via the `NEO4J_CONF` environment variable (and `NEO4J_HOME` is exported), so Neo4j loads the rendered config from `/etc/neo4j/neo4j.conf`.

### Neo4j

- Bundled Neo4j version: **2026.09.0**
- See the [Neo4j changelog](https://neo4j.com/release-notes/) for details.

---
> [!NOTE]
> The add-on uses semantic versioning and is independent of the bundled Neo4j version.
> This release bundles Neo4j 2026.09.0.

## 0.2.1

### Add-on

- Fix container startup: remove the redundant `CMD ["/init"]` from the Dockerfile. The base image already sets `ENTRYPOINT ["/init"]`, so the extra `CMD` made the container run `/init /init`, which failed with `/bin/sh: 0: cannot open /init: Permission denied`.
- Fail the build when the Neo4j tarball download fails instead of silently continuing with an empty `/opt/neo4j`.

### Neo4j

- Bundled Neo4j version: **2026.09.0**
- See the [Neo4j changelog](https://neo4j.com/release-notes/) for details.

---
> [!NOTE]
> The add-on uses semantic versioning and is independent of the bundled Neo4j version.
> This release bundles Neo4j 2026.09.0.

## 0.2.0

### Add-on

- Remove the `edition` option; the add-on now always bundles the Neo4j community edition.
- Add a `log_level` option.
- Tune memory settings in the default `neo4j.conf` for a Raspberry Pi 5 with 16 GB RAM (2 GB heap, 2 GB page cache, 512 MB off-heap).
- Add `run` and `metrics` directories to the rendered configuration.
- Fix initial-password logic: use the current `neo4j-admin dbms set-initial-password` command, pass the rendered config via `--additional-config`, and only mark the password as set on success.
- Disable the unused online backup port.

### Neo4j

- Bundled Neo4j version: **2026.09.0**
- See the [Neo4j changelog](https://neo4j.com/release-notes/) for details.

---
> [!NOTE]
> The add-on uses semantic versioning and is independent of the bundled Neo4j version.
> This release bundles Neo4j 2026.09.0.

## 0.1.0

### Add-on

- Initial scaffold of Neo4j add-on

---
