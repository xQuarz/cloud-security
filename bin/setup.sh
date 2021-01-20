#!/bin/bash

##################################################
#
# The script installs all components of the showcase in the Kubernetes cluster.
#
##################################################

export KUBECONFIG=/home/quarz/.kube/config

cd "${0%/*}/.."

. ${0%/*}/config.sh


# namespace for showcase

kubens | grep $NAMESPACE
while [ -z "$?" ] 
do
	kubectl create ns $NAMESPACE

	if [[ $? == 0 ]]
	then
		break
	fi
done


####################################################
# Install Keycloak
####################################################

helm repo add codecentric https://codecentric.github.io/helm-charts --force-update
helm repo update

while [ -z "$(helm list --namespace $NAMESPACE | grep $KEYCLOAK)" ]
do
	helm install $KEYCLOAK codecentric/$KEYCLOAK --namespace $NAMESPACE \
 	 --values k8s/$KEYCLOAK-helm/values.yaml
	
	if [ $? == 0 ]
	then
		break
	fi

	helm uninstall $KEYCLOAK
done


####################################################
# Install showcase
####################################################

sed -i "s/traefik/nginx/g" k8s/cloud-native-javaee/kubernetes/dashboard-service-ingress.yaml

helm repo add nginx-stable https://helm.nginx.com/stable --force-update
helm repo update

while [ -z "$(helm list --namespace $NAMESPACE | grep $NGINX)" ]
do
	helm install $NGINX nginx-stable/nginx-ingress --namespace $NAMESPACE --set controller.hostNetwork=true,controller.service.type="",controller.kind=DaemonSet
	
	if [ $? == 0 ]
	then
		break
	fi

	helm uninstall $NGINX
done

while :
do
	kubectl apply -f k8s/cloud-native-javaee/kubernetes/ -n $NAMESPACE --validate=false
	
	if [ $? == 0 ]
	then
		break
	fi

	kubectl delete -f k8s/cloud-native-javaee/kubernetes/ -n $NAMESPACE
done


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

modify_hosts_file $KEYCLOAK $DASHBOARD
