# Home Assistant Community Add-on: Conduit

[Matrix](https://matrix.org/) is an open network for secure and decentralized communication. Users from every Matrix homeserver can chat with users from all other Matrix servers. You can even use bridges to communicate with users outside of Matrix, like a community on Discord. For more information, please see [Conduit](https://conduit.rs/).

## Installation

The installation of this add-on is pretty straightforward and not different in comparison to installing any other Home Assistant add-on.

1.  Set a `server_name`
2.  Start the "Conduit Server" add-on.
3.  Check the logs of "Dns/Dhcp Server" to see if everything went well.
4.  Open the Web Admin UI by open Url `http://your-homeassistant-ip:6736`.

**Note**: The add-on is **pre-configured** out of the box! There is no need to add/change/update the server connection settings!

## Configuration

**Note**: _Remember to restart the add-on when the configuration is changed._

Example add-on configuration:

```
server_name: homeassistant.local
log_level: warning
```

**Note**: _This is just an example, don't copy and paste it! Create your own!_

### Option: `log_level`

The `log_level` option controls the level of log output by the addon and can
be changed to be more or less verbose, which might be useful when you are
dealing with an unknown issue. Possible values are:

*   `trace`: Show every detail, like all called internal functions.
*   `debug`: Shows detailed debug information.
*   `info`: Normal (usually) interesting events.
*   `warning`: Exceptional occurrences that are not errors.
*   `error`: Runtime errors that do not require immediate action.
*   `fatal`: Something went terribly wrong. Add-on becomes unusable.

Please note that each level automatically includes log messages from a
more severe level, e.g., `debug` also shows `info` messages. By default,
the `log_level` is set to `info`, which is the recommended setting unless
you are troubleshooting.

### Option: `server_name`

The name of the server. Must be a dns compatible name

### Option: `allow_registration`

Opens your homeserver to public registration

### Option: `allow_federation`

Allow federation with other servers

### Option: `max_concurrent_requests`

The maximum number of concurrent requests

### Option: `max_request_size`

The maximum request size, in bytes

### Option: `registration_token`

The token users need to have when registering to your homeserver

## Data folder

The addon will store most of its configuration in the `/data/conduit` folder. Please ensure this is included in your backup.

## Reverse Proxy

The port Conduit will be running on. You need to set up a reverse proxy in your web server (e.g. apache or nginx), so all requests to /_matrix on port 443 and 8448 will be forwarded to the Conduit instance running on this port
