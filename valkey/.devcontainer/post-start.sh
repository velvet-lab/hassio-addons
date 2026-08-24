#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# The devcontainer runs privileged, so we can switch on memory overcommit for
# the kernel. This only applies to local development; without it Valkey logs
# the "Memory overcommit must be enabled" warning. Best-effort only: if the
# container cannot set the sysctl we keep going.
sysctl -w vm.overcommit_memory=1 2>/dev/null || true

unshare --pid --fork --kill-child=SIGTERM --mount-proc perl -e '$SIG{INT} = ""; $SIG{TERM} = ""; exec @ARGV;' -- /init