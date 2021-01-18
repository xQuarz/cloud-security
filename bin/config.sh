#!/bin/bash

##################################################
#
# Configuration settings for the Security showcase.
#
# This file defines some variables that can be used in other scripts by
# including it with: source config.sh
#
##################################################

# Persistent volume settings for keycloak postgres
PV_POSTGRES_PATH="/data/keycloak-postgres"
PV_POSTGRES_SIZE="1Gi"
PV_POSTGRES_VOLUMES_PER_NODE="3"
