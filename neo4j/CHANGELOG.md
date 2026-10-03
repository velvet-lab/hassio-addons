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
