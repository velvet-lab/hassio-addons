# OpenBao server configuration
# Learn more: https://openbao.org/docs/configuration
# This template is copied to /homeassistant/addons/openbao/openbao.hcl on
# first start. The ${BAO_LOG_LEVEL} placeholder is replaced at start time.

# Enable the built-in Web UI
ui = true

# Server log level, controlled by the add-on's log_level option.
log_level = "${BAO_LOG_LEVEL}"

# File storage backend for persistent data
storage "file" {
  path = "/data/openbao/file"
}

# HTTP listener (TLS is terminated by the add-on ingress)
listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = true
}
