## LangFuse

### AWS backup and restore checklist

#### Backup
- Enable S3 versioning for event storage.
- Enable RDS snapshots for state storage.
- Enable EC2 volume snapshots for instance and Docker volume storage.

#### Restore
- Restore RDS snapshot to a new instance.
- Restore EC2 snapshot to a new instance.
  - Point LangFuse to new RDS instance.
- Update target group in ALB with new EC2 instance IP.
- Update DNS to point to new target group.
