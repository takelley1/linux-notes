
## [KUBERNETES](https://kubernetes.io/docs/home/)

- **See also:**
  - Tools
    - [Lens - K8s IDE](https://k8slens.dev/)
    - [Kubectl - Command-line interaction with k8s API](https://kubernetes.io/docs/reference/kubectl/overview/)
    - [Helm - K8s package manager](https://helm.sh/docs/)
  - Installation methods
    - [Kubeadm - Official tool for cluster creation](https://kubernetes.io/docs/reference/setup-tools/kubeadm/)
    - [Kubespray - Create K8s cluster with Ansible](https://github.com/kubernetes-sigs/kubespray)
    - [Kops - Automatic K8s cluster provisioning](https://kops.sigs.k8s.io/)
  - Distributions
    - [Minikube - Local K8s for learning](https://minikube.sigs.k8s.io/docs/start/)
    - [K0s - Lightweight K8s](https://github.com/k0sproject/k0s)


### [Kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)

- `cluster-info` = Print IPs of services and where they're running.
<br><br>
- `get` = Get info for a resource TYPE
  - `kubectl get pods -A` = List running pods in all (`-A`) namespaces.
  - `kubectl get nodes -o wide` = List nodes with extra (`-o wide`) information.
- `describe` = Get info for a SPECIFIC resource
  - `kubectl describe nodes node1` = Describe `node1`.
<br><br>
- `edit` = Open YAML editor for a resource & update it automatically.
- `create` = *imperatively* create resources.
  - `kubectl create -f file.yaml` = Create resources in `file.yaml`
- `apply` = *declaratively* create resources.
  - `kubectl apply -f file.yaml` =  Create resources in `file.yaml`