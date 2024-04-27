#!/bin/sh
# entry.sh: decides which startup script to run based on an environment variable. Currently supports apptainer and not apptainer (docker)

if [ -z "$APPTAINER_COMMAND" ]; then
    # APPTAINER_COMMAND is not set, run startup-tacc.sh
    exec /usr/bin/startup-tacc.sh
else
    # APPTAINER_COMMAND is set, run startup-tack.sh
    exec /usr/bin/startup.sh
fi