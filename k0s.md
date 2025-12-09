# K0s

## Troubleshooting

`journalctl -fu k0scontroller` = View logs on a k0s controller node

## Kubectl

- Copy `/var/lib/k0s/pki/admin.conf` from the k0s controller node to `~/.kube/config` on your workstation. Change the IP to the controller node's IP.
