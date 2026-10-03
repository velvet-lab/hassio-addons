# Neo4j Add-on

This add-on packages Neo4j into a Home Assistant add-on. It provides a
default `neo4j.conf` template (copied to `/homeassistant/addons/neo4j/neo4j.conf`)
and starts the server from `/opt/neo4j`.

Configuration:
- `initial_password` (required): initial password for the `neo4j` user.
- `edition`: `community` (default) or `enterprise`.

Data folder: `/data/neo4j` (include in backups).

Notes: The Dockerfile attempts to download a Neo4j tarball from `dist.neo4j.org`.
Adjust `NEO4J_VERSION` or the tarball name if upstream naming changes.
