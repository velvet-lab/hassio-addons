# Home Assistant Add-on: Neo4j

This add-on bundles a self-hosted Neo4j database.

Ports:
- HTTP API: 7474
- HTTPS: 7473 (optional, disabled by default)
- Bolt: 7687 (required)

Neo4j Browser/Admin access:
- Open: `http://<homeassistant-ip>:<http-or-https-port>/browser/`
- Username: `neo4j`
- Password: `neo4j`
- Connection URL: `bolt://<homeassistant-ip>:<bolt-port>`

The add-on renders a `neo4j.conf` from the template and starts Neo4j from
`/opt/neo4j`.
