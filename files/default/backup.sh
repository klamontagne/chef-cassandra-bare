#! /bin/bash

set -e
set -u

/usr/local/bin/nodetool clearsnapshot -t burp || true

sleep 5

/usr/local/bin/nodetool snapshot -t burp

