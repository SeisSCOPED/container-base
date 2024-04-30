#!/bin/sh
# entry.sh: decides which startup script to run based on an environment variable. Currently supports apptainer and not apptainer (docker)

if [ -n "$_tapisAppId" ]; then
    echo "Running in tapis environmnet"
    exec /usr/bin/startup-tacc.sh
else
    exec /usr/bin/startup.sh
fi