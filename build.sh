#!/bin/bash -ex

SOURCE="${BASH_SOURCE[0]}"

while [ -h ${SOURCE} ];do
	DIR=$( cd -P $( dirname ${SOURCE} ) && pwd )
	SOURCE="$(readlink ${SOURCE})"
	[[ ${SOURCE} != /* ]] && SOURCE=${DIR}/${SOURCE}
done

BASEDIR="$( cd -P $( dirname ${SOURCE} ) && pwd )"
cd ${BASEDIR}

docker build -t zkpregistry.com:5043/activemq:5.15.0 -f ${BASEDIR}/Dockerfile ${BASEDIR}/

