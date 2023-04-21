# TCPDump DaemonSet Helm Chart

This Helm chart deploys a DaemonSet with a container running a `tcpdump` command to capture network traffic for debugging purposes. The captured traffic can be filtered by IP and port, and the output can be rotated based on time or size.

## Prerequisites

- Kubernetes cluster
- Helm CLI installed

## Configuration

The following table lists the configurable parameters of the TCPDump DaemonSet Helm chart and their default values.

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `image.repository` | Docker image repository | `hwchiu/netutils` |
| `image.tag` | Docker image tag | `latest` |
| `image.pullPolicy` | Docker image pull policy | `IfNotPresent` |
| `resources` | Resource requests and limits for the container | `{}` |
| `command` | The command to run `tcpdump` in the container | See below |
| `envs.HOST_IP` | IP address to filter the captured traffic | `10.0.2.196` |
| `envs.HOST_PORT` | Port number to filter the captured traffic | `8080` |
| `envs.ROTATE_EVERY_N_SECONDS` | Rotate the capture file every N seconds | `3600` |
| `envs.ROTATE_EVERY_N_SIZE_MB` | Rotate the capture file every N MB | `10` |

By default, the `tcpdump` command used in the container is:

```yaml
command:
  - /bin/sh
  - -c
  - tcpdump -i any -w "capture_%Y-%m-%d_%H-%M-%S.pcap" -G $ROTATE_EVERY_N_SECONDS -C $ROTATE_EVERY_N_SIZE_MB "host $HOST_IP and port $HOST_PORT"
```

You can customize the command and environment variables in the `values.yaml` file.

Note: The default working directory for the tcpdump container is /tmp. If you need to modify the tcpdump command to write to a different directory, you may need to adjust the container's workingDir field in the Helm chart.

## Installing the Chart

To install the chart with the release name `my-release`, run:

```bash
$ helm install my-release /path/to/tcpdump-daemonset
```

Replace `/path/to/tcpdump-daemonset` with the actual path to the chart directory.

## Uninstalling the Chart

To uninstall the `my-release` deployment, run:

```bash
$ helm uninstall my-release
```

This command removes all the Kubernetes components associated with the chart and deletes the release.

## Usage

After deploying the Helm chart, the DaemonSet will create a Pod on each node in the cluster with a container running the `tcpdump` command. The container will capture network traffic based on the provided IP address and port, and rotate the output based on the provided time or size.

You can customize the capture settings by modifying the environment variables in the `values.yaml` file.

### Copying TCPdump capture files

To copy the TCPdump capture files from the `/tmp` directory of the TCPdump Pods to your local machine, you can use the following bash script:

1. Open the `copy_captures.sh` script file in a text editor.

2. Edit the following parameters to match your environment:

   - `RELEASE_NAME`: The name of your TCPdump DaemonSet release.
   - `CAPTURE_PREFIX`: The prefix used for your capture files, if different.
   - `LOCAL_DIR`: The local directory where you want to save the capture files.

3. Save the script file and close the text editor.

4. Open a terminal window and navigate to the directory where the script file is saved.

5. Run the script file using the following command:

   ```bash
   bash copy_captures.sh
   ```

This script will copy all TCPdump capture files from the `/tmp` directory of the TCPdump Pods to a folder named after the Pod name on your local machine.

Note that this script assumes that you have `kubectl` installed and configured to connect to your Kubernetes cluster. Also, be aware that copying large capture files can take some time, and may require additional storage space on your local machine.