#! /bin/bash

set -e
set -u

if [ "$(date +%u)" =  "1" ]
then
  nodetool repair
fi

nodetool clearsnapshot -t burp

