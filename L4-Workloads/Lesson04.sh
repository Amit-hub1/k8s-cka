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
