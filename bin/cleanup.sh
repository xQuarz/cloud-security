#!/bin/bash

##################################################
#
# Script that removes the whole security showcase.
#
##################################################

set -e

export KUBECONFIG=/home/quarz/.kube/config

. ${0%/*}/config.sh

SEC_NS=`kubens | grep $NAMESPACE`
if [[ -z $SEC_NS ]] 
then
	exit 0
fi

kubectl config set-context --current --namespace=$NAMESPACE

##################################################
# Remove Helm Charts, showcase and namespace
##################################################

# Delete helm charts
#kubectl delete -f k8s/cloud-native-javaee/kubernetes/
kubectl delete -f k8s/cloud-native-javaee/kubernetes/billing-db-deployment.yaml
kubectl delete -f k8s/cloud-native-javaee/kubernetes/billing-db-service.yaml
kubectl delete -f k8s/cloud-native-javaee/kubernetes/billing-service-deployment.yaml
kubectl delete -f k8s/cloud-native-javaee/kubernetes/billing-service-service.yaml
kubectl delete -f k8s/cloud-native-javaee/kubernetes/billing-service-configmap.yaml

kubectl delete -f k8s/cloud-native-javaee/kubernetes/dashboard-service-deployment.yaml
kubectl delete -f k8s/cloud-native-javaee/kubernetes/dashboard-service-ingress.yaml
kubectl delete -f k8s/cloud-native-javaee/kubernetes/dashboard-service-service.yaml

kubectl delete -f k8s/cloud-native-javaee/kubernetes/datagrid-hazelcast-service.yaml
kubectl delete -f k8s/cloud-native-javaee/kubernetes/datagrid-service-configmap.yaml
kubectl delete -f k8s/cloud-native-javaee/kubernetes/datagrid-service-deployment.yaml
kubectl delete -f k8s/cloud-native-javaee/kubernetes/datagrid-service-service.yaml

kubectl delete -f k8s/cloud-native-javaee/kubernetes/message-queue-deployment.yaml
kubectl delete -f k8s/cloud-native-javaee/kubernetes/message-queue-service.yaml

kubectl delete -f k8s/cloud-native-javaee/kubernetes/payment-db-deployment.yaml
kubectl delete -f k8s/cloud-native-javaee/kubernetes/payment-db-service.yaml
kubectl delete -f k8s/cloud-native-javaee/kubernetes/payment-service-deployment.yaml
kubectl delete -f k8s/cloud-native-javaee/kubernetes/billing-service-service.yaml
kubectl delete -f k8s/cloud-native-javaee/kubernetes/billing-service-configmap.yaml

kubectl delete -f k8s/cloud-native-javaee/kubernetes/process-db-deployment.yaml
kubectl delete -f k8s/cloud-native-javaee/kubernetes/process-db-service.yaml
kubectl delete -f k8s/cloud-native-javaee/kubernetes/process-service-deployment.yaml
kubectl delete -f k8s/cloud-native-javaee/kubernetes/process-service-service.yaml
kubectl delete -f k8s/cloud-native-javaee/kubernetes/process-service-configmap.yaml


HELM_NGINX=`helm list | grep $NGINX`
if [[ -n $HELM_NGINX ]]
then
	helm uninstall $NGINX
fi

HELM_KEYCLOAK=`helm list | grep $KEYCLOAK`
if [[ -n $HELM_KEYCLOAK ]]
then
	helm uninstall $KEYCLOAK
fi

# Remove namespace security
SEC_NS=`kubens | grep $NAMESPACE`
if [[ -n $SEC_NS ]] 
then
	kubectl delete ns $NAMESPACE
fi


# ##################################################
# # Clean /etc/hosts
# ##################################################

# clean_hosts_file() {
# 	for host in "$@"
# 	do
# 		sed -i "/127.0.0.1 $host.local/d" /etc/hosts
# 	done
# }

# clean_hosts_file $KEYCLOAK $DASHBOARD
