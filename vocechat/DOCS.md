# Home Assistant Community Add-on: VoceChat

![GitHub Sponsor][sponsor] ![Supports amd64 Architecture][amd64-shield] ![Supports aarch64 Architecture][aarch64-shield]

VoceChat is a superlight Rust powered chat app, API and SDK that prioritizes private hosting. Build your own in-app messaging feature with VoceChat! For more information, please see [VoceChat][VoceChat].

## Installation

The installation of this add-on is pretty straightforward and not different in
comparison to installing any other Home Assistant add-on.

1. Start the "VoceChat" add-on.
1. Check the logs of "VoceChat" to see if everything went well.
1. Open the Web Admin UI by opening the URL `http://your-homeassistant-ip:3000`.

**Note**: The add-on is **pre-configured** out of the box! There is no need
to add/change/update the server connection settings!

## Configuration

**Note**: _Remember to restart the add-on when the configuration is changed._

Example add-on configuration:

```yaml

domain: homeassistant.local
token_expiry_seconds: 300
refresh_token_expiry_seconds: 864000000
magic_token_expiry_seconds: 600
template_register_by_email: Register code
template_login_by_email: Your sign-in link for Vocechat
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

The primary domain name used by this Server to identify itself

### Option: `token_expiry_seconds`

When should the auth token expire

### Option: `refresh_token_expiry_seconds`

When should the refresh token expire

### Option: `magic_token_expiry_seconds`

When should a created magic login token expire

### Option: `template_register_by_email`

Mail subject for registration emails

### Option: `template_login_by_email`

Mail subject for login emails

## Configuration folder

The add-on will store most of its configuration in the `/data` folder.

## Support

Got questions?

You have several options to get them answered:

- Check out the [VoceChat website][vocechat] for more information about VoceChat itself.
- You can also try to ask in the official VoceChat [VoceChat Community][community].
- The [Home Assistant Discord chat server][discord] for general Home
  Assistant discussions and questions.
- The Home Assistant [Community Forum][community].
- Join the [Reddit subreddit][reddit]
- You can also ask for help in the add-on's [GitHub Discussions][discussions].
- If you think you found a bug in the add-on, please report it on
  [GitHub][issues].



[vocechat]: https://voce.chat/
[community]: https://community.home-assistant.io
[discord]: https://discord.gg/home-assistant
[issues]: https://github.com/velvet-lab/hassio-addons/issues
[reddit]: https://reddit.com/r/homeassistant
[danlorb]: https://github.com/danlorb
[sponsor]: https://img.shields.io/github/sponsors/danlorb?label=Sponsor&logo=githubsponsors
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg




