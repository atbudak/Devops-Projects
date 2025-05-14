# OPENSHIFT CLUSTER INFO

### Mac, Linux ya da Windows sunucuda oc cli kullanımı

openshift console da sağ üstteki soru işaritinden os.tar dosyası indirilir. tar ile açılıp $PATH dosyasına eklenir.

(linux için) 
```
tar -xvf oc.tar
sudo mv oc /usr/local/bin
```

Daha sonra user bölümünden copy-login command ile token alınıp clustera login olunur.
```
oc login --token=<token>--server=https://api.lotoc01.overtech.com.tr:6443
```

### to connect cli via powershell
$env:KUBECONFIG="C:\Users\ahmet\OneDrive\Documents\Openshift-cli\openshift-client-windows\kubeconfig-noingress-openshift"

### adding openshift(oc.exe) executable file to PATH
```
 mkdir C:\bin
 # move oc.exe to `C:\bin`
 setx PATH "C:\bin;%PATH%"
```
then restart the terminal. [oc install link](https://zwbetz.com/how-to-add-a-binary-to-your-path-on-macos-linux-windows/)

oc get pods

### print all env
Get-ChildItem Env:

## serviceaccount policys
https://cloud.redhat.com/blog/managing-sccs-in-openshift


## Create user on Openshift using htpasswd
[yt source](https://www.youtube.com/watch?v=hbCQihvBaYU)
### creates file
htpasswd -c -B -b ./openshift.htpasswd user1 1234

### appends file
htpasswd -B -b ./openshift.htpasswd user2 1234

# giving user access to project
oc adm policy add-role-to-user edit developer -n pavopay-dev
[roles documentation](https://docs.openshift.com/container-platform/4.12/authentication/using-rbac.html#adding-roles_using-rbac)

# Delete the User object:
oc delete user <username>

# Delete the Identity object for the user:
oc delete identity my_htpasswd_provider:<username>

## env var for dotnet core application
ASPNETCORE_URLS=http://*:8080

# expose 8080


# oc serverın timezone değiştirme
## admin user ile giriş yapıyoruz ve Administrator > Compute > Nodes > Terminal'e giriyoruz.
## local zonu silip yeni tz ayarlıyoruz
[timezone ayarlama linki](https://linuxize.com/post/how-to-set-or-change-timezone-in-linux/)

```
sudo rm -rf /etc/localtime
sudo ln -s /usr/share/zoneinfo/Europe/Istanbul /etc/localtime
date
```

### If you do not want the Cluster Version Operator to fetch available updates from the update recommendation service :

```
 oc adm upgrade channel --allow-explicit-channel
```

 warning: Clearing channel "stable-4.12"; cluster will no longer request available update recommendations.
 [release page link](https://access.redhat.com/documentation/en-us/openshift_container_platform/4.12/html/updating_clusters/understanding-upgrade-channels-releases#understanding-upgrade-channels_understanding-upgrade-channels-releases)

### change  default namespace
```
 oc config set-context --current --namespace="pavopay-dev"
 ```

 ### adding route annotations for load balancing
```
metadata:
  annotations:
    haproxy.router.openshift.io/balance: roundrobin
    haproxy.router.openshift.io/disable_cookies: 'true'  
```


 [resouce link](https://docs.openshift.com/container-platform/4.11/networking/routes/route-configuration.html#nw-route-specific-annotations_route-configuration)


### Slack Notification'u AlertManager'e entegre etme

Slack app panelinden bir uygulama oluşturuyoruz, daha sonra uygulamaya girip webhook adresi oluşturuyoruz. https://api.slack.com/apps

AlertManager configiration detayından receivers ekliyoruz. 

  Slack API URL : https://hooks.slack.com/services/xxx/xxx (webhook adresi)
  Channel : General (slack app panaelinde kanala göre webhook çıkarıyoruz. Çıkardığımız channel' i buraya yazıyoruz)
  Routing labels: severity=Critical, alertname=Watchdog, all=all (default)


 [monitoring resouce link](https://docs.openshift.com/container-platform/4.11/monitoring/managing-alerts.html)

 ### Get Wildcard Certificate 

DNS recorda (IHS) TXT kaydı olarak _acme-challenge.apps.lotoc01.overtech.com.tr = given value from letsencrypt

```
 sudo certbot run --cert-name apps.lotoc01.overtech.com.tr -a manual -d *apps.lotoc01.overtech.com.tr -i nginx 
 ```
 
 [expand certificate resouce link](https://community.letsencrypt.org/t/how-to-expand-certificate-with-a-wildcard-subdomain/133925)


# Creating NFS Povisioner for Automate PV Creation

### Creating new project for provisioner and install 'NFS Provisioner Operator' from OperatorHub

```
oc new-project nfsprovisioner-operator
```

### Getting target node
```
export target_node=$(oc get node --no-headers -o name|cut -d'/' -f2)
```

### Adding label for our node which will used for provision

```
oc label node <target_node>lotoc01 app=nfs-provisioner
```

### Logging in node, creating nfs file path, and 
```
oc debug node/lotoc01 
chroot /host
mkdir -p /home/core/nfs
chcon -Rvt svirt_sandbox_file_t /home/core/nfs
```
### Create and apply nfsprovisioner.yaml

```
apiVersion: cache.jhouse.com/v1alpha1
kind: NFSProvisioner
metadata:
  name: nfsprovisioner-sample
  namespace: nfsprovisioner-operator
spec:
  nfsImageConfiguration:
    image: k8s.gcr.io/sig-storage/nfs-provisioner:v3.0.1
    imagePullPolicy: IfNotPresent
  scForNFS: nfs
  hostPathDir: "/home/core/nfs"
```
oc apply -f .\NFSprovisioner.yml

Patch storageclass :

```
oc patch storageclass nfs -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}' -n nfsprovisioner-operator
```
(It could throws error on powershell)


### Checking Access of user on K8s

```
kubectl auth can-i create deployments --as bob --namespace developer
```


## Secure Connect To Portals, TLS Configurations

Getting Cert and Key file with Letsencrypt:

```bash
 sudo certbot run --cert-name apps.lotoc01.overtech.com.tr -a manual -d *apps.lotoc01.overtech.com.tr -i nginx 
```

After getting key and cert file, We will follow this steps: 

```bash
  oc create configmap custom-ca --from-file=ca-bundle.crt=</path/to/example-ca.crt> -n openshift-config
```

```bash
  oc patch proxy/cluster --type=merge --patch='{"spec":{"trustedCA":{"name":"custom-ca"}}}'
```


```bash
  oc create secret tls <secret> --cert=</path/to/cert.crt> --key=</path/to/cert.key> -n openshift-ingress
```

```bash
oc patch ingresscontroller.operator default --type=merge -p '{"spec":{"defaultCertificate": {"name": "<secret>"}}}' -n openshift-ingress-operator
```

 - [Resource Link.](https://docs.openshift.com/container-platform/4.12/security/certificates/replacing-default-ingress-certificate.html#replacing-default-ingress_replacing-default-ingress) 
