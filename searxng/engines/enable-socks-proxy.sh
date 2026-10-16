#!/usr/bin/env bash

port=8080
public_ip=91.99.67.254

ssh -v -N -D $port root@$public_ip
