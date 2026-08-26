# Home Assistant Add-on: LiteLLM

LiteLLM AI Gateway for Home Assistant - unified interface to 100+ LLM providers with cost tracking, load balancing, and an admin dashboard.

![Project Stage][project-stage-shield]
![Maintenance][maintenance-shield]
[![License][license-shield]](LICENSE)

## About

LiteLLM is an open source AI Gateway that provides a unified interface to 100+ LLM providers including OpenAI, Anthropic, AWS Bedrock, Azure OpenAI, Google Gemini, and many more.

**Bundled LiteLLM version: v1.98.0-stable**

## Features

- 🔄 **Unified API**: Single OpenAI-compatible interface for 100+ LLM providers
- 📊 **Admin Dashboard**: Built-in web UI for monitoring and management
- 💰 **Cost Tracking**: Track spend per key, team, and user
- ⚖️ **Load Balancing**: Distribute requests across multiple deployments
- 🔑 **Virtual Keys**: Per-key budgets and rate limits
- 🔁 **Retry & Fallback**: Automatic retry logic and fallback routing
- 🛡️ **Guardrails**: Content filtering, PII masking, safety checks
- 📈 **Observability**: Integration with Langfuse, MLflow, Helicone, etc.

## Installation

1. Navigate to the **Add-on Store** in Home Assistant
2. Add this repository: `https://github.com/velvet-lab/hassio-addons`
3. Find **LiteLLM** in the add-on list
4. Click **Install**

## Quick Start

1. Generate a master key:
   ```bash
   openssl rand -hex 32
   ```

2. Configure the add-on with your master key

3. Start the add-on

4. Access the dashboard at `http://homeassistant.local:4000`

5. Configure your models in `/homeassistant/addons/litellm/config.yaml`

## Documentation

For full documentation, see [DOCS.md](DOCS.md).

## Links

- [LiteLLM GitHub](https://github.com/BerriAI/litellm)
- [LiteLLM Documentation](https://docs.litellm.ai/)
- [Add-on Repository](https://github.com/velvet-lab/hassio-addons)

[license-shield]: https://img.shields.io/github/license/velvet-lab/hassio-addons.svg
[maintenance-shield]: https://img.shields.io/maintenance/yes/2026.svg
[project-stage-shield]: https://img.shields.io/badge/project%20stage-experimental-yellow.svg
