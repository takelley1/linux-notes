
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
  - `kubectl get pods -w` = Continuously watch (`-w`) pods as they update in the default namespace.
  - `kubectl get nodes -o wide` = List nodes with extra (`-o wide`) information.
- `describe` = Get info for a SPECIFIC resource
  - `kubectl describe nodes node1` = Describe `node1`.
  - `kubectl describe -n gitlab pods gitlab-runner-678dd89fd9 | grep Node:` = Show the node running a specific pod in the gitlab namespace.
<br><br>
- `logs` = Get pod logs.
  - `kubectl logs -f -n kube-system coredns-694675dfcd-dqg69` = Tail CoreDNS pod logs in the kube-system namespace.
- `exec` = Run command in a pod.
  - `kubectl exec -i gitlab-runner-678dd89fd9 -- nslookup google.com` = Run an nslookup command in a gitlab runner pod.
  - `kubectl exec -it gitlab-runner-678dd89fd9 -- /bin/bash` = Pop a shell in a gitlab runner pod.
<br><br>
- `edit` = Open YAML editor for a resource & update it automatically.
- `create` = *imperatively* create resources.
  - `kubectl create -f file.yaml` = Create resources in `file.yaml`
- `apply` = *declaratively* create resources.
  - `kubectl apply -f file.yaml` =  Create resources in `file.yaml`
- `scale` = Manually scale a deployment.
  - `kubectl scale deployment myapp-deployment --replicas=5`
<br><br>
- `kubectl rollout undo deployment myapp-deployment` = Revert `myapp-deployment` to its previous version.


### [CoreDNS](https://coredns.io/plugins/)

- **See also**
  - [k8s DNS](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/)
  - [DNS troubleshooting on EKS](https://aws.amazon.com/premiumsupport/knowledge-center/eks-dns-failure/)
  - [Debugging k8s DNS resolution](https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/)
<br><br>
- Update CoreDNS to use an upstream DNS server:
```
kubectl edit configmap coredns -n kube-system
```
```yaml
  Corefile: |
    .:53 {
        log # < --- Log requests to stdout
        errors
        health
        kubernetes cluster.local in-addr.arpa ip6.arpa {
          pods insecure
          fallthrough in-addr.arpa ip6.arpa
        }
        forward . 10.128.0.2 # < --- Use 10.128.0.2 as upstream DNS
        prometheus :9153
        cache 30
        loop
        reload
        loadbalance
    }
```
