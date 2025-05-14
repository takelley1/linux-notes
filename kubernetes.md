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

### Troubleshooting

- `kubectl cp <NAMESPACE>/<POD_NAME>:<PATH_IN_POD> <LOCAL_PATH>`
- `kubectl cp myscript.sh keycloak-0:/tmp/myscript.sh -n keycloak` = Copy *myscript.sh* into the *keycloak-0* pod.
- `kubectl run curl-test --image=radial/busyboxplus:curl -i --tty --rm` = Run pod with *curl* and *nslookup* for testing.
- Run a debug shell on the node itself:
```bash
kubectl run debug-shell --rm -it --restart=Never --image=ubuntu --overrides='{"apiVersion":"v1","spec":{"hostPID":true,"nodeName":"NODE_NAME_HERE","containers":[{"name":"shel
l","image":"ubuntu","command":["nsenter","--target=1","--mount","--uts","--ipc","--net","--pid"],"securityContext":{"privileged":true},"stdin":true,"tty":true}]}}'`
```


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

### Example deployment

- For ChatGPT: `Write an example nginx deployment for kubernetes`
- Creates a ReplicaSet of 3 identical Nginx pods:
- `nginx-deployment.yml`
  ```yaml
  ---
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: nginx-deployment
  spec:
    replicas: 3 # Create a ReplicaSet with 3 pods matching the template.
    selector:
      matchLabels:
        app: nginx # The ReplicaSet manages all pods with this label.
    template:
      metadata:
        labels:
          app: nginx # Give all pods this label.
      spec:
        containers:
          - name: nginx # All pods have a single nginx container.
            image: nginx:latest
            ports:
              - containerPort: 80 # This doesn't change the port nginx listens on, it's just for informational purposes.
  
  ```
- `nginx-service.yml`
  ```yaml
  ---
  apiVersion: v1
  kind: Service
  metadata:
    name: nginx-service
  spec:
    selector:
      app: nginx # All pods with this label will be part of the service.
    ports:
      - protocol: TCP
        port: 80
        targetPort: 80 # Traffic hitting any node at its NodePort is forwarded to the the service port, then the targetPort on each pod
    type: NodePort
  ```
- `kubectl apply -f nginx-deployment.yml`
- `kubectl apply -f nginx-service.yml`
- `kubectl delete -f nginx-deployment.yml`
- `kubectl delete -f nginx-service.yml`

### [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- Creates a ReplicaSet declaratively.

#### [ReplicaSet](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/)
- Maintains the desired number of identical pods. Usually created by a deployment.

#### [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)
- Alternative to ReplicaSet for deploying stateful pods (pods that use storage).

#### [DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)
- Ensures a single pod is running on all nodes of a given type. Useful for collecting node metrics.

### [Service](https://kubernetes.io/docs/concepts/services-networking/service/)
  - Abstraction layer to make pods accessible.
  - Matches a set of pods using a label.

#### [ClusterIP Service](https://kubernetes.io/docs/concepts/services-networking/service/#type-clusterip)
  - Makes a service available to pods inside the cluster.
  - Used by internal-only services that communicate with each other inside the cluster.
  - Provides a single IP to access all pods within that service from inside the cluster.
  ```yaml
  ports:
    - protocol: TCP
      port: 80          # The port of the SERVICE - All traffic on this port routes to the `targetPort` of each pod
      targetPort: 3000  # The port of the POD - The service forwards traffic from `port` to `targetPort`
  ```

#### [NodePort Service](https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport)
  - Makes a service available outside the cluster on every node at a specific port.
  - Nodes that don't have the service's pod(s) scheduled on them will forward any traffic on that port to the node(s) with the pod(s) scheduled on them.
  - Automatically provisions a ClusterIP service.
  - Ports (in service definition file) [StackOverflow explanation](https://stackoverflow.com/questions/49981601/difference-between-targetport-and-port-in-kubernetes-service-definition)
    ```yaml
    ports:
      - protocol: TCP
        port: 80          # The port of the SERVICE - For NodePort services, this can be anything
        targetPort: 3000  # The port of the POD - The service forwards traffic from `port` to `targetPort`
        nodePort: 30432   # The port of the NODE - The node listens on this port and routes traffic to the service port
    ```
    ```
    incoming traffic -> nodePort (NODE) -> port (SERVICE) -> targetPort (POD)
    ```
    - Example (in Lens GUI): `80:30432/TCP` - This service is accessible on each node's IP over port 30432. Port 30432 on every node will forward to port 80 on the service. Port 80 of the service will then forward traffic to the `targetPort` of the service pod(s).

#### [LoadBalancer Service](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer)
  - Provisions an external cloud-managed load balancer to forward traffic to backend pods.
  - Used with cloud providers.
  - Automatically provisions a NodePort and a ClusterIP service.
  ```yaml
  kind: Service
  metadata:
    name: my-service
  spec:
    selector:
      app: MyApp
    ports:
      - protocol: TCP
        port: 80 # The service's port on the load balancer.
        targetPort: 9376 # Forwards traffic to this port on pods matching the selector.
    type: LoadBalancer

#1. The request hits the external load balancer at X.X.X.X:80
#2. The load balancer forwards it to a NodePort (automatically created) on one of your cluster nodes
#3. Kubernetes routes the traffic to the Service
#4. The Service sends the traffic to port 9376 on one of the pods labeled with app: MyApp
#5: Your application running in the pod receives the request and processes it
  ```

### Endpoint
  - Lists the IPs/ports of all pods belonging to a service.

### [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)
  - Acts as an HTTP/HTTPS (layer 7) load balancer in front of your services.
  - Used with ClusterIP services (NOT NodePort or LoadBalancer).
  - If you're already using a LoadBalancer service, an Ingress is redundant.
  - Ideal when you have many ClusterIP services and don't want to use a LoadBalancer service for each of them.
  - Requires an IngressController like Nginx
  ```yaml
  apiVersion: networking.k8s.io/v1
  kind: Ingress
  metadata:
    name: simple-fanout-example
  spec:
    rules:
    - host: foo.bar.com # This is the external domain that clients will connect to.
      http:
        paths:
        - path: /foo # This would handle foo.bar.com/foo and send it to service1
          pathType: Prefix
          backend:
            service:
              name: service1
              port:
                number: 4200
        - path: /bar  # This would handle foo.bar.com/bar and send it to service2
          pathType: Prefix
          backend:
            service:
              name: service2
              port:
                number: 8080
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
        log # Log requests to stdout
        errors
        health
        kubernetes cluster.local in-addr.arpa ip6.arpa {
          pods insecure
          fallthrough in-addr.arpa ip6.arpa
        }
        forward . 10.128.0.2 # Use 10.128.0.2 as upstream DNS
        prometheus :9153
        cache 30
        loop
        reload
        loadbalance
    }
```
