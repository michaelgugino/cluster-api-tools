#!/usr/bin/env bash

# https://stackoverflow.com/a/55796558/491522
getall() {
  for i in $(./oc api-resources --verbs=list --namespaced -o name | grep -v "events" | sort | uniq); do
    ./oc -n ${1} get --ignore-not-found=true ${i} -o jsonpath='{range .items[*]}{.metadata.namespace},{.kind},{.metadata.name},{.metadata.resourceVersion}{"\n"}{end}'
  done
}

clusterwide() {
  for object in $(./oc api-resources --verbs=list --namespaced=false -o name | sort | uniq);do
    ./oc get --ignore-not-found=true ${object} -o jsonpath='{range .items[*]}clusterwide,{.kind},{.metadata.name},{.metadata.resourceVersion}{"\n"}{end}'
  done
}

clusterwide2() {
  ./oc api-resources --verbs=list --namespaced=false -o name | sort | uniq | parallel -a - --jobs 20 ./oc get --ignore-not-found=true ${object} -o jsonpath='{range .items[*]}clusterwide,{.kind},{.metadata.name},{.metadata.resourceVersion}{"\n"}{end}'
}

# for project in $(./oc get project -o name | awk -F/ '{ print $2 }'); do
#  getall ${project}
# done

#clusterwide2

c3() {
for i in $(./kubectl get --raw / | jq '.paths | map(select(. | test("/v1")))[]' | sed -e 's/^"//' -e 's/"$//'); do
  for q in $(./oc get --raw $i | jq '.resources | map(select(.name | test("^\\w*$")))[].name' | sed -e 's/^"//' -e 's/"$//'); do
    echo $i/$q
    #./oc get --raw $i/$q
  done
done
}

sumf1 () {
./oc get --raw $1 | jq '.resources | map(select(.name | test("^\\w*$")))[].name' | sed -e 's/^"//' -e 's/"$//'
}

./kubectl get --raw / | jq '.paths | map(select(. | test("/v1")))[]' | sed -e 's/^"//' -e 's/"$//' | parallel -a - --jobs 20 ./apigetter.sh {= $args[0] =} --tag api/{}

