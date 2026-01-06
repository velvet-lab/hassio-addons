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

## Support

Got questions?

You have several options to get them answered:

- The [Home Assistant Discord chat server][discord-ha] for general Home
  Assistant discussions and questions.
- The Home Assistant [Community Forum][forum].
- Join the [Reddit subreddit][reddit] in [/r/homeassistant][reddit]
- The [Technitium documentation][dns]

## Authors & contributors

The original setup of this repository is by [Roland Breitschaft][danlorb].

## License

MIT License

Copyright (c) 2006-2022 Roland Breitschaft

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

[addon-badge]: https://my.home-assistant.io/badges/supervisor_addon.svg
[addon]: https://my.home-assistant.io/redirect/supervisor_addon/?addon=a0d7b954_nodered&repository_url=https%3A%2F%2Fgithub.com%2Fhassio-addons%2Frepository
[dns]: https://technitium.com/dns/
[discord-ha]: https://discord.gg/c5DvZ4e
[forum]: https://community.home-assistant.io/t/home-assistant-community-add-on-node-red/55023?u=frenck
[reddit]: https://reddit.com/r/homeassistant
[danlorb]: https://github.com/danlorb
