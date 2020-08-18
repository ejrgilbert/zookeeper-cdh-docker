#!/bin/bash

# NOTE: REGISTRY_URL is used to specify where to push the built images...must have trailing '/'
source ./util/logging.sh

CDH_VERSION="5.9.1"

ZOOKEEPER="zookeeper"
HELP="help"

REPO_FILE_BASE="./${ZOOKEEPER}/cloudera-cdh5.repo"
REPO_FILE_DST="./${ZOOKEEPER}/resources/cloudera-cdh5.repo"
CDH_BASE_URL="baseurl=https://archive.cloudera.com/cdh5/redhat/7/x86_64/cdh/"

header "Docker Build Utility"

function usage() {
    echo "Usage: $0 [-v ver1 ver2 ...] [-p] -- (${ZOOKEEPER} | ${HELP}"
    echo -e "\t${ZOOKEEPER} - if you would like to build the zookeeper docker image"
    echo -e "\t${HELP} - to see this message"
    echo "Options:"
    echo -e "\t-c - Override the default CDH_VERSION (${CDH_VERSION})...this logic will need to be changed if NOT a chd5 release"
    echo -e "\t-v - What versions to tag the images as"
    echo -e "\t-p - Pass this option if you want to push to the REGISTRY...MUST HAVE -v IF USING THIS OPTION"
    note "Make sure you  pass the '--' if you use any of the above options (-v parsing causes this)"
    exit 1
}

function cleanup() {
    rm "${REPO_FILE_DST}"
}

function build_failed() {
    cleanup
    error_exit "Build of $1 failed"
}

function configure_repo() {
    cp "${REPO_FILE_BASE}" "${REPO_FILE_DST}"
    echo "${CDH_BASE_URL}/${CDH_VERSION}" >>${REPO_FILE_DST}
}

function build_zookeeper() {
    info "Building ${ZOOKEEPER} docker image"
    configure_repo

    if ! docker build -t ${ZOOKEEPER} ./${ZOOKEEPER}; then
        build_failed ${ZOOKEEPER}
    fi
    cleanup
    success "Completed building ${ZOOKEEPER} docker image"
}

function tag_images() {
    info "Tagging docker images as: [ ${IMAGE_VERSIONS[*]} ]"
    for v in "${IMAGE_VERSIONS[@]}"; do
        docker tag "${ZOOKEEPER}" "${REGISTRY_URL}${ZOOKEEPER}:$v" || error_exit "Failed to tag ${REGISTRY_URL}${ZOOKEEPER}:$v"
    done
    success "Completed tagging docker images"
}

function push_images() {
    info "Pushing docker images"
    for v in "${IMAGE_VERSIONS[@]}"; do
        docker push "${REGISTRY_URL}${ZOOKEEPER}:$v" || error_exit "Failed to push ${REGISTRY_URL}${ZOOKEEPER}:$v"
    done
    success "Completed pushing docker images"
}

while getopts 'c:v:p' opt
do
    case "${opt}" in
        c )
            CDH_VERSION="${OPTARG}"
            ;;
        v )
            IMAGE_VERSIONS+=("$OPTARG")
            while [ "$OPTIND" -le "$#" ] && [ "${!OPTIND:0:1}" != "-" ]; do
                IMAGE_VERSIONS+=("${!OPTIND}")
                OPTIND="$(( OPTIND + 1 ))"
            done
            ;;
        p )
            PUSH="true"
            ;;
        ? )
            usage
            ;;
        * )
            usage
            ;;
    esac
done
shift $(( OPTIND - 1 ))

if [[ "${PUSH}" == "true" && -z ${IMAGE_VERSIONS[*]} ]]; then
    error_exit "The push (-p) option must be paired with tag versions (-v)"
fi

case $1 in
    ${ZOOKEEPER} )
        build_zookeeper
        ;;
    ${HELP} )
        usage
        ;;
    * )
        usage
        ;;
esac

if [[ -n ${IMAGE_VERSIONS[*]} ]]; then
    tag_images
fi

if [[ "${PUSH}" == "true" ]]; then
    push_images
fi
