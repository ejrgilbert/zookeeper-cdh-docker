FROM base:1.0.0

# Using instructions located here:
# https://docs.cloudera.com/documentation/enterprise/5-9-x/topics/cdh_ig_install_previous.html#xd_583c10bfdbd326ba--6eed2fb8-14349d04bee--77b2
# https://docs.cloudera.com/documentation/enterprise/5-9-x/topics/cdh_ig_zookeeper_package_install.html

ARG RESOURCES_DIR="./resources"
ARG RESOURCES_DST="/tmp/resources"

ADD ${RESOURCES_DIR} ${RESOURCES_DST}

# Install zookeeper
COPY ${RESOURCES_DIR}/cloudera-cdh5.repo /etc/yum.repos.d
RUN rpm --import https://archive.cloudera.com/cdh5/redhat/7/x86_64/cdh/RPM-GPG-KEY-cloudera && \
    yum -y clean all && \
    yum -y install zookeeper-server

# Configure zookeeper
RUN mv ${RESOURCES_DST}/zoo.cfg /usr/lib/zookeeper/conf && \
    mv ${RESOURCES_DST}/zookeeper_entrypoint.sh / && \
    chmod +x /zookeeper_entrypoint.sh

# cleanup
RUN rm -rf ${RESOURCES_DST}

ENTRYPOINT [ "/zookeeper_entrypoint.sh" ]
CMD [ "--myid=1" ]