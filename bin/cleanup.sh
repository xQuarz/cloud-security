#!/bin/bash

##################################################
#
# Script that removes the whole security showcase.
#
##################################################

export KUBECONFIG=/etc/kubernetes/admin.conf

. ${0%/*}/config.sh
. ~/.nodelist


##################################################
# Remove Helm Charts, persistent volumes and namespace
##################################################

# Delete helm charts
kubectl delete -f k8s/cloud-native-javaee/kubernetes/ -n security
helm uninstall keycloak

# Remove namespace security
kubectl delete ns security


##################################################
# Clean /etc/hosts
##################################################

clean_hosts_file() {
	for host in "$@"
	do
		sed -i "/127.0.0.1 $host.local/d" /etc/hosts
	done
}

clean_hosts_file keycloak dashboard-service
