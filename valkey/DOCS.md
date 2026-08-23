# Home Assistant Community Add-on: Valkey

## Installation

The installation of this add-on is pretty straightforward and not different in comparison to installing any other Home Assistant add-on.

1.  Start the "Valkey" add-on.
2.  Check the logs of "Valkey" to see if everything went well.

After starting the add-on, Valkey is available on port `6379` of your Home Assistant instance.

## Configuration

There are no required add-on configuration options available other than the `password` used to protect the server (see below). The add-on manages a minimal Valkey configuration under `/data/valkey`.

### Option: `password`

The `password` option sets the password required to connect to the Valkey server (`requirepass`). Clients must authenticate with this password using the `AUTH` command. This is a **required** option; the add-on will not start without it.

To generate a strong random password, you can use:

```bash
openssl rand -hex 32
```

which produces 64 hexadecimal characters (256-bit).

Connect with the password using `valkey-cli`:

```bash
valkey-cli -a <password> ping
```

### Option: `log_level`

The `log_level` option controls the level of log output by the add-on and can be changed to be more or less verbose, which might be useful when you are dealing with an unknown issue. Possible values are:

*   `trace`: Show every detail, like all called internal functions.
*   `debug`: Shows detailed debug information.
*   `info`: Normal (usually) interesting events.
*   `warning`: Exceptional occurrences that are not errors.
*   `error`: Runtime errors that do not require immediate action.
*   `fatal`: Something went terribly wrong. Add-on becomes unusable.

Please note that each level automatically includes log messages from a more severe level, e.g., `debug` also shows `info` messages. By default, the `log_level` is set to `info`, which is the recommended setting unless you are troubleshooting.

## Server configuration

The Valkey server configuration is managed as a file on your Home Assistant configuration folder:

`/homeassistant/addons/valkey/valkey.conf`

On first start the add-on copies a default configuration there, which you can edit directly (for example with Visual Studio Code). For a reference of all available options, see the [Valkey configuration documentation](https://valkey.io/topics/valkey.conf/). The add-on always enforces the `password` option (by re-rendering `requirepass` into the live configuration).

**Note:** Remember to restart the add-on after changing this file for the new configuration to take effect.

## Data folder

The add-on stores all Valkey persistent data (RDB snapshots and the append-only file) in the `/data/valkey` folder. Please ensure this is included in your backup.

## Backups & Permissions

- **Data backup:** Include `/data/valkey` in your regular backups so the dataset (and the append-only log) are preserved.
- **Secret files:** The `password` is a required add-on option so Home Assistant keeps it encrypted in its vault. Avoid writing it into unprotected files under `/homeassistant/addons/valkey`; the add-on injects it into the rendered config at runtime.

## Using the Redis-compatible server

Valkey speaks the Redis protocol, so any Redis-compatible client can connect to it directly on port `6379` of your Home Assistant instance. Connect from your network using any Redis-compatible client, for example:

```bash
valkey-cli -h <your-homeassistant-ip> -p 6379 -a <PASSWORD> ping
```

This add-on **automatically advertises itself as a `redis` discovery service** through the Supervisor Discovery API (host, port and password); no configuration is needed for that. Add-ons that support discovery for Redis — such as the bundled [Gogs add-on](https://github.com/velvet-lab/hassio-addons/tree/main/gogs) with its `redis_enabled` option — pick up this instance automatically and resolve its host, port and password without you entering them by hand.

## Memory overcommit warning

On startup, Valkey may log:

```
WARNING Memory overcommit must be enabled! Without it, a background save or replication may fail under low memory condition. ...
```

This is **not an error** and the server starts normally. Valkey raises it when the host kernel has `vm.overcommit_memory` disabled. Because this is an operating-system setting on the machine that runs Home Assistant, an unprivileged add-on container **cannot** change it — the setting must be enabled on the host.

To fix it on the host, add the following to `/etc/sysctl.conf` and reboot, or run it now:

```bash
sysctl vm.overcommit_memory=1
```

On **Home Assistant OS** the sysctl is not exposed by default; the same applies to Raspberry Pi/embedded installations. In most Home Assistant setups the warning is harmless — it only matters when a background save (RDB/AOF) can no longer fork under very low memory.

## Architecture notes

- On all architectures the add-on bundles the official prebuilt Valkey binary, so it runs natively on both amd64 and arm64 (e.g. Raspberry Pi) systems.