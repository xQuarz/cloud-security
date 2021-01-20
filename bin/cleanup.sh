#!/bin/bash

##################################################
#
# Script that removes the whole security showcase.
#
##################################################

export KUBECONFIG=/home/quarz/.kube/config

. ${0%/*}/config.sh


##################################################
# Remove Helm Charts, persistent volumes and namespace
##################################################

# Delete helm charts

kubectl delete -f k8s/cloud-native-javaee/kubernetes/ -n $NAMESPACE

while [ -n "$(helm list --namespace $NAMESPACE | grep $NGINX)" ]
do
	helm uninstall $NGINX

	if [ $? == 0 ]
	then
		break
	fi
done

while [ -n "$(helm list --namespace $NAMESPACE | grep $KEYCLOAK)" ]
do
	helm uninstall $KEYCLOAK

	if [ $? == 0 ]
	then
		break
	fi
done


# Remove namespace security
kubens | grep $NAMESPACE
while [ -z "$?" ]
do
	kubectl delete ns $NAMESPACE

	if [ $? == 0 ]
	then
		break
	fi
done


##################################################
# Clean /etc/hosts
##################################################

clean_hosts_file() {
	for host in "$@"
	do
		sed -i "/127.0.0.1 $host.local/d" /etc/hosts
	done
}

clean_hosts_file $KEYCLOAK $DASHBOARD
