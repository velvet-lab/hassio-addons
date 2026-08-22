## 0.14.3

### Add-on

- Initial release of the Gogs add-on
- Bundle the Gogs pre-built Linux binary (`linux_amd64` / `linux_arm64`)
- Use a built-in SQLite database, so no external database service is required
- Add Web UI and Git HTTP access on port 3000
- Persist repositories, the database, sessions and a generated `SECRET_KEY` in `/data/gogs`
- Expose the Gogs server configuration as an editable file under `/homeassistant/addons/gogs/gogs.ini`
- Add a `secret_key` option to override the generated per-install key

### Gogs

- Address multiple security vulnerabilities, including reverse proxy impersonation, SSRF via webhooks and repository migration, stored XSS, unauthorized access to private repository attachments, privilege escalation, and remote command execution via pull request rebase merges

---

> [!NOTE]
> The add-on version follows the [Gogs version](https://gogs.io/).
> For detailed release notes, see the
> [official Gogs changelog](https://github.com/gogs/gogs/blob/main/CHANGELOG.md).