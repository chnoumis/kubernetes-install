#! /bin/bash

ETCD_HOST=127.0.0.1
KUBE_MASTER_HOST=127.0.0.1
KUBELET_HOST=127.0.0.1

yum -y install flannel kubernetes

FLANNEL_ETCD="http://${ETCD_HOST}:2379"

KUBE_MASTER="--master=http://${KUBE_MASTER_HOST}:8080"

echo KUBELET_ADDRESS="--address=0.0.0.0" > /etc/kubernetes/kubelet 
echo KUBELET_PORT="--port=10250" >> /etc/kubernetes/kubelet 
# change the hostname to this host’s IP address
echo KUBELET_HOSTNAME="--hostname_override=${KUBELET_HOST}" >> /etc/kubernetes/kubelet 
echo KUBELET_API_SERVER="--api_servers=http://${KUBE_MASTER_HOST}:8080" >> /etc/kubernetes/kubelet 
echo KUBELET_ARGS="" >> /etc/kubernetes/kubelet 

for SERVICES in kube-proxy kubelet docker flanneld; do 
    systemctl restart $SERVICES
    systemctl enable $SERVICES
    systemctl status $SERVICES 
done

ip a | grep flannel | grep inet
inet 172.17.45.0/16 scope global flannel0

kubectl get nodes