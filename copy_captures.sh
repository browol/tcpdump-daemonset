#!/bin/bash

# Prompt the user input, and set to default value if no input is provided
read -p "Enter the namespace (default: default): " NAMESPACE
NAMESPACE=${NAMESPACE:-"default"}

# Prompt the user input, and set to default value if no input is provided
read -p "Enter the release name (default: my-release): " RELEASE_NAME
RELEASE_NAME=${RELEASE_NAME:-"my-release"}

# Create local directory
LOCAL_PATH=captures/
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
      kubectl cp $NAMESPACE/$pod:$file $LOCAL_PATH/${file##*/}_${pod}
    done
  else
    echo "No capture files found in pod $pod."
  fi
done

echo "Finished copying capture files."
