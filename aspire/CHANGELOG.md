## 0.1.0

### Add-on

- Initial release of the Aspire Dashboard add-on
- Bundle Aspire Dashboard from the official `mcr.microsoft.com/dotnet/aspire-dashboard:13` container image
- Expose frontend (`18888`), OTLP/gRPC (`18889`), OTLP/HTTP (`18890`) and MCP (`18891`) ports
- Add required `browser_token` option for frontend login authentication
- Add optional `otlp_api_key` option to secure OTLP ingestion with API key authentication
- Enable persistent telemetry storage by default with `persistence_mode: Resume`
- Provide an editable dashboard JSON configuration at `/homeassistant/addons/aspire/appsettings.json`
- Add a `.devcontainer/` folder for local development against the add-on image

### Aspire Dashboard

- Bundled Aspire Dashboard version: **13.6.0**
- For detailed release notes, see the official [Aspire release notes](https://github.com/dotnet/aspire/releases).

---
> [!NOTE]
> The add-on uses semantic versioning and is independent of the bundled Aspire Dashboard version.
> This release bundles Aspire Dashboard 13.6.0.
