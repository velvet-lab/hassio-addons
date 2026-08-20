# Home Assistant Community Add-on: Dns/Dhcp Server

Technitium DNS Server is an open source authoritative as well as recursive DNS server that can be used for self hosting a Dns/Dhcp Server for privacy & security. It works out-of-the-box with no or minimal configuration and provides a user friendly web console accessible using any modern web browser. For more information, please see [Technitium DNS][dns].

## Prerequesites

Before you can install/update this AddOn, change DNS Setting of your Home Assistant Installation to a DNS Server Installation in your Network, which is reachable in your Network, for example `8.8.8.8` (Google DNS Server). After you have updated the AddOn change DNS Server Setting of your Home Assistant Installation to IP Adresses of this AddOn. This could be found in the Output of your Protocol.

## Installation

The installation of this add-on is pretty straightforward and not different in
comparison to installing any other Home Assistant add-on.

1. Set a `domain` and `admin_password`
1. Start the "Dns/Dhcp Server" add-on.
1. Check the logs of "Dns/Dhcp Server" to see if everything went well.
1. Open the Web Admin UI by open Url `http://your-homeassistant-ip:5380`.

**Note**: The add-on is **pre-configured** out of the box! There is no need
to add/change/update the server connection settings!

## Post Installation

Do not use the **Auto Update** Function of the addon. This could break your Home Assitant Installation.

## Configuration

**Note**: _Remember to restart the add-on when the configuration is changed._

Example add-on configuration:

```yaml
domain: homeassistant.local
admin_password: Supercalifragilisticexpialidocious
log_level: warning
```

**Note**: _This is just an example, don't copy and paste it! Create your own!_

### Option: `log_level`

The `log_level` option controls the level of log output by the addon and can
be changed to be more or less verbose, which might be useful when you are
dealing with an unknown issue. Possible values are:

- `trace`: Show every detail, like all called internal functions.
- `debug`: Shows detailed debug information.
- `info`: Normal (usually) interesting events.
- `warning`: Exceptional occurrences that are not errors.
- `error`: Runtime errors that do not require immediate action.
- `fatal`: Something went terribly wrong. Add-on becomes unusable.

Please note that each level automatically includes log messages from a
more severe level, e.g., `debug` also shows `info` messages. By default,
the `log_level` is set to `info`, which is the recommended setting unless
you are troubleshooting.

### Option: `domain`

The primary domain name used by this DNS Server to identify itself

### Option: `admin_password`

The DNS web console admin user password

## Configuration folder

The addon will store most of its configuration in the `/data/config` folder. Please ensure this is included in your backup.
