# Neo4j Add-on

This add-on packages Neo4j into a Home Assistant add-on. It provides a
default `neo4j.conf` template (copied to `/homeassistant/addons/neo4j/neo4j.conf`)
and starts the server from `/opt/neo4j`.

Bundled Neo4j version: **2026.09.0** (community edition).

## Configuration

- `initial_password` (required): initial password for the `neo4j` user.
  Generate a strong one, e.g. with `openssl rand -hex 32`. It is set on the
  first start only; afterwards change it via the Neo4j UI or Cypher.
- `log_level`: controls the add-on log verbosity.

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
