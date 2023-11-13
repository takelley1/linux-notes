## [Kubernetes](https://kubernetes.io/docs/home/)

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

- **See also:**
  - [Kubectl cheat sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
<br><br>
- `cluster-info` = Print IPs of services and where they're running.
<br><br>
- `get` = Get info for a resource TYPE
  - `kubectl get all -A` = Get all resources in all namespaces.
  - `kubectl get all -n splunk` = Get all resources in the *splunk* namespace.
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
  - `kubectl exec -i gitlab-runner-678dd89fd9 -n gitlab -- nslookup google.com` = Run an nslookup command in a gitlab runner pod.
  - `kubectl exec -it gitlab-runner-678dd89fd9 -n gitlab -- /bin/bash` = Pop a shell in a gitlab runner pod.
<br><br>
- `edit` = Open YAML editor for a resource & update it automatically.
- `create` = *imperatively* create resources.
  - `kubectl create -f file.yaml` = Create resources in `file.yaml`
- `apply` = *declaratively* create resources.
  - `kubectl apply -f file.yaml` =  Create resources in `file.yaml`
- `scale` = Manually scale a deployment.
  - `kubectl scale deployment myapp-deployment --replicas=5`
<br><br>
- `delete` = Destroy a resource
  - `kubectl delete service/sonarqube-sonarqube -n sonarqube`
<br><br>
- `kubectl rollout undo deployment myapp-deployment` = Revert `myapp-deployment` to its previous version.

### Troubleshooting

- `kubectl cp <NAMESPACE>/<POD_NAME>:<PATH_IN_POD> <LOCAL_PATH>`
- `kubectl cp myscript.sh keycloak-0:/tmp/myscript.sh -n keycloak` = Copy *myscript.sh* into the *keycloak-0* pod.
- `kubectl run curl-test --image=radial/busyboxplus:curl -i --tty --rm` = Run pod with *curl* and *nslookup* for testing.

### Example deployment

- For ChatGPT: `Write an example nginx deployment for kubernetes`
<br><br>
`nginx-deployment.yaml`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
```
`nginx-service.yaml`
```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: NodePort
```

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
