#!/bin/bash

usage(){
    echo "
        USAGE:

        ./buid_dev_tools.sh -m <build|deploy|template>  [OPTIONS]
            For build mode use this order:

                ./buid_dev_tools.sh -m build -n <image-name> -t <image-tag>  \ 
                        [OPTIONAL] -r <registery>

            For build deploy use this order:

                ./buid_dev_tools.sh -m deploy -n <image-name> -t <image-tag> \
                        [OPTIONAL] -M <memory> -c <cpu> -N <container-name>
            
            For build template use this order:

                ./buid_dev_tools.sh -m template -a <application-name>

        PARAMETERS:

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


build(){
    bash -c "docker build -t $REGISTERY/$IMAGE_NAME:$IMAGE_TAG ."
    bash -c "docker image ls | grep $IMAGE_NAME"
}

deploy(){
    bash -c "docker container run -dit --name $CONTAINER_NAME --memory $MEMORY --cpus $CPU $REGISTERY/$IMAGE_NAME:$IMAGE_TAG"
    bash -c "docker ps -a | grep $CONTAINER_NAME"

}

template(){
    if [[ $APPLICATION_NAME == "mysql" ]]; then
        bash -c "docker compose -f docker-compose-mysql.yaml up"

    elif [[ $APPLICATION_NAME == "mongo" ]]; then
        bash -c "docker compose -f docker-compose-mongodb.yaml up"

    else
        echo "Choose databases as if Mongo or Mysql: for Mongodb 'mongo', for Mysql 'mysql'."
    fi
}

MODE="build"
IMAGE_NAME="alpine"
IMAGE_TAG="latest"
MEMORY=""
CPU=""
CONTAINER_NAME="test-container"
REGISTERY="docker.io"
APPLICATION_NAME="mongo"

input_num=$#
parameters=$@;
let deger=1;
let file_deger=1;
values(){   
    while [ $deger -le $input_num ]; do
        # echo Sayac durumu: $deger
        # echo "$parameters" | awk '{print $1}'
        echo "$parameters" | awk -v a="$deger" '{print $a}' > deger$deger.txt
        echo  "$(cat deger1.txt)"  
        let deger=$deger+1
    done     
}

remove_files(){
    while [ $file_deger -le $input_num ]; do
        rm ./deger$file_deger.txt
        let file_deger=$file_deger+1
    done     
}


values

if [[ "$(cat deger1.txt)" == "-m" ]]; then
    MODE="$(cat deger2.txt)"
    # echo "$MODE"
    if [[ $MODE == "deploy" ]]; then  # MODE = deploy için

        if [[ "$(cat deger3.txt)" == "-n" ]];then # checking image name if exists
            IMAGE_NAME="$(cat deger4.txt)";
            if [[ "$(cat deger5.txt)" == "-t" ]];then # checking image tag if exists
                IMAGE_TAG="$(cat deger6.txt)";
                    if [[ "$(cat deger7.txt)" == "-M" && "$(cat deger8.txt)" != "" ]]; then # checking container memory var. if exists
                        MEMORY="$(cat deger8.txt)";
                        if [[ "$(cat deger9.txt)" == "-c" && "$(cat deger10.txt)" != "" ]]; then # checking container cpu var. if exists
                            CPU="$(cat deger10.txt)";
                            if [[ "$(cat deger11.txt)" == "-N" && "$(cat deger12.txt)" != "" ]]; then # checking container name var. if exists
                                CONTAINER_NAME="$(cat deger10.txt)";
                            else
                                echo "Invalid Usage : $@"
                                usage
                            fi
                        else
                            echo "Invalid Usage : $@"
                            usage
                        fi
                    else
                        echo "Invalid Usage : $@"
                        usage
                    fi
                echo "Deploy Started !! "
                deploy
            else
                echo "Invalid Usage : $@"
                usage
            fi

        else
            echo "-n must be the second parameter!!"
            echo
            usage
        fi

    elif [[ $MODE == "build" ]]; then              # MODE = build 

        if [[ "$(cat deger3.txt)" == "-n" ]];then # checking image name if exists
            IMAGE_NAME="$(cat deger4.txt)";
            if [[ "$(cat deger5.txt)" == "-t" ]];then # checking image tag if exists
                IMAGE_TAG="$(cat deger6.txt)";
                    if [[ -e "deger7.txt" ]]; then # checking image registery if exists
                        REGISTERY="$(cat deger8.txt)";
                    fi
                echo "Build Started !! "
                build
            else
                echo "Invalid Usage : $@"
                usage
            fi

        else
            echo "-n must be the second parameter!!"
            echo
            usage
        fi
        

    elif [[ $MODE == "template" ]]; then            # MODE = template
        if [[ "$(cat deger3.txt)" == "-a" ]];then
            APPLICATION_NAME="$(cat deger4.txt)";
            template
        else
            echo "-a must be the second parameter!!"
            echo
            usage
        fi
    else
        echo "Invalid usage : $@"
        echo ""
        usage
    fi
    remove_files
else
    echo "-m must be the first parameter!!"
    echo
    usage
fi
