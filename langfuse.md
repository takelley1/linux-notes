## LangFuse

### AWS backup and restore checklist

#### Backup
- Enable S3 versioning for event storage.
- Enable RDS snapshots for state storage.
- Enable EC2 volume snapshots for instance and Docker volume storage.

#### Restore
- Restore RDS snapshot to a new instance.
- Restore EC2 snapshot to a new instance.
  - EC2 → Snapshots → select your snapshot → Actions → Create image from snapshot → fill root device name and volume settings → create.
  - EC2 → AMIs → select the new AMI → Launch.
    - When launching from the new AMI, make sure you paste this into the user data field to reset SSM registration.
      ```bash
      #!/bin/bash
      systemctl stop amazon-ssm-agent
      rm -rf /var/lib/amazon/ssm/* /var/log/amazon/ssm/* /etc/amazon/ssm/amazon-ssm-agent.json
      if [ -f /etc/machine-id ]; then
        truncate -s 0 /etc/machine-id
        systemd-machine-id-setup
      fi
      systemctl start amazon-ssm-agent
      ```
    - Make sure the EC2 instance has the default IAM profile so we can connect to it with SSM.
  - Point LangFuse to new RDS instance.
- Update target group in ALB with new EC2 instance IP.
- Update DNS to point to new target group.
