# K0s

## Troubleshooting

- `journalctl -fu k0scontroller` = View logs on a k0s controller node
- `k0s etcd member-list` = Get info on etcd status
- `k0s kubectl get nodes` = Run standard kubectl commands
- `k0s stop && k0s reset` = Reset k0s installation

## Kubectl

- Copy `/var/lib/k0s/pki/admin.conf` from the k0s controller node to `~/.kube/config` on your workstation. Change the IP to the controller node's IP.
