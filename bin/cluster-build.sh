#!/bin/bash

####################################################
#
# Setup gke cluster
#
####################################################

#set -e

GKE=`gcloud container clusters list | grep ma`
if [[ -z $GKE ]]
then
	gcloud container clusters create ma --zone europe-west4-a --node-locations europe-west4-a --preemptible --num-nodes=5 --enable-autoscaling --max-nodes=5 --min-nodes=0 --machine-type=e2-medium
fi
