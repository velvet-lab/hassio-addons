# Home Assistant Add-on: VoceChat Server

VoceChat 0.4.x

A really simple implementation of VoceChat without TLS and Auth.

![GitHub Sponsor][sponsor] ![Supports amd64 Architecture][amd64-shield] ![Supports aarch64 Architecture][aarch64-shield]

## About

VoceChat is a superlight Rust powered chat app, API and SDK that prioritizes private hosting. Build your own in-app messaging feature with VoceChat!. For more information, please visit [VoceChat].

## Configuration

After starting the addon you can find Web-/Administration UI at `http://<your-homeassistant-ip>:3000`.

Advanced configuration will be found at addons configuration page. Feel free to change it for your needs.

Application specific Templates will be present in your Homeassistant config folder `addons/vocechat`. A default template is already copied. You can modify it for your own needs.

Furthermore its strongly recommended to secure **VoceChat** with a ReverseProxy and enabled TLS like letsencrypt or other. A good idea is Nginx Proxy Manager.

## Support

Create an issue on [GitHub][issues], or ask on the [Homeassistant Community Forum][community]

[VoceChat]: https://voce.chat/
[issues]: (https://github.com/velvet-lab/hassio-addons/issues)
[community]: (https://community.home-assistant.io)
[sponsor]: https://img.shields.io/github/sponsors/danlorb?label=Sponsor&logo=githubsponsors
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg

