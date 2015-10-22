#! /bin/bash

yum -y install etcd kubernetes

ETCD_NAME=default >  /etc/etcd/etcd.conf
ETCD_DATA_DIR="/var/lib/etcd/default.etcd" >>  /etc/etcd/etcd.conf
ETCD_LISTEN_CLIENT_URLS="http://0.0.0.0:2379" >>  /etc/etcd/etcd.conf
ETCD_ADVERTISE_CLIENT_URLS="http://localhost:2379" >>  /etc/etcd/etcd.conf

KUBE_API_ADDRESS="--address=0.0.0.0" > /etc/kubernetes/apiserver
KUBE_API_PORT="--port=8080" >> /etc/kubernetes/apiserver
KUBELET_PORT="--kubelet_port=10250" >> /etc/kubernetes/apiserver
KUBE_ETCD_SERVERS="--etcd_servers=http://127.0.0.1:2379" >> /etc/kubernetes/apiserver
KUBE_SERVICE_ADDRESSES="--service-cluster-ip-range=10.254.0.0/16" >> /etc/kubernetes/apiserver
KUBE_ADMISSION_CONTROL="--admission_control=NamespaceLifecycle,NamespaceExists,LimitRanger,SecurityContextDeny,ResourceQuota" >> /etc/kubernetes/apiserver
KUBE_API_ARGS="" >> /etc/kubernetes/apiserver

for SERVICES in etcd kube-apiserver kube-controller-manager kube-scheduler; do 
    systemctl restart $SERVICES
    systemctl enable $SERVICES
    systemctl status $SERVICES 
done

etcdctl mk /coreos.com/network/config '{"Network":"172.17.0.0/16"}'

kubectl get nodes