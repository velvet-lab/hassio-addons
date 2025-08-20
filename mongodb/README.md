# Home Assistant Add-on: MongoDB

A really simple implementation of MongoDb Community Edition 7.x.

![GitHub Sponsor][sponsor] ![Supports amd64 Architecture][amd64-shield] ![Supports aarch64 Architecture][aarch64-shield]



**Remarks:** Currently only MongoDb till Version 7.x works on Raspberry. Version 8.x has issues with tsmalloc.

## About

MongoDB is a source-available, cross-platform, document-oriented database program. Classified as a NoSQL database product, MongoDB uses JSON-like documents with optional schemas. Released in February 2009 by 10gen (now MongoDB Inc.), it supports features like sharding, replication, and ACID transactions.

## Configuration

Before starting the addon please set a strong admin password on configuration page. After starting the addon the connectionstring will be `mongodb://admin:<password>@<your-homeassistant-ip>:27017`.

## Support

Create an issue on [GitHub][issues], or ask on the [Homeassistant Community Forum][community]

[issues]: (https://github.com/velvet-lab/hassio-addons/issues)
[community]: (https://community.home-assistant.io)
[sponsor]: https://img.shields.io/github/sponsors/danlorb?label=Sponsor&logo=githubsponsors
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
