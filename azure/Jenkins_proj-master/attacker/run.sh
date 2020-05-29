#! /bin/bash -e

# Running nc on an unexposed port to keep the container up

if [[ $# -lt 1 ]] || [[ "$1" == "--"* ]]; then

  exec nc -l -p 56789 "$@"

fi

exec "$@"
