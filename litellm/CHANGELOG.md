# Changelog

All notable changes to this add-on will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 0.2.1

### Add-on
- Fixed pip installation: Strip `-stable` suffix from LiteLLM version tag in Dockerfile
- Build now correctly installs `litellm[proxy]==1.98.0` instead of invalid `1.98.0-stable`

### LiteLLM
- Bundled LiteLLM version: **v1.98.0-stable** (unchanged)

---

> [!NOTE]
> The add-on uses semantic versioning and is independent of the bundled LiteLLM version.
> This release bundles LiteLLM v1.98.0-stable.

## 0.2.0

### Add-on
- Added MySQL/MariaDB support via Home Assistant services (`use_mysql` option)
- Added Redis/Valkey support via UI options (`redis_host`, `redis_port`, `redis_password`, `redis_db`)
- Automatic database creation for MySQL (`litellm` database)
- PyMySQL driver for SQLAlchemy MySQL connectivity
- Services declaration: `mysql:want` (Valkey via options, not services)
- Updated documentation for MySQL and Redis/Valkey usage

### LiteLLM
- Bundled LiteLLM version: **v1.98.0-stable** (unchanged)

---

> [!NOTE]
> The add-on uses semantic versioning and is independent of the bundled LiteLLM version.
> This release bundles LiteLLM v1.98.0-stable.

## 0.1.0

### Add-on
- Initial release of LiteLLM Home Assistant add-on
- OpenAI-compatible AI Gateway for 100+ LLM providers
- Integrated admin dashboard for monitoring and management
- Support for SQLite (default) and external Postgres databases
- Optional Redis integration for caching and rate limiting
- User-editable configuration at `/homeassistant/addons/litellm/config.yaml`
- Virtual keys with per-key budgets and rate limits
- Cost tracking per key/team/user
- Load balancing and automatic fallbacks
- Retry logic across multiple deployments
- AppArmor security profile
- s6-overlay init system

### LiteLLM
- Bundled LiteLLM version: **v1.98.0-stable**
- AI Gateway with unified interface to 100+ providers
- Support for OpenAI, Anthropic, Bedrock, Azure, Gemini, Cohere, and more
- Streaming, function calling, embeddings, image generation, audio support
- Built-in observability integrations (Langfuse, MLflow, Helicone, etc.)
- 8ms P95 latency at 1k RPS (benchmarked)
- See [LiteLLM Releases](https://github.com/BerriAI/litellm/releases) for detailed product changes

---

> [!NOTE]
> The add-on uses semantic versioning and is independent of the bundled LiteLLM version.
> This release bundles LiteLLM v1.98.0-stable.
