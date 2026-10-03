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
