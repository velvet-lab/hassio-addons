#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# Install ps to examine started processes
apt-get update && apt-get install -qy --no-install-recommends procps
mkdir -p /tmp/.bashio
ln -s /data/options.json /tmp/.bashio/addons.self.options.config.cache
