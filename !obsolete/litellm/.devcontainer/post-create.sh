#!/usr/bin/env bash
# ==============================================================================
# Post-create script for LiteLLM add-on devcontainer
# Installs dependencies and sets up bashio environment
# ==============================================================================
set -e

echo "Running post-create script..."

# Install procps for process management tools
apt-get update
apt-get install -y --no-install-recommends procps
apt-get clean
rm -rf /var/lib/apt/lists/*

# Create bashio cache directory and symlink options.json
# This allows bashio::config to read the development options
mkdir -p /tmp/.bashio/addons.self
ln -sf /data/options.json /tmp/.bashio/addons.self.options.config.cache

echo "Post-create complete"
