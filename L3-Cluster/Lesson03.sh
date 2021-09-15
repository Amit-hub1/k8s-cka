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
