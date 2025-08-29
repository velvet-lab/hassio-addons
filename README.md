# Home assistant addons: velvet-lab

![GitHub Sponsor][sponsor]

## About

Home Assistant allows anyone to create add-on repositories to share their add-ons for Home Assistant easily. This repository is one of those repositories, providing extra Home Assistant add-ons for your installation. You can use this AddOns as is and at your own Risk.

## Installation

[![Add repository on my Home Assistant][repository-badge]][repository-url]

If you want to do add the repository manually, please follow the procedure highlighted in the [Home Assistant website](https://home-assistant.io/hassio/installing_third_party_addons). Use the following URL to add this repository: `https://github.com/velvet-lab/hassio-addons`

## Add-ons provided by this repository

### Dns/Dhcp Server by Technitium

Greate Dns/Dhcp Server provided by [Technitium](https://technitium.com/dns) boxed in a HA AddOn

![amd64][amd64]
![aarch64][aarch64]

### MongoDb Community Edition 7.x

A really simple implementation of MongoDb without TLS and Auth.

**Remarks:** Currently only MongoDb till Version 7.x works on Raspberry. Version 8.x has issues with tsmalloc.

![amd64][amd64]
![aarch64][aarch64]

### VoceChat

[VoceChat](https://voce.chat/) VoceChat is a superlight Rust powered chat app, API and SDK that prioritizes private hosting. Build your own in-app messaging feature with VoceChat!

![amd64][amd64]
![aarch64][aarch64]

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

[repository-badge]: https://img.shields.io/badge/Add%20repository%20to%20my-Home%20Assistant-41BDF5?logo=home-assistant&style=for-the-badge
[repository-url]: https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fvelvet-lab%2Fhassio-addons


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
