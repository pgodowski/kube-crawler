#!/bin/sh


#for ns in `kubectl get namespaces --no-headers | awk '{ print $1; }'`; do 
for ns in `echo default`; do
    echo "Namespace: ${ns}, checking Pods"
    for pod in `kubectl get pods -n ${ns} --no-headers | awk '{ print $1; }'`; do
        #echo  "\tPod: ${pod}, namespace: ${ns}"
        for image in `kubectl get pod ${pod} -n ${ns} -o=jsonpath='{.spec.containers[*].image}'`; do
            echo  "\tPod: ${pod}, namespace: ${ns}, image: ${image}"

cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: scan-${pod}
  namespace: ${ns}
spec:
  template:
    spec:
      containers:
      - name: image-test
        image: ${image}
        command: ["find",  "/", "-name", "*.swidtag"]
      restartPolicy: Never
  backoffLimit: 1
EOF
# TODO: consolidate scan results
# TODO: do something with scan results
        done
    done
done