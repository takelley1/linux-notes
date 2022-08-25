## McAfee

- Logs: `/var/McAfee/agent/logs`

Uninstall McAfee Agent:
```bash
rpm -e MFEdx
rpm -e MFEcma
rpm -e MFErt

# If the above fails:
rpm -e MFEdx --nodeps --noscripts
rpm -e MFEcma --nodeps --noscripts
rpm -e MFErt --nodeps --noscripts
```
