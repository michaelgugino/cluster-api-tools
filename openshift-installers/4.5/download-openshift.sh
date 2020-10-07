#!/bin/bash

wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp-dev-preview/latest-4.5/openshift-client-linux.tar.gz &
pid1=$1
wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp-dev-preview/latest-4.5/openshift-install-linux.tar.gz
tar xvf openshift-install-linux.tar.gz
wait $pid1
tar xvf openshift-client-linux.tar.gz
