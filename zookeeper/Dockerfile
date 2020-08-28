FROM base:1.0.0

# Using instructions located here:
# https://docs.cloudera.com/documentation/enterprise/5-9-x/topics/cdh_ig_install_previous.html#xd_583c10bfdbd326ba--6eed2fb8-14349d04bee--77b2
# https://docs.cloudera.com/documentation/enterprise/5-9-x/topics/cdh_ig_zookeeper_package_install.html

# Install zookeeper
ADD *.repo /etc/yum.repos.d
RUN yum -y clean all && \
    yum -y install zookeeper-server && \
    yum -y clean all

# Configure zookeeper
ENV ZOO_USER=zookeeper \
    ZOO_INSTALL_PATH=/usr/lib/zookeeper \
    ZOO_CONF_DIR=/usr/lib/zookeeper/conf/ \
    ZOO_DATA_DIR=/zoo/data \
    ZOO_DATA_LOG_DIR=/zoo/log \
    ZOO_LOG_DIR=/logs \
    ZOO_PORT=2181 \
    ZOO_TICK_TIME=2000 \
    ZOO_INIT_LIMIT=5 \
    ZOO_SYNC_LIMIT=2 \
    ZOO_AUTOPURGE_PURGEINTERVAL=0 \
    ZOO_AUTOPURGE_SNAPRETAINCOUNT=3 \
    ZOO_MAX_CLIENT_CNXNS=60

RUN mkdir -p "$ZOO_DATA_LOG_DIR" "$ZOO_DATA_DIR" "$ZOO_LOG_DIR" && \
    chown -R "$ZOO_USER:${ZOO_USER}" "$ZOO_DATA_LOG_DIR" "$ZOO_DATA_DIR" "$ZOO_LOG_DIR" "$ZOO_INSTALL_PATH"

# Add in entrypoint
ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh

VOLUME ["$ZOO_DATA_DIR", "$ZOO_DATA_LOG_DIR", "$ZOO_LOG_DIR"]

EXPOSE $ZOO_PORT 2888 3888

ENV PATH=$PATH:$INSTALL_PATH/bin

ENTRYPOINT [ "/entrypoint.sh" ]
