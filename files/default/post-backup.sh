#! /bin/bash

set -e
set -u

if [ "$(date +%u)" =  "1" ]
then
  /usr/local/bin/nodetool repair
fi

/usr/local/bin/nodetool clearsnapshot -t burp

