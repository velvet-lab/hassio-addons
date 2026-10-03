# Neo4j Add-on

This add-on packages Neo4j into a Home Assistant add-on. It provides a
default `neo4j.conf` template (copied to `/homeassistant/addons/neo4j/neo4j.conf`)
and starts the server from `/opt/neo4j`.

Bundled Neo4j version: **2026.09.0** (community edition).

## Configuration

- `log_level`: controls the add-on log verbosity.

## Network ports

- `7474/tcp` (HTTP API) is exposed by default.
- `7473/tcp` (HTTPS) is optional and disabled by default.
- `7687/tcp` (Bolt protocol) is required.

When `7473/tcp` is not exposed in the add-on network settings, the HTTPS
connector is disabled automatically.

For Neo4j Browser/Admin access use:

- Browser URL: `http://<homeassistant-ip>:<http-or-https-port>/browser/`
- Default username: `neo4j`
- Default password: `neo4j`
- Connection URL in Browser: `bolt://<homeassistant-ip>:<bolt-port>`

## Memory settings

The default `neo4j.conf` is tuned for a Raspberry Pi 5 with 16 GB RAM:

- JVM heap: 1 GB initial / 2 GB max
- Page cache: 2 GB
- Off-heap: 512 MB
- Transaction total max: 1 GB

Adjust these in `/homeassistant/addons/neo4j/neo4j.conf` if needed. A restart
is required after changes.

## Data

Data folder: `/data/neo4j` (include in backups).

Notes: The Dockerfile attempts to download a Neo4j tarball from `dist.neo4j.org`.
Adjust `NEO4J_VERSION` or the tarball name if upstream naming changes.
