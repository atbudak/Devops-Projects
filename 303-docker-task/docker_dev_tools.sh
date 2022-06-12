#!/bin/bash

usage(){
echo "
    ./buid_dev_tools.sh [OPTIONS]
    Usage:
        -m, --mode              Select mode <build|deploy|template> 
        -n, --image-name        Docker image name
        -t, --image-tag         Docker image tag
        -M, --memory            Container memory limit
        -c, --cpu               Container cpu limit
        -N, --container-name    Container name
        -r, --registery         DocherHub or GitLab Image registery
        -a, --application-name  Run mysql or mongo server"

exit 1
}

if test $# -eq 0; then
  echo >&2 "$0: invalid number of operands; try \`$0 $(usage)"
  exit 1
fi

mode()
{
    if [[ $MODE == "build" ]]; then
        bash -c "docker build -t $REGISTERY/$IMAGE_NAME:$IMAGE_TAG ."
        bash -c "docker image ls | grep $IMAGE_NAME"

    elif [[ $MODE == "deploy" ]]; then
        bash -c "docker container run -dit --name $CONTAINER_NAME --memory $MEMORY --cpus $CPU $REGISTERY/$IMAGE_NAME:$IMAGE_TAG"
        bash -c "docker ps -a | grep $CONTAINER_NAME"

    elif [[ $MODE == "template" ]]; then

        if [[ $APPLICATION_NAME == "mysql" ]]; then
            bash -c "docker compose -f docker-compose-mysql.yaml up"

        elif [[ $APPLICATION_NAME == "mongo" ]]; then
            bash -c "docker compose -f docker-compose-mongodb.yaml up"

        else
            echo "Choose databases as if Mongo or Mysql: for Mongodb 'mongo',for Mysql 'mysql'."
        fi

    else
        echo "Select mode like: <build|deploy|template>"
    fi
}


MODE="build"
IMAGE_NAME="alpine"
IMAGE_TAG="latest"
MEMORY="100m"
CPU="1.0"
CONTAINER_NAME="test-container"
REGISTERY="docker.io"
APPLICATION_NAME="mongo"

parameters_list=":m:"

while getopts ${parameters_list} OPTS; do
	case "${OPTS}" in
        m)
            MODE=$2; mode
        ;;
        ?)
	      echo "invalid option"
	      echo ""
	      branch
	      ;;
	esac
done
