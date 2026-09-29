#!/usr/bin/env bash
# ==============================================================================
# Post-start script for LiteLLM add-on devcontainer
# Starts the container init system (s6-overlay) so the add-on boots normally
# ==============================================================================
set -e

echo "Running post-start script..."

# Start the init system (s6-overlay) in the background
# The --pid flag creates a new PID namespace so s6 can be PID 1
# The --fork flag runs the init in a separate process
# The --kill-child flag ensures child processes are terminated on exit
# The --mount-proc flag mounts /proc for the new PID namespace
nohup unshare --pid --fork --kill-child=SIGTERM --mount-proc -- /init > /tmp/init.log 2>&1 &

echo "Init system started (PID: $!)"
echo "Logs available at /tmp/init.log"
echo ""
echo "Wait a few seconds for the add-on to start, then access the dashboard at:"
echo "  http://localhost:4000"
echo ""
echo "Use the master_key from /data/options.json to authenticate"
