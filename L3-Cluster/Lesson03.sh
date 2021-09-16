#### Demo 1
kubeadm version
kubectl version

sudo kubeadm init --pod-network-cidr=192.168.0.0/16

#you can join any number of worker nodes by running the following on each as root:

kubeadm join 172.31.24.0:6443 --token z3tmaz.oz0z15630c8b18tc \
    --discovery-token-ca-cert-hash sha256:4e97a757fa79e2d0f66a9904d4e36c417406c6a8a2395fa4e682c2e8a285a9cb

echo $HOME
# env are case-sensitive, try $home, it will return no output

mkdir -p $HOME/.kube
# $HOME and ~ are same

# sudo cat /etc/kubernetes/admin.conf
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
# cat ~/.kube/config - permission denied, adding sudo will work

# Get User and group: id -u and id -g
sudo chown $(id -u):$(id -g) $HOME/.kube/config
# cat ~/.kube/config - works now

# Inspect calico.yaml manifest - Show Roles and RoleBinding etc
#Exam Tip: this URL will not be provided in CKA exam
kubectl apply -f \
https://docs.projectcalico.org/v3.8/manifests/calico.yaml

kubectl get nodes
kubectl get namespaces
# kubectl get ns

# Use kubeadm join command with sudo in Worker Nodes

kubectl get nodes

#Let's examine the cluster
kubectl get pods -A
kubectl get pods -n kube-system
#Look into /etc/kubernetes/manifests

service kubelet status

#Note: if there are any issue occured while doing `kubeadm init` or `kubeadm join`, 
#then reset the configurations
kubeadm reset
#on both master and worker nodes

#### Demo 2
kubectl get nodes #Verify k8s cluster is setup

# On the Master node
pwd
cd ~
mkdir configfiles
cd configfiles

vi kubesample.yaml
#Copy contents in kubesample.yaml

#Inspect yaml file
cat kubesample.yaml

kubectl apply -f kubesample.yaml

kubectl get all
kubectl get deploy
kubectl get rs
kubectl get pods
kubectl get pods -l app=redis
#Use other labels to view pods or get all

#### Demo 3
# On the Master node
# etcd
sudo apt install etcd-server
# provide 'n' option to skip new version installation

etcd --version
etcd --name check
etcd --help

man snap
#press q to exit

sudo snap install kube-controller-manager
kube-controller-manager --version
kube-controller-manager --help

sudo snap install kube-scheduler
kube-scheduler --help
kube-scheduler --version

kubelet --version
kubelet --help
sudo kubelet
kubelet --one-output

sudo snap install kube-proxy --classic
kube-proxy --version
kube-proxy --help


kubectl get all 
kubectl get deploy -A
kubectl get rs -A
kubectl get pods -A
kubectl get svc -A

docker ps

#### Demo 4
sudo kubeadm certs check-expiration

kubectl cluster-info
kubectl create ns firstnamespace
kubectl get ns

kubectl config view
kubectl proxy --port=8080
# use ctrl+c to close

#### Demo 5
# Verify cluster is setup
kubectl get nodes

kubectl describe node <node-name> | less
# Look at Status(should be FALSE), Address, Capacity and Events 

kubectl delete node 
kubectl get nodes

cd configfiles; vi nodereg.json

kubectl create -f nodereg.json
kubectl get nodes
kubectl describe node <node-name> | less

#### Demo 6
kubeadm token generate
sudo kubeadm certs check-expiration
kubeadm certs certificate-key
kubeadm config print init-defaults
ls /etc/kubernetes/pki
#view certificate and keys stored

#### Demo 7
sudo kubelet --container-runtime docker
sudo vi /var/lib/kubelet/config.yaml
# modify field values in seconds
# /var/lib/kubelet contains static pod and other pod manifests 

sudo systemctl daemon-reload
sudo systemctl restart kubelet

##### Only specific commands, not in Practice docs
#### Demo 8
kubectl auth can-i list pods --as labsuser
yes
kubectl auth can-i create pods --as labsuser
no

#### Demo 9
# walkthrough
kubectl api-resources
kubectl explain pod.spec.volumes --recursive

#### Demo 10
sudo kubeadm reset
# verify kubectl commands

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version\
=$(kubectl version | base64 |tr -d '\n')"
# weavenet adds more feature in firewall rules than calico
# but calico is fine for k8s prod cluster

#### Demo 11
#URL: https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/#backing-up-an-etcd-cluster
# Restore and backup

## Version of ETCD running on the cluster
kubectl describe pod etcd-master -n kube-system | grep -i image
Image:         k8s.gcr.io/etcd:3.4.3-0

## what address do you reach the ETCD cluster from your master node
kubectl describe pod etcd-master -n kube-system and look for --listen-client-urls
--listen-client-urls=https://127.0.0.1:2379,https://172.17.0.25:2379

## ETCD - Backup
### Step 1: Get urls and keys
kubectl describe pod etcd-master -n kube-system
Get client-url, cert, key and trusted-ca location

### Step 2: Command
ETCDCTL_API=3 etcdctl snapshot save etcd_backup.db \
--endpoints https://127.0.0.1:2379 \
--cert=/etc/kubernetes/pki/etcd/server.crt \
--key=/etc/kubernetes/pki/etcd/server.key \
--cacert=/etc/kubernetes/pki/etcd/ca.crt 

#### Demo 12
## Find available version for upgrade
kubeadm upgrade plan

## Preparing master node for upgrade
### 1. MASTER
sudo kubeadm upgrade plan
k cordon master
### If Existing version is v1.19.x, we have to upgrade first to v1.20.0 before v1.21.0
kubeadm upgrade apply v1.20.11
sudo kubeadm upgrade plan
apt update
apt-cache madison kubeadm
k get nodes -o wide
apt-mark unhold kubeadm && apt-get update && apt-get install -y kubeadm=1.21.0-00
apt-mark hold kubeadm
apt-get update && apt-get install -y --allow-change-held-packages kubeadm=1.21.0-00
kubectl drain master --ignore-daemonsets
sudo kubeadm upgrade plan
sudo kubeadm upgrade apply v1.21.0
sudo kubeadm upgrade node
kubectl uncordon master
kubectl get nodes -o wide
apt-mark unhold kubelet kubectl && apt-get update && apt-get install -y kubelet=1.21.0-00 kubectl=1.21.0-00
apt-mark hold kubelet kubectl
apt-get update && apt-get install -y --allow-change-held-packages kubelet=1.21.0-00 kubectl=1.21.0-00
kubectl get nodes -o wide
sudo systemctl daemon-reload
sudo systemctl restart kubelet

## NODE01
@Master Node
k drain node01
k drain node01 --ignore-daemonsets

@Node01
apt-mark unhold kubeadm && apt-get update && apt-get install -y kubeadm=1.21.0-00
apt-mark hold kubeadm
apt-get update && apt-get install -y --allow-change-held-packages kubeadm=1.21.0-00
kubectl drain node01
sudo kubeadm upgrade node
apt-mark unhold kubelet kubectl && apt-get update && apt-get install -y kubelet=1.21.0-00 kubectl=1.21.0-00
apt-mark hold kubelet kubectl
apt-get update && apt-get install -y --allow-change-held-packages kubelet=1.21.0-00 kubectl=1.21.0-00
sudo systemctl daemon-reload
sudo systemctl restart kubelet

@master
kubectl uncordon node01

#### Demo 13
kubectl get pods -o json
kubectl get pods <pod-name> -o json

kubectl get pods -o=jsonpath='{@}'
kubectl get pods -o=jsonpath='{.items[0]}'
kubectl get pods -o=jsonpath='{.items[0].metadata.name}'

k get nodes -o jsonpath='{.items[*].metadata.name}'
master node01

k get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}'
master
node01

k get nodes -o jsonpath='{range .items[*]}{.status.nodeInfo.osImage}{"\n"}'
Ubuntu 18.04.4 LTS
Ubuntu 18.04.4 LTS

k config view --kubeconfig=my-kube-config -o jsonpath='{range .users[*]}{.name}{"\n"}'
aws-user
dev-user
test-user

kubectl get pods -o=jsonpath="{.items[*]['metadata.name', 'status.capacity']}"
kubectl get pods -o=jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.startTime}{"\n"}{end}'

# Sort-by
k get pv --sort-by=.spec.capacity.storage

# Custom Columns
k get pv -o=custom-columns='NAME:.metadata.name,CAPACITY:.spec.capacity.storage'

# Sort-by + Custom Column
k get pv -o=custom-columns='NAME:.metadata.name,CAPACITY:.spec.capacity.storage' --sort-by=.spec.capacity.storage
NAME       CAPACITY
pv-log-4   40Mi
pv-log-1   100Mi
pv-log-2   200Mi
pv-log-3   300Mi