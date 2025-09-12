# Home Assistant Add-on: MongoDB

A really simple implementation of MongoDb Community Edition 7.x.

![GitHub Sponsor][sponsor] ![Supports amd64 Architecture][amd64] ![Supports aarch64 Architecture][aarch64]


**Remarks for Raspberry:** Only Raspberry PI 5 and higher will supported.

## About

MongoDB is a source-available, cross-platform, document-oriented database program. Classified as a NoSQL database product, MongoDB uses JSON-like documents with optional schemas. Released in February 2009 by 10gen (now MongoDB Inc.), it supports features like sharding, replication, and ACID transactions.

## Authentication

If you want to enable authentication please set a strong password in the configuration page of the addon. After starting the addon the connectionstring will be `mongodb://admin:<password>@<your-homeassistant-ip>:27017`. Default user is `admin`.

## Replication

If you want to enable Replication, set a Replication Set Name for the addon. It will automatically configure a single-node replica set. This is required for some applications like  `RocketChat` integration. The default Replica Set name is `rs01`.

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
