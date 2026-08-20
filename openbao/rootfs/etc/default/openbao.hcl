# OpenBao server configuration
# Learn more: https://openbao.org/docs/configuration

# Enable the built-in Web UI
ui = true

# Server log level. This is only a default — the add-on overrides it at start
# via the BAO_LOG_LEVEL environment variable, which is mapped from the
# add-on's `log_level` option. Valid values: trace, debug, info, warn, err
log_level = "info"

# File storage backend for persistent data
storage "file" {
  path = "/data/openbao/file"
}

# HTTP listener (TLS is terminated by the add-on ingress)
listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = true
}
