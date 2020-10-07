#!/bin/bash

# pretty much required for anything
./oc scale -n openshift-cluster-version deployment/cluster-version-operator --replicas=0
# required/makes it easier if you want to edit deployments managed by this operator
./oc scale -n openshift-machine-api deployment/machine-api-operator --replicas=0
