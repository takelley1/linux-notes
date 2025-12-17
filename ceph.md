# Ceph

- Run `ceph status` on the `rook-ceph-tools` pod in a k8s cluster
<br><br>
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
  ```
    additionalConfig:
      maxObjects: "100000000"
      maxSize: "100G"
