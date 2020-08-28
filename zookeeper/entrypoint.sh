#!/bin/bash

set -e

# Allow the container to be started with `--user`
if [[ $1 == "/usr/lib/zookeeper/bin/zkServer.sh" && "$(id -u)" == '0' ]]; then
    echo "Running as $ZOO_USER"
    ARGS=""
    for arg in "$@"; do
        ARGS="$ARGS $arg"
    done
    echo "$ $ARGS"

    su -c "$0" "$ZOO_USER" -- "$ARGS"
fi

/opt/docker_utils/run-parts.sh

echo "Starting zookeeper server"
DATA_DIR="$(grep dataDir ${ZOO_CONF_DIR}/zoo.cfg | awk -F'=' '{ print $2 }')"
if ! test "$(ls -A ${DATA_DIR})" || [[ ! "$*" =~ "-persist" ]]; then
    # Only initialize zookeeper if it hasn't been initialized yet (data dir is empty) or
    # if the '-persist' option hasn't been passed to the container.
    echo "Initializing zookeeper"
    service zookeeper-server init --force --myid="${ZOO_MY_ID:-1}"
    echo "Init done..."
fi
service zookeeper-server start

echo "Finished starting up zookeeper..."
tail -F /keep/me/running >/dev/null 2>&1
