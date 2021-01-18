#!/bin/bash

##################################################
#
# The script installs the Gravitee image in the Kubernetes cluster.
#
##################################################

export KUBECONFIG=/etc/kubernetes/admin.conf

cd "${0%/*}/.."

# namespace for showcase
ns=security

kubectl create ns $ns

####################################################
# Install Keycloak
####################################################

# Install postgres
sh bin/setup-pv-for-keycloak-postgres.sh

helm install --name keycloak --namespace $ns \
 -f k8s/keycloak-helm/values.yaml stable/keycloak


####################################################
# Install showcase
####################################################

sed -i "s/traefik/nginx/g" k8s/cloud-native-javaee/kubernetes/dashboard-service-ingress.yaml
kubectl apply -f k8s/cloud-native-javaee/kubernetes/ -n $ns


####################################################
# Modify /etc/hosts of master node
####################################################

modify_hosts_file() {
	# loop for all parameters
	for host in "$@"
	do
		grep -q -F "127.0.0.1 $host.local" /etc/hosts || \
		echo "127.0.0.1 $host.local" >> /etc/hosts
	done
}

modify_hosts_file keycloak dashboard-service
