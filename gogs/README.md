# Home Assistant Add-on: Gogs

This add-on bundles **Gogs 0.14.3**. The add-on version is independent of the bundled application version and follows semantic versioning (see the [CHANGELOG](CHANGELOG.md)).

Gogs is a painless, self-hosted Git service written in Go.

![Supports amd64 Architecture](https://img.shields.io/badge/amd64-yes-green.svg) ![Supports aarch64 Architecture](https://img.shields.io/badge/aarch64-yes-green.svg)

## About

Gogs (Git Original Guts System) is a lightweight, self-hosted Git service written in Go. It makes it easy to set up your own, private GitHub-like Git repository with issue tracking, pull requests, wiki and a built-in web editor. This add-on bundles the Gogs pre-built binary together with a SQLite database, so no external service is required. Optionally, Gogs can use a Redis server (e.g. the bundled Valkey add-on) for its sessions and cache.

## Known Issues

> [!WARNING]
> **Organization/team member actions fail with `Bad Request: no CSRF token present` (Gogs 0.14.3, upstream).**
>
> The organization/team *leave*, *join* and *remove* buttons in the web UI are `inline-form` POSTs that do not carry a CSRF token, which Gogs 0.14.3 rejects. This is an **upstream Gogs bug** and cannot be fixed via add-on configuration (Gogs has no `DISABLE_CSRF` option; the security advisory [#8321](https://github.com/gogs/gogs/pull/8321) intentionally hardened these routes).
>
> **Upstream fix:** Gogs `main` (0.15.0+) removes CSRF protection entirely ([#8300](https://github.com/gogs/gogs/pull/8300)). Until then, affected members can be removed directly via the database.
>
> When upgrading this add-on to Gogs **0.15.0+**, remember to:
> - bump `ARG GOGS_VERSION` + the release URLs in `Dockerfile`,
> - bump `version` in `config.yaml` and add a `CHANGELOG.md` entry,
> - remove/relax these two bullets once the issue is confirmed fixed in the bundled Gogs version.

- **Reverse proxy (HTTPS):** Gogs always listens on plain HTTP behind the Home Assistant reverse proxy (`PROTOCOL = http`), which terminates TLS. Do **not** set `PROTOCOL = https` — Gogs would then try to serve TLS itself and fail with `open custom/https/cert.pem: no such file or directory`. Only `EXTERNAL_URL` carries the `https://` scheme; `SSH_DOMAIN` is derived from it so SSH clone URLs stay correct.
- **First user becomes admin:** self-registration is enabled and the very first account to sign up automatically becomes the administrator (`DISABLE_REGISTRATION = false`). The Gogs web installer is locked (`INSTALL_LOCK = true`) so it cannot overwrite the add-on-managed `app.ini`.

## Support

Got questions? You have several options to get them answered:

- [Discord chat server](https://www.home-assistant.io/join-chat) for general Home Assistant discussions and questions.
- [Community Forum](https://community.home-assistant.io)
- Follow on X, use [@homeassistant](https://x.com/home_assistant)
- Join the [Facebook community](https://www.facebook.com/homeassistantio)
- You can also ask for help in the add-on's [GitHub Discussions](https://github.com/orgs/velvet-lab/discussions)
- If you think you found a bug in the add-on, please report it on [GitHub](https://github.com/velvet-lab/hassio-addons/issues)
- The [Gogs](https://gogs.io/) project

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