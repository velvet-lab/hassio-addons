# Home Assistant Add-on: LiteLLM

## About

LiteLLM is an open source AI Gateway that provides a unified interface to 100+ LLM providers including OpenAI, Anthropic, AWS Bedrock, Azure OpenAI, Google Gemini, and many more. It acts as a central proxy/router that translates all provider-specific APIs into a standardized OpenAI-compatible format.

**Bundled LiteLLM version: v1.98.0-stable**

## Features

- **Unified API**: Single OpenAI-compatible interface for 100+ LLM providers
- **Admin Dashboard**: Built-in web UI for monitoring, management, and configuration
- **Cost Tracking**: Track spend per key, team, and user across all providers
- **Load Balancing**: Distribute requests across multiple models and deployments
- **Virtual Keys**: Create access keys with per-key budgets and rate limits
- **Retry & Fallback**: Automatic retry logic and fallback routing
- **Caching**: Redis-based caching to reduce costs and latency
- **Guardrails**: Content filtering, PII masking, and safety checks
- **Observability**: Built-in logging and integration with Langfuse, MLflow, Helicone, etc.

## Installation

1. Navigate to the **Add-on Store** in Home Assistant
2. Add this repository: `https://github.com/velvet-lab/hassio-addons`
3. Find **LiteLLM** in the add-on list
4. Click **Install**

## Configuration

### Required Options

- **master_key**: Master key for proxy authentication (required)
  - Generate a strong random key: `openssl rand -hex 32` (64 hex chars / 256-bit)
  - This key is used to authenticate all requests to the proxy
  - Store it securely - it's stored encrypted by Home Assistant

### Optional Options

- **log_level**: Set logging verbosity (default: `info`)
  - Options: `trace`, `debug`, `info`, `notice`, `warning`, `error`, `fatal`
- **ui_enable**: Enable/disable the dashboard UI (default: `true`)
- **use_mysql**: Use MySQL/MariaDB from another add-on (default: `false`)
  - Requires the MariaDB add-on (or compatible) to be installed and running
  - When enabled, LiteLLM uses the shared MariaDB service instead of SQLite
  - The database `litellm` is created automatically
- **redis_host**: Redis/Valkey server hostname (optional)
  - Leave empty to disable Redis (no caching/rate limiting)
  - When set, `redis_password` is also required
- **redis_port**: Redis/Valkey server port (default: `6379`)
- **redis_password**: Redis/Valkey authentication password (optional)
  - Required when `redis_host` is set
- **redis_db**: Redis/Valkey database number (default: `0`)
- **store_model_in_db**: Store model config in database instead of file (default: `false`)

### Example Configuration

```yaml
log_level: info
master_key: "your-generated-master-key-here"
ui_enable: true
use_mysql: false
```

### Using MySQL/MariaDB

To use a shared MySQL/MariaDB database instead of SQLite:

1. Install the [official MariaDB add-on](https://github.com/home-assistant/addons/tree/master/mariadb) or compatible
2. Start the MariaDB add-on
3. Set `use_mysql: true` in the LiteLLM configuration
4. Restart the LiteLLM add-on

The database `litellm` will be created automatically.

### Using Redis/Valkey for Caching

To enable caching and rate limiting with Redis:

1. Install the [Valkey add-on](https://github.com/velvet-lab/hassio-addons/tree/main/valkey) or any Redis-compatible server
2. Start the Valkey add-on and note its connection details
3. Configure LiteLLM with Redis connection:
   ```yaml
   log_level: info
   master_key: "your-key"
   redis_host: "192.168.1.100"  # Valkey add-on IP
   redis_port: 6379
   redis_password: "your-valkey-password"
   redis_db: 0
   ```
4. Configure caching in `/homeassistant/addons/litellm/config.yaml`:
   ```yaml
   litellm_settings:
     cache: true
     cache_params:
       type: redis
       ttl: 600
   ```
5. Restart the LiteLLM add-on

## Usage

### Accessing the Dashboard

After starting the add-on, access the dashboard at:

```
http://homeassistant.local:4000
```

Use your `master_key` to authenticate.

### Making API Calls

The proxy is fully OpenAI-compatible. Use any OpenAI SDK or tool:

**Python (OpenAI SDK):**
```python
import openai

client = openai.OpenAI(
    api_key="your-master-key",
    base_url="http://homeassistant.local:4000"
)

response = client.chat.completions.create(
    model="gpt-4",
    messages=[{"role": "user", "content": "Hello!"}]
)
print(response.choices[0].message.content)
```

**cURL:**
```bash
curl http://homeassistant.local:4000/chat/completions \
  -H "Authorization: Bearer your-master-key" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-4",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

### Configuring Models

Edit the configuration file at `/homeassistant/addons/litellm/config.yaml` to define your models:

```yaml
model_list:
  - model_name: gpt-4
    litellm_params:
      model: openai/gpt-4
      api_key: ${OPENAI_API_KEY}

  - model_name: claude-3-opus
    litellm_params:
      model: anthropic/claude-3-opus-20240229
      api_key: ${ANTHROPIC_API_KEY}
```

**Note**: Restart the add-on after modifying the config file.

You can reference environment variables using `${VAR_NAME}` syntax. Add your API keys to the config file's `environment_variables` section:

```yaml
environment_variables:
  OPENAI_API_KEY: sk-...
  ANTHROPIC_API_KEY: sk-ant-...
```

## Advanced Configuration

The user-editable configuration file at `/homeassistant/addons/litellm/config.yaml` supports all LiteLLM proxy settings including:

- Model routing and fallbacks
- Load balancing strategies
- Caching configuration
- Virtual key management
- Alerting thresholds
- Custom callbacks

See the [LiteLLM documentation](https://docs.litellm.ai/docs/proxy/configs) for a complete reference.

## Supported Providers

LiteLLM supports 100+ LLM providers, including:

- **OpenAI** (GPT-4, GPT-3.5, etc.)
- **Anthropic** (Claude)
- **AWS Bedrock** (Claude, Llama, etc.)
- **Azure OpenAI**
- **Google Gemini / Vertex AI**
- **Cohere**
- **Hugging Face**
- **Ollama** (local models)
- **Replicate**
- **Together AI**
- **Groq**
- **And many more...**

See the [full provider list](https://docs.litellm.ai/docs/providers) for details.

## Port Mapping

- **4000/tcp**: LiteLLM proxy server + dashboard UI

## Storage

- `/data/litellm/`: Database and persistent storage
  - `database.db`: SQLite database (when not using MySQL)
- `/homeassistant/addons/litellm/`: User-editable configuration
  - `config.yaml`: LiteLLM proxy configuration (model list, routing, etc.)

## Links

- [LiteLLM GitHub](https://github.com/BerriAI/litellm)
- [LiteLLM Documentation](https://docs.litellm.ai/)
- [LiteLLM Proxy Docs](https://docs.litellm.ai/docs/proxy/quick_start)
- [Supported Providers](https://docs.litellm.ai/docs/providers)

## Support

For issues and questions:
- [GitHub Issues](https://github.com/velvet-lab/hassio-addons/issues)
- [LiteLLM Discord](https://discord.gg/wuPM9dRgDw)

## License

This add-on is distributed under the MIT License.
LiteLLM is licensed under the MIT License.
