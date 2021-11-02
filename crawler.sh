#!/bin/sh


for ns in `kubectl get namespaces --no-headers | awk '{ print $1; }'`; do 
    echo "Namespace: ${ns}, checking Pods"
    for pod in `kubectl get pods -n ${ns} --no-headers | awk '{ print $1; }'`; do
        #echo  "\tPod: ${pod}, namespace: ${ns}"
        for image in `kubectl get pod ${pod} -n ${ns} -o=jsonpath='{.spec.containers[*].image}'`; do
            echo  "\tPod: ${pod}, namespace: ${ns}, image: ${image}"
        done
    done
done