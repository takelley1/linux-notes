# Ceph

## Useful commands

- From the `rook-ceph-tools` pod in a k8s cluster:
  - `ceph health status` or `ceph -s` = Short summary of overall pool status.
  - `ceph health detail` = More specific pool health information
  - `ceph osd tree` = Map of OSDs to hosts, showing which OSDs are up/down.
  - `ceph osd perf` = Identify slow OSDs.
  - `ceph df` = Per-pool storage usage.
  - `ceph osd pool ls detail` = All pools with detailed configuration.
  - `ceph health mute BLUESTORE_SLOW_OP_ALERT` = Ignore the slow Bluestore operations alert. This will prevent the alert from putting the Ceph cluster into a HEALTH_WARN state and masking other issues or causing alert fatigue.
<br><br>
- Tune Ceph for use with SSDs:
  - `ceph config set class:ssd bdev_enable_discard true`
  - `ceph config set class:ssd bdev_async_discard_threads 1`

## Troubleshooting

- Issue: Zarf K8s install won't work since Ceph is degraded
  - Symptoms: `zarf describe cephblockpool/ceph-blockpool -n rook-ceph` Shows a `signal: interrupt` error
  - Symptoms: `zarf tools kubectl exec -it ROOK_CEPH_TOOLS_POD -n rook-ceph -- ceph status` Shows a `HEALTH_WARN` status
  - Symptoms: `zarf tools kubectl exec -it ROOK_CEPH_TOOLS_POD -n rook-ceph -- ceph osd tree` Shows no OSDs, just a -1
  - Root cause: The ceph volume at `/dev/sdb` wasn't fully wiped before installing the cluster, so some data was leftover. On the infrastructure nodes, run `lsblk -f` and look for `ceph_bluestore` to confirm this.
- Fix: Completely wipe `/dev/sdb` on all the infrastrucure nodes:
  ```bash
  sudo -s
  DISK=/dev/sdb
  wipefs -a $DISK
  sgdisk --zap-all $DISK
  dd if=/dev/zero of="$DISK" bs=1K count=200 oflag=direct,dsync seek=0
  dd if=/dev/zero of="$DISK" bs=1K count=200 oflag=direct,dsync seek=$((1 * 1024**2))
  dd if=/dev/zero of="$DISK" bs=1K count=200 oflag=direct,dsync seek=$((10 * 1024**2))
  dd if=/dev/zero of="$DISK" bs=1K count=200 oflag=direct,dsync seek=$((100 * 1024**2))
  dd if=/dev/zero of="$DISK" bs=1K count=200 oflag=direct,dsync seek=$((1000 * 1024**2))
  ```

## Reference

- Create ceph S3-compatible buckets for Mimir:
  ```yaml
  ---
  apiVersion: objectbucket.io/v1alpha1
  kind: ObjectBucketClaim
  metadata:
    name: mimir-ruler
  spec:
    bucketName: mimir-ruler
    storageClassName: ceph-bucket
    additionalConfig:
      maxObjects: "100000000"
      maxSize: "100G"
  ---
  apiVersion: objectbucket.io/v1alpha1
  kind: ObjectBucketClaim
  metadata:
    name: mimir-blocks
  spec:
    bucketName: mimir-blocks
    storageClassName: ceph-bucket
    additionalConfig:
      maxObjects: "100000000"
      maxSize: "100G"
  ---
  apiVersion: objectbucket.io/v1alpha1
  kind: ObjectBucketClaim
  metadata:
    name: mimir-alerts
  spec:
    bucketName: mimir-alerts
    storageClassName: ceph-bucket
    additionalConfig:
      maxObjects: "100000000"
      maxSize: "100G"
  ```
