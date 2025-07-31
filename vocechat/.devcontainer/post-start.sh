#!/usr/bin/env bash
# -*- coding: utf-8 -*-

unshare --pid --fork --kill-child=SIGTERM --mount-proc perl -e '$SIG{INT} = ""; $SIG{TERM} = ""; exec @ARGV;' -- /init
