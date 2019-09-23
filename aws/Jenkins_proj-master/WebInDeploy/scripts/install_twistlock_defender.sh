#!/bin/bash
# if url is not supplied at the command prompt
# display usae message and die
[ $# -eq 0 ] && { echo "Usage: $1 IP Address of console $2 Auth token"; exit 1; }
# Download and install defender
url="https://$1:8083/api/v1/scripts/defender.sh"
header="authorization: Bearer $2"
ip="$1"
curl -k "${url} -H ${header}" -o defender.sh &&
curl -sSL -k --header "${header}" "${url}" | sudo bash -s -- -c "${ip}" -d "none"