alias k=kubectl
#### Demo 01
#Remove ns from yaml file and try
kubectl apply -f facebookdeployment.yaml -n test

#### Demo 02
#As singleton pods are not allowed, k8s warns us not to use them
kubectl apply -f singlepod.yaml --validate=false

#### Demo 03
#Check the pod events, created under deployments

#### Demo 04
#Node Afinity
kubectl label node worker01 color=blue
##How to unset Label
kubectl label node worker01 color-
##Verify Label being set
k describe node worker01 | grep blue

vi nodeAffinity.yaml
k apply -f nodeAffinity.yaml
k get pods -o wide | grep -i blue
#Check for Nodes, Pod being created

k delete -f https://raw.githubusercontent.com/swamguru/k8s-cka/main/L3-Cluster/kubesample.yaml
k apply -f https://raw.githubusercontent.com/swamguru/k8s-cka/main/L3-Cluster/kubesample.yaml
k get pods -o wide | grep -v blue
#Check for Nodes, Pod being created
k get pods -o wide | grep -i blue
---
#Lab Exercise
k label node worker01 disktype=ssd

#After applying pod with nodeName 
kubectl describe pod webserver -n twitter
#Check for node Name

kubectl get pods -n twitter -o wide
#Check for node Name

#### Demo 05
kubectl describe pod node-server

kubectl get pods
#Check for ready column

#### Demo 06
#Check resources of singleton pod too
kubectl describe pod node-server

#### Demo 07
#Check the DaemonSet manifest, to be created in kube-system ns
#Check the volume mount, that uses node's storage /var/log/ 
#Check the securityContext - privileged: true

kubectl get pods -A -o wide
k get ds -A
#Check for 2 Daemon Pods running, as we have 2 worker nodes

#### Demo 08
k describe pod 
#Check for 2 container IDs and status etc.

#Postgres deployment requires Credentials and volume
#Postgres - https://severalnines.com/database-blog/using-kubernetes-deploy-postgresql

#### Demo 09
#Reference: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/
#Set Node labels - Zone and Region
k label node worker02 zone=us-east-1a region=us-east-1

k apply -f topologySpread.yaml
k get pods -o wide

#### Demo 10
#Check for twitter ns
k get ns 
#Apply SingleReplica.yaml
k get rs -n twitter
---
#Autoscalling
wget https://kubernetes.io/examples/controllers/hpa-rs.yaml
k apply -f hpa-rs.yaml
k autoscale rs nginx-replica --max=3 --min=2 --cpu-percent=20 -n twitter
k get rs -n twitter

#### Demo 11
#Don't have to change the config and restart kubelet
#Create yaml file in static pod path in worker01
#In master node,
k get pods -A
#Pod will appear in default ns
#Delete the static pod file in worker01
#In master node,
k get pods -A
#Pod will DISappear in default ns

#### Demo 12
#Reported the Lab guide issue with Simplilearn

#### Demo 13
#passwords, secrets will not be shown
k get configmap game-Demo
k describe secrets dev-db-secret
#Reading Secrets 
## Direct assignment, where 'rootroot' is encode and stored in the file
k create secret `generic` app-secret --from-literal password=rootroot --dry-run -o yaml > secret.yml
### Decoding the text in secret.yml
echo "cm9vdHJvb3Q=" | base64 --decode

#### Demo 14
# Rolling Update Strategy
# maxSurge: The number of pods that can be created above the desired amount of pods during an update
# maxUnavailable: The number of pods that can be unavailable during the update process
k rollout history deployment/frontend
k rollout status deployment/frontend

#### Demo 15
k describe pod
#show restart policy

#### Demo 16
#Helm QuickStart: https://helm.sh/docs/intro/quickstart/
sudo snap install helm --classic              
helm version
sudo helm repo add bitnami https://charts.bitnami.com/bitnami
sudo helm repo update
sudo helm search repo bitnami
#Can view many big tools are available

#In a new terminal, run the below command
kubectl proxy --port=8080

sudo helm install bitnami/nginx --generate-name
k get deploy
    nginx-1631818923
k get pod

sudo helm uninstall nginx-1631818923
k get deploy
