#!/bin/bash

# Generate the config
CONFIG="$ZOO_CONF_DIR/zoo.cfg"

OVERRIDE_CONFIGS=${OVERRIDE_CONFIGS:-false}
if [[ $OVERRIDE_CONFIGS == "true" ]]; then
    if [[ -f "$CONFIG" ]]; then
        rm "${CONFIG}"
        touch "${CONFIG}"
        chown -R "$ZOO_USER" "$ZOO_CONF_DIR"
    fi

    {
        echo "dataDir=$ZOO_DATA_DIR"
        echo "dataLogDir=$ZOO_DATA_LOG_DIR"
        echo "clientPort=$ZOO_PORT"

        echo "tickTime=$ZOO_TICK_TIME"
        echo "initLimit=$ZOO_INIT_LIMIT"
        echo "syncLimit=$ZOO_SYNC_LIMIT"

        echo "autopurge.purgeInterval=$ZOO_AUTOPURGE_PURGEINTERVAL"
        echo "autopurge.snapRetainCount=$ZOO_AUTOPURGE_SNAPRETAINCOUNT"
        echo "maxClientCnxns=$ZOO_MAX_CLIENT_CNXNS"

        [[ ${ZOO_SERVER_1} != "" ]] && echo "server.1=${ZOO_SERVER_1}:2888:3888"
        [[ ${ZOO_SERVER_2} != "" ]] && echo "server.2=${ZOO_SERVER_2}:2888:3888"
        [[ ${ZOO_SERVER_3} != "" ]] && echo "server.3=${ZOO_SERVER_3}:2888:3888"
    } >> "$CONFIG"
else
    echo "Skipping automatic zookeeper configuration...assuming already configured..."
fi

echo "$ cat $CONFIG"
cat "$CONFIG"
