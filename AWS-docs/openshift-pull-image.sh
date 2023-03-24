#! /bin/bash

## Enable if oc activated linux bash
# oc_docker=`docker login -u developer -p $(oc whoami -t) 172.30.1.1:5000`
# echo "Login : 172.30.1.1:5000 as developer"; $oc_docker

registry="registry.overtech.com.tr/overtech/overbase:"
os_registry="172.30.1.1:5000/myproject/overbase_"

### created image list
declare -a OverpayRegistryArray

OverpayRegistryArray=(controllers_master daemons_notification_master services_master services_repository_master angular_master)

for tag in ${OverpayRegistryArray[@]}; do
	echo $tag
	docker pull ${registry}${tag}
	docker tag ${registry}${tag} ${os_registry}${tag}
	docker push ${os_registry}${tag}
	echo "${os_registry}${tag} was pushed"
done
