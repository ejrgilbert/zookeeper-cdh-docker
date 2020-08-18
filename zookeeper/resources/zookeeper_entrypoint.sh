#!/bin/bash

echo "Starting zookeeper server"
service zookeeper-server init "$@"
service zookeeper-server start

echo "Run base image's entrypoint"
exec /base_img_entrypoint.sh
