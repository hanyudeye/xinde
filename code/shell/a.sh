#!/bin/bash
LOG_DIR=/var/log
ROOT_UID=0
E_NOTROOT=1

LINES=50
if [ "$UID" -ne "$ROOT_UID" ]
then
    echo "Must be root to run this script."
    exit $E_NOTROOT
fi

if [ -n "$1" ]
then
    lines=$1
else
    lines=$LINES
fi

# E_WRONGARGS=65
# case "$1" in
#     "") lines=50;;
#     *[!0-9]*) echo "usage:`basename $0` file-to-cleanup";exit $E_wrongargs;;
#     *) lines=$1;;
# esac


cd $LOG_DIR
echo "Logs cleaned up."

exit 0
