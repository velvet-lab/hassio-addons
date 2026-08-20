# OpenBao server configuration
# Learn more: https://openbao.org/docs/configuration

# Enable the built-in Web UI
ui = true

# Keep the OpenBao server log quiet; the add-on provides its own logging.
# Valid values: trace, debug, info, warn, err
log_level = "err"

# File storage backend for persistent data
storage "file" {
  path = "/data/openbao/file"
}

# HTTP listener (TLS is terminated by the add-on ingress)
listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = true
}
