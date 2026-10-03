#!/usr/bin/env bash
unshare --pid --fork --kill-child=SIGTERM --mount-proc perl -e '$SIG{INT} = ""; $SIG{TERM} = ""; exec @ARGV;' -- /init
