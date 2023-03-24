# https://github.com/minishift/minishift/releases adresten son versiyonu indiriyoruz. İndirilen yerden exe dosyası ile çalıştırıyoruz.

#### INFORMATION
# Minishift başlatabilmek için biostan virtualization ayarı açılmalı, Feature On/Off 'tan Hyper-V disable edilmeli(Virtualbox kullanılacaksa) ve Virtual Machine Platform disable edilmeli
#
# - save-start-flags: true bu değeri false yapılırsa kubernetes ayarları .kube/config'den silinmiyor, hata alıyor
# ~/.minishift dosyası server ayarlarını tutuyor. Sürekli hata alması durumunda silinebilir.
##  https://stackoverflow.com/questions/57436612/error-when-executing-minishift-start-connect-connection-refused

./minishift.exe start --cpus 4 --memory 6144 --vm-driver=virtualbox 

# server oluşturulduktan sonra openshift(oc) komut satırı kullanabilmek için env var eklenmeli

./minishift.exe oc-env  # bu komut oc için env var değeri verir

./minishift.exe docker-env  # Virtual Machine Platform disable edildiği için docker komutları kullanmıyoruz. Bu komutla env var değerleri alır ve komutları çalıştırabiliriz.

# Login as developer:
oc login -u developer

# Login as admin: 
oc login -u system:admin

# Get token:
oc whoami -t

# API call:
curl -k https://192.168.99.100:8443/oapi/v1/projects -H "Authorization: Bearer <token>"

# Herhangi bir usera admin yekisi verme system:admin kullanıcısıyla
oc adm policy add-cluster-role-to-user cluster-admin developer(user)

# run-docker-image-as-root :
create service account:  oc create sa ahmet-sa
oc adm policy add-scc-to-user anyuid -z ahmet-sa(serviceaccount) developer(user)

DeploymentConfig -> add under spec>template>spec

      serviceAccount: ahmet-sa
      serviceAccountName: ahmet-sa

oc set serviceaccout deployment reactapp ahmet-sa

# login oc registry
docker login -u developer -p $(oc whoami -t) 172.30.1.1:5000

    -> openshift-pull-image.sh (pull image from local repo and push oc registry)

# oc serverın timezone değiştirme

./minishift.exe ssh -- "sudo timedatectl set-timezone Europe/Istanbul"