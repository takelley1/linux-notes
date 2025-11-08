# [Kubernetes](https://kubernetes.io/docs/home/)

- **See also:**
  - Learning
    - [k8s.guide](https://www.k8s.guide/)
  - Tools
    - [Lens - K8s IDE](https://k8slens.dev/)
    - [Kubectl - Command-line interaction with k8s API](https://kubernetes.io/docs/reference/kubectl/overview/)
    - [Helm - K8s package manager](https://helm.sh/docs/)
    - k9s - TUI replacement for kubectl
    - kubescape - Scan cluster security posture
    - popeye - Lint cluster for potential issues
    - kubent - List deprecated APIs before upgrading the cluster
  - Installation methods
    - [Kubeadm - Official tool for cluster creation](https://kubernetes.io/docs/reference/setup-tools/kubeadm/)
    - [Kubespray - Create K8s cluster with Ansible](https://github.com/kubernetes-sigs/kubespray)
    - [Kops - Automatic K8s cluster provisioning](https://kops.sigs.k8s.io/)
  - Distributions
    - [Minikube - Local K8s for learning](https://minikube.sigs.k8s.io/docs/start/)
    - [K0s - Lightweight K8s](https://github.com/k0sproject/k0s)
  - Troubleshooting
    - DNS
      - [k8s DNS](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/)
      - [DNS troubleshooting on EKS](https://aws.amazon.com/premiumsupport/knowledge-center/eks-dns-failure/)
      - [Debugging k8s DNS resolution](https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/)
  - Kubernetes stack
    - GitOps: ArgoCD w/ Kustomize or Helm manifests
    - Telemetry: OpenTelemtry
    - Metrics: Prometheus + Grafana using kube-prometheus-stack, Loki, Tempo
    - Storage: Ceph RGW for S3-compatible storage

## Troubleshooting

- `kubectl cp <NAMESPACE>/<POD_NAME>:<PATH_IN_POD> <LOCAL_PATH>`
- `kubectl cp myscript.sh keycloak-0:/tmp/myscript.sh -n keycloak` = Copy *myscript.sh* into the *keycloak-0* pod.
- `kubectl run curl-test --image=radial/busyboxplus:curl -i --tty --rm` = Run pod with *curl* and *nslookup* for testing.
- `crictl rmi --prune` = Prune unused images on a given node.
- Run a debug shell on the node itself:
```bash
kubectl run debug-shell --rm -it --restart=Never --image=ubuntu --overrides='{"apiVersion":"v1","spec":{"hostPID":true,"nodeName":"NODE_NAME_HERE","containers":[{"name":"shel
l","image":"ubuntu","command":["nsenter","--target=1","--mount","--uts","--ipc","--net","--pid"],"securityContext":{"privileged":true},"stdin":true,"tty":true}]}}'`
```

## [Kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)

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

## Core Concepts

### [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- Creates a ReplicaSet declaratively.
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
### [ReplicaSet](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/)
- Maintains the desired number of identical pods. Usually created by a deployment.

### [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)
- Alternative to ReplicaSet for deploying stateful pods (pods that use storage).

### [DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)
- Ensures a single pod is running on all nodes of a given type. Useful for collecting node metrics.

### [Service](https://kubernetes.io/docs/concepts/services-networking/service/)
  - Abstraction layer to make pods accessible.
  - Matches a set of Pods using a label.
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

### Services

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

#### [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)
  - Acts as an HTTP/HTTPS (layer 7) load balancer in front of your services.
  - Instead of having `Client -> LoadBalancer -> Service -> Pod` for every service (which creates too many LoadBalancers), Ingresses act as a middleman: `Client -> LoadBalancer -> IngressController Service -> IngressController -> Service -> Pod`. 
  1. Create an Ingress Controller deployment (like Nginx)
  3. Expose the IngressController deployment with a LoadBalancer or NodePort service
  4. Create the Ingress resource
  5. Point DNS to the LoadBalancer's public IP
  ```yaml
  apiVersion: networking.k8s.io/v1
  kind: Ingress
  metadata:
    name: simple-fanout-example
  spec:
    rules:
    - host: foo.bar.com # This is the external domain that clients will connect to. 
      http:             #   The DNS for foo.bar.com must point to the external LoadBalancer's public IP.
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

#### Gateway API
  - Replaces Ingress.
  - Traffic flow: Client -> External HAProxy (running outside the cluster) -> Sends traffic to a node running a NodePort Gateway Controller Service -> Decides which Service(s) to send traffic to based on its HTTPRoute rules.
  - Istio can also be used as a gateway controller.

Example setup with HAProxy VM -> Nginx Gateway
```yaml
---
# NGINX gateway dataplane
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-gateway
  namespace: gateway-system
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx-gateway
  template:
    metadata:
      labels:
        app: nginx-gateway
    spec:
      containers:
        - name: nginx
          image: ghcr.io/nginxinc/nginx-unprivileged:1.27
          ports:
            - containerPort: 8443
---
# NodePort Service that HAProxy targets
apiVersion: v1
kind: Service
metadata:
  name: gateway-nodeport
  namespace: gateway-system
spec:
  type: NodePort
  selector:
    app: nginx-gateway
  ports:
    - name: https
      port: 443
      targetPort: 8443
      nodePort: 30443
---
# Gateway API: NGINX GatewayClass
apiVersion: gateway.networking.k8s.io/v1
kind: GatewayClass
metadata:
  name: nginx
spec:
  controllerName: gateway.nginx.org/nginx-gateway-controller
---
# Gateway instance
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: public-gw
  namespace: gateway-system
spec:
  gatewayClassName: nginx
  listeners:
    - name: https
      protocol: HTTPS
      port: 443
      tls:
        mode: Terminate
        certificateRefs:
          - kind: Secret
            name: example-tls
```
HAProxy config (uses TCP mode so HTTPS is terminated by Nginx):
```
# /etc/haproxy/haproxy.cfg
backend be_https
  balance roundrobin
  option tcp-check
  server node1 10.0.0.11:30443 check
  server node2 10.0.0.12:30443 check
  server node3 10.0.0.13:30443 check
```
Example target service with HTTP routes
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: echo
  namespace: app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: echo
  template:
    metadata:
      labels:
        app: echo
    spec:
      containers:
        - name: echo
          image: ghcr.io/inanimate/echo-server:latest
          ports:
            - containerPort: 3000
---
apiVersion: v1
kind: Service                 # The target service runs as a ClusterIP service
metadata:
  name: echo
  namespace: app
spec:
  selector:
    app: echo
  ports:
    - port: 80
      targetPort: 3000
---
# --- HTTPRoute that binds to the Gateway and routes to the app ---
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: echo-route
  namespace: app
spec:
  parentRefs:
    - name: public-gw           # Gateway name from earlier
      namespace: gateway-system # must match gateway namespace
  hostnames:
    - echo.example.com          # Incoming host header to match
  rules:
    - matches:
        - path:
            type: PathPrefix
            value: /            # Match echo.example.com/*
      backendRefs:
        - name: echo
          port: 80              # Sends echo.example.com/* to the echo service on port 80 (the service port)
```

### Endpoint
  - Lists the IPs/ports of all pods belonging to a service.

### Operator
  - Manages the desired state of custom resources.

### [CoreDNS](https://coredns.io/plugins/)

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

### Secrets

- Create an encrypted `secrets.yml` file (similar to Ansible Vault).
  - The secret is encrypted when stored in the Git repo and automatically decrypted by the cluster when applied.
```bash
kubectl create secret generic mcp-server-agility \
  --namespace=mcp-server-agility \
  --from-literal=AGILITY_ACCESS_TOKEN=access_token_here \
  --from-literal=AGILITY_API_URL=api_url_here \
  -o json | kubeseal \
  --controller-name=sealed-secrets-controller \
  --controller-namespace=kube-system \
  --format yaml > sealedsecret.yml
```
`sealedsecret.yml`
```yaml
---
apiVersion: bitnami.com/v1alpha1
kind: SealedSecret
metadata:
  creationTimestamp: null
  name: mcp-server-agility
  namespace: mcp-server-agility
spec:
  encryptedData:
    AGILITY_ACCESS_TOKEN: AgB1y4E/cYgSdbDvl5aMfIX/ocflPTsT1JQZrXTAqkBSK8cSDeq7i3KH899uzNZQsHDWl...
    AGILITY_API_URL: AgAwWVvpCcaU1tPHdgAoasdDeyVENglHfdzzjKjoRzsFP+megc5pDL9NhMY4kotbwgeErzRMIB...
  template:
    metadata:
      creationTimestamp: null
      name: mcp-server-agility
      namespace: mcp-server-agility
    type: Opaque
```

## Security

Hardened deployment spec following best-practices:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
  namespace: app
  labels:
    app: web
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
      annotations:
        # Enforces the default AppArmor profile for additional syscall restrictions.
        container.apparmor.security.beta.kubernetes.io/app: runtime/default
    spec:
      # Disable automatic mounting of the ServiceAccount token since this Pod
      # doesn’t need to talk to the Kubernetes API.
      automountServiceAccountToken: false

      # Pod-level security context — applies to all containers.
      securityContext:
        # Enables the default seccomp profile (recommended).
        # Blocks unsafe syscalls and aligns with the “restricted” PSS profile.
        seccompProfile:
          type: RuntimeDefault

        # Ensures the Pod never runs as UID 0 (root).
        runAsNonRoot: true

        # Forces all container processes to run as user 1000 and group 1000.
        runAsUser: 1000
        runAsGroup: 1000

        # Files written to mounted volumes are owned by this group.
        fsGroup: 2000

      # Temporary writable volumes for app data — avoid writing to root FS.
      volumes:
      - name: tmp
        emptyDir:
          medium: Memory
          sizeLimit: 64Mi
      - name: cache
        emptyDir: {}

      containers:
      - name: app
        # Always pin images by digest to prevent supply-chain drift.
        image: ghcr.io/example/web@sha256:<SHA256_STRING>
        imagePullPolicy: IfNotPresent

        # Container-level security context — overrides or adds to Pod-level.
        securityContext:
          # Prevents privilege escalation (e.g., via setuid binaries).
          allowPrivilegeEscalation: false

          # Makes the root filesystem read-only.
          # Forces the app to use mounted volumes for writes.
          readOnlyRootFilesystem: true

          # Explicitly denies privileged mode.
          privileged: false

          # Drops all Linux capabilities (fine-grained kernel privileges).
          # Start with a clean slate instead of keeping defaults like NET_RAW.
          capabilities:
            drop: ["ALL"]

        # Mount limited writable paths only where needed.
        volumeMounts:
        - name: tmp
          mountPath: /tmp
        - name: cache
          mountPath: /var/cache/app

        # Expose HTTP port for the app.
        ports:
        - containerPort: 8080

        # Probes for self-healing and load balancing.
        readinessProbe:
          httpGet:
            path: /health/ready
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 10
          timeoutSeconds: 2
          failureThreshold: 3
        livenessProbe:
          httpGet:
            path: /health/live
            port: 8080
          initialDelaySeconds: 15
          periodSeconds: 20
          timeoutSeconds: 2
          failureThreshold: 3

        # Resource requests/limits prevent DoS and noisy-neighbor issues.
        resources:
          requests:
            cpu: "100m"
            memory: "128Mi"
          limits:
            cpu: "500m"
            memory: "256Mi"

        # Avoid putting secrets in environment variables when possible.
        env:
        - name: APP_ENV
          value: "prod"

      # Graceful shutdown period before killing Pods.
      terminationGracePeriodSeconds: 30
```

### Pod Security

#### Pod Security Standards (PSS)
- Predefined security profiles applied to a namespace. Prevents pods from running that fail the applied standard.
  - Privileged — No restrictions. Full host access, all capabilities allowed. Intended for system-level components (CNI, CSI, monitoring agents).
  - Baseline — Blocks known privilege-escalation paths but still allows typical app workloads. For example, it disallows privileged: true or hostPID, but doesn’t require runAsNonRoot.
  - Restricted — Enforces strict hardening and best practices. Requires non-root users, drops all Linux capabilities, prohibits hostPath and host namespaces.

#### Pod Security Admission (PSA)
- Enforces the Pod Security Standards on pods before they get created.
- Operates in enforce, audit, and warn modes.
```bash
kubectl label namespace dev \
  pod-security.kubernetes.io/enforce=baseline \
  pod-security.kubernetes.io/warn=restricted \
  pod-security.kubernetes.io/audit=restricted
```
- This means: block any pod that violates the baseline rules, log or warn about violations against the stricter restricted rules.

#### Pod Security Context (PSC)
- Configures how a Pod or its containers run (e.g., non-root, read-only FS, dropped capabilities).
- Can be defined at two levels:
  - Pod-level — applies defaults to all containers in the Pod.
  - Container-level — overrides Pod-level settings for that container.
```yaml
spec:
  securityContext:
    runAsUser: 1000
    runAsGroup: 3000
    fsGroup: 2000
  containers:
  - name: app
    image: myapp:latest
    securityContext:
      readOnlyRootFilesystem: true
      allowPrivilegeEscalation: false
```

### Network Security

#### Network Policies
- Namespace-scoped; only applies to Pods within the same namespace.  
- Can reference other namespaces using `namespaceSelector` but can’t control them directly.  
- Multiple policies can apply to one Pod; the union of all rules defines allowed traffic.  
- Once any policy selects a Pod, all other traffic is denied by default.
- If no policies select a Pod, that Pod is open.   
- Make sure to allow DNS egress (UDP/TCP 53) if outbound traffic is restricted.  
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
# Applies this policy only to Pods in the "web" namespace
# that have the label app=nginx.
metadata:
  name: web-nginx
  namespace: web
spec:
  podSelector:
    matchLabels:
      app: nginx
  policyTypes: ["Ingress", "Egress"]

  # Ingress rules: what traffic is allowed *to* the nginx Pods.
  # Allow ingress only from ingress controller Pods
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: ingress-nginx   # controller namespace
      podSelector:
        matchLabels:
          app.kubernetes.io/name: ingress-nginx        # controller Pods
    ports:
    - protocol: TCP
      port: 80

  # Egress rules: what traffic is allowed *from* the nginx Pods.
  # Egress: only DB and DNS
  egress:
  - to:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: data
      podSelector:
        matchLabels:
          app: db
    ports:
    - protocol: TCP
      port: 5432
  - to:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: kube-system
      podSelector:
        matchLabels:
          k8s-app: kube-dns
    ports:
    - protocol: UDP
      port: 53
  - to:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: kube-system
      podSelector:
        matchLabels:
          k8s-app: kube-dns
    ports:
    - protocol: TCP
      port: 53
```

Deny all traffic in the namespace. Start with this and then add other NetworkPolicies to permit only allowed traffic:
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
  namespace: backend
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
```

### API Security

#### [RBAC](https://www.k8s.guide/rbac/)
- Controls API access per-namespace (Roles) or per-cluser (ClusterRoles)

| Kind |	Purpose |
|------|----------|
| Role |	Grants permissions within a single namespace |
| ClusterRole  |	Grants permissions cluster-wide |
| RoleBinding |	Assigns a Role to a user/group in a namespace |
| ClusterRoleBinding | 	Assigns a ClusterRole to a user/group across all namespaces |

Grant read-only access in a namespace
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
  namespace: dev
rules:
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["get", "list"]
```

Bind the role to alice
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-pods
  namespace: dev
subjects:
  - kind: User
    name: alice
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

#### [Service Accounts](https://kubernetes.io/docs/concepts/security/service-accounts/)
- Accounts managed by the k8s API, unlike human users.
- Kubernetes creates a `default` ServiceAccount in each namespace with minimal permissions.
- All pods without a ServiceAccount specified use `default`.
- Custom ServiceAccounts should be created per workload that needs API access, each with its own least-privilege RBAC bindings.
