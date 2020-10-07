#!/bin/bash
./oc debug --image=rhel7/rhel-tools nodes/$1

# restart kubelet after you stop it: systemd-run --on-calendar="*-*-* 13:50" /usr/bin/systemctl restart kubelet
