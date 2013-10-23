#! /bin/bash

set -e
set -u

nodetool clearsnapshot -t burp || true

sleep 5

nodetool snapshot -t burp

