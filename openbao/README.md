# Home Assistant Add-on: OpenBao

This add-on bundles **OpenBao 2.6.2**. The add-on version is independent of the bundled application version and follows semantic versioning (see the [CHANGELOG](CHANGELOG.md)).

OpenBao is an open source, community-driven fork of HashiCorp Vault. It is a software solution to manage, store, and distribute sensitive data including secrets, certificates, and keys.

![Supports amd64 Architecture](https://img.shields.io/badge/amd64-yes-green.svg) ![Supports aarch64 Architecture](https://img.shields.io/badge/aarch64-yes-green.svg)

## About

A modern system requires access to a multitude of secrets: database credentials, API keys for external services, credentials for service-oriented architecture communication, etc. OpenBao steps in to securely store and distribute these secrets, providing secure secret storage, dynamic secrets, data encryption, leasing and revocation out of the box.

This add-on bundles the OpenBao server, installed from the official OpenBao Debian package, together with its built-in Web UI.

## Support

Got questions?

You have several options to get them answered:

* [Discord chat server](https://www.home-assistant.io/join-chat) for general Home Assistant discussions and questions.
* [Community Forum](https://community.home-assistant.io)
* Join the Reddit in [r/homeassistant](https://reddit.com/r/homeassistant)
* Follow on X, use [@homeassistant](https://x.com/home_assistant)
* Join the [Facebook community](https://www.facebook.com/homeassistantio)
* You can also ask for help in the add-on's [GitHub Discussions](https://github.com/orgs/velvet-lab/discussions)
* If you think you found a bug in the add-on, please report it on [GitHub](https://github.com/velvet-lab/hassio-addons/issues)
* The [OpenBao](https://openbao.org) project

## Authors & contributors

The original setup of this repository is by [Roland Breitschaft](https://github.com/danlorb).

## License

MIT License

Copyright (c) 2006-2026 Roland Breitschaft

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
