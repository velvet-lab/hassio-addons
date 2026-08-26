# Changelog

All notable changes to this add-on will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
