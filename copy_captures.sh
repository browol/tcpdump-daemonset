#!/bin/bash

# Define variables
NAMESPACE=default
RELEASE_NAME=my-release
CAPTURE_PREFIX=capture_
LOCAL_PATH=./captures

# Create local directory
mkdir -p $LOCAL_PATH

# Get all Pods created by the DaemonSet
PODS=$(kubectl get pods -n $NAMESPACE -l app.kubernetes.io/instance=$RELEASE_NAME -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')

# Loop over each Pod and copy the capture files
for pod in $PODS
do
  echo "Checking pod $pod..."
  # Check if the Pod has any capture files
  files=$(kubectl exec $pod -n $NAMESPACE -- /bin/sh -c "ls /tmp/*.pcap" 2>/dev/null)
  if [[ -n "$files" ]]; then
    echo "Found capture files in pod $pod:"
    echo "$files"
    # Copy the capture files to the local directory
    for file in $files
    do
      echo "Copying $file from $pod..."
      kubectl cp $NAMESPACE/$pod:$file $LOCAL_PATH/${pod}_${file##*/}
    done
  else
    echo "No capture files found in pod $pod."
  fi
done

echo "Finished copying capture files."
