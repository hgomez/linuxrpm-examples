#!/bin/bash
usage(){
  echo "usage:"
  echo "  $0 <target_os> <rpm_source...>"
  echo " where target_os matches an existing zepag/rpmbuild-<target_os> docker container"
  echo " where rpm_source is a list of source folders found in $PWD/BUILDS, separated by spaces"
  exit 1
}
[ -z "$1" ] && usage
[ -z "$2" ] && usage
TARGET_OS="$1"
CONTAINER_HOST="$(echo ${TARGET_OS}|sed -e 's/\.//g').rpmbuild"
shift
mkdir -p "$PWD/OUTPUT/${TARGET_OS}"
docker run -t -i \
  --rm \
  -h ${CONTAINER_HOST} \
  -v $PWD/BUILDS/:/BUILDS-RO/:ro \
  -v "$PWD/OUTPUT/${TARGET_OS}"/:/OUTPUT/:rw \
  -v "$PWD/BINARIES/"/:/BINARIES/:rw \
  zepag/rpmbuild-${TARGET_OS} "$@"
