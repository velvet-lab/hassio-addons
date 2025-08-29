# Home Assistant Add-on: VoceChat Server

VoceChat 0.4.x

VoceChat is a superlight Rust powered chat app, API and SDK that prioritizes private hosting. Build your own in-app messaging feature with VoceChat!

![GitHub Sponsor][sponsor] ![Supports amd64 Architecture][amd64] ![Supports aarch64 Architecture][aarch64]

## About

VoceChat is a superlight Rust powered chat app, API and SDK that prioritizes private hosting. Build your own in-app messaging feature with VoceChat!. For more information, please visit [VoceChat].

## Configuration

After starting the addon you can find Web-/Administration UI at `http://<your-homeassistant-ip>:3000`.

Advanced configuration will be found at addons configuration page. Feel free to change it for your needs.

Application specific Templates will be present in your Homeassistant config folder `addons/vocechat`. A default template is already copied. You can modify it for your own needs.

Furthermore its strongly recommended to secure **VoceChat** with a ReverseProxy and enabled TLS like letsencrypt or other. A good idea is Nginx Proxy Manager.

## Support

Got questions?

You have several options to get them answered:

- [Discord chat server][ha_discord] for general Home Assistant discussions and questions.
- [Community Forum][ha_community]
- Join the Reddit in [r/homeassistant][ha_reddit]
- Follow on X, use [@homeassistant][ha_twitter]
- Join the [Facebook community][ha_facebook]
- You can also ask for help in the add-on's [GitHub Discussions][discussions]
- If you think you found a bug in the add-on, please report it on [GitHub][issues]

## Authors & Contributors

The original setup of this repository was done by [Roland Breitschaft][danlorb].


[VoceChat]: https://voce.chat/

[ha_community]: https://community.home-assistant.io
[ha_discord]: https://www.home-assistant.io/join-chat
[ha_twitter]: https://x.com/home_assistant
[ha_reddit]: https://reddit.com/r/homeassistant
[ha_facebook]: https://www.facebook.com/homeassistantio

[issues]: https://github.com/velvet-lab/hassio-addons/issues
[discussions]: https://github.com/orgs/velvet-lab/discussions
[danlorb]: https://github.com/danlorb
[sponsor]: https://img.shields.io/github/sponsors/danlorb?label=Sponsor&logo=githubsponsors

[amd64]: https://img.shields.io/badge/amd64-yes-green.svg
[aarch64]: https://img.shields.io/badge/aarch64-yes-green.svg

