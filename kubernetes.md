# [Kubernetes](https://kubernetes.io/docs/home/)

- **See also:**
  - Learning
    - [k8s.guide](https://www.k8s.guide/)
  - Tools
    - [FreeLens](https://freelensapp.github.io/) - K8s IDE
    - [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) - Command-line interaction with k8s API
    - krew - Plugin manager for kubectl
    - [Helm](https://helm.sh/docs/) - K8s package manager
    - k9s - TUI replacement for kubectl
    - kubescape - Scan cluster security posture
    - popeye - Lint cluster for potential issues
    - kubent - List deprecated APIs before upgrading the cluster
    - [sonobuoy](https://github.com/vmware-tanzu/sonobuoy) - Assist cluster debugging by checking for errors and ensuring compliance
  - Installation methods
    - [Kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/) - Official tool for cluster creation
    - [Kubespray](https://github.com/kubernetes-sigs/kubespray) - Create K8s cluster with Ansible
    - [Kops](https://kops.sigs.k8s.io/) - Automatic K8s cluster provisioning
  - Distributions
    - [Minikube](https://minikube.sigs.k8s.io/docs/start/) - Local K8s for learning
    - [K0s](https://github.com/k0sproject/k0s) - Lightweight K8s
  - Troubleshooting
    - DNS
      - [k8s DNS](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/)
      - [DNS troubleshooting on EKS](https://aws.amazon.com/premiumsupport/knowledge-center/eks-dns-failure/)
      - [Debugging k8s DNS resolution](https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/)
  - Example Kubernetes stack
    - GitOps: ArgoCD w/ Kustomize or Helm manifests
    - Telemetry: OpenTelemtry to standardize metrics
    - Metrics: Prometheus + Grafana using kube-prometheus-stack
    - Logs: Loki (simpler) or ELK/EFK stack
    - Traces: Tempo (simpler) or Jaeger
    - Storage: Ceph RGW for S3-compatible storage
    - Service mesh: Linkerd (simpler) or Istio
    - Certificates: Cert-manager
    - Disaster recovery: Velero

## Production Cookbooks

<details>
  <summary>Deployment</summary>

```yaml
apiVersion: apps/v1                                # API group/version that defines the Deployment schema.
kind: Deployment                                   # Resource type: a Deployment manages ReplicaSets and Pods.
metadata:
  name: web                                        # Name of the Deployment object.
  namespace: app                                   # Namespace where this Deployment will be created.
  labels:                                          # Arbitrary identifying metadata for grouping and selection.
    app: web                                       # App label used by selectors and tools.
    app.kubernetes.io/name: web                    # Standardized label for the component name.
    app.kubernetes.io/part-of: my-system           # Logical grouping for the larger system.
spec:
  replicas: 2                                      # Number of desired running Pods.
  revisionHistoryLimit: 5                          # How many old ReplicaSets to retain for rollbacks.
  strategy:                                        # Update strategy when replacing Pod versions.
    type: RollingUpdate                            # Rolling update replaces Pods gradually.
    rollingUpdate:
      maxUnavailable: 0                            # Ensures no reduction of available Pods during updates.
      maxSurge: 1                                  # Allows one extra Pod above desired count during rollout.
  selector:
    matchLabels:                                   # Defines which Pods belong to this Deployment.
      app: web                                     # Must match template.metadata.labels.app.
  template:                                        # Pod template used to create Pods.
    metadata:
      labels:                                      # Labels applied to each new Pod.
        app: web
        app.kubernetes.io/name: web
        app.kubernetes.io/part-of: my-system
      # Optional: Only include AppArmor on Ubuntu nodes that support it.
      # annotations:
        # Enforce the default AppArmor profile for additional syscall restrictions.    # Explains AppArmor intent.
        # container.apparmor.security.beta.kubernetes.io/app: runtime/default          # AppArmor profile for container "app".
    spec:
      # Create a ServiceAccount with the image registry credentials.
      serviceAccountName: web-api-sa
      # Optional: If no ServiceAccount is needed:
      # automountServiceAccountToken: false                  # Prevents auto-mounting the default service account token.

      securityContext:                                       # Pod-level security defaults.
        seccompProfile:
          type: RuntimeDefault                               # Uses the built-in restricted syscall profile.
        runAsNonRoot: true                                   # Ensures no container runs as root inside the Pod.
        runAsUser: 1000                                      # UID the containers will run as.
        runAsGroup: 1000                                     # Primary GID the containers will run as.
        fsGroup: 1000                                        # Group ownership applied to mounted volumes.

      # Optional: constrain where this runs                  # Scheduling constraints.
      # nodeSelector:                                        # Restricts scheduling to nodes with specific labels.
      #   node-role.kubernetes.io/worker: "true"             # Example: only worker nodes.
      # tolerations:                                         # Allows scheduling onto tainted nodes.
      #   - key: "dedicated"
      #     operator: "Equal"
      #     value: "web"
      #     effect: "NoSchedule"

      # Optional: spread pods across nodes/zones             # Improves HA by distribution.
      # topologySpreadConstraints:
      #   - maxSkew: 1                                       # Maximum imbalance allowed between failure domains.
      #     topologyKey: kubernetes.io/hostname              # Spread across nodes.
      #     whenUnsatisfiable: ScheduleAnyway                # Allows deviation if required.
      #     labelSelector:
      #       matchLabels:
      #         app: web                                     # Applies constraint only to Pods with this label.

      volumes:                                               # Pod-level volume definitions.
        - name: tmp                                          # Volume for temporary writable data.
          emptyDir:
            medium: Memory                                   # Uses RAM instead of disk.
            sizeLimit: 64Mi                                  # Max size for tmp volume.
        - name: cache                                        # Volume for general app cache data.
          emptyDir: {}                                       # Default emptyDir backed by node storage.

      containers:
        - name: app                                          # Name of the container inside the Pod.
          image: ghcr.io/example/web@sha256:<SHA256_STRING>  # Image pinned by digest for immutability.
          imagePullPolicy: IfNotPresent                      # Pull only if missing locally.

          securityContext:                                   # Container-specific security overrides.
            allowPrivilegeEscalation: false                  # Blocks privilege escalation via syscalls.
            readOnlyRootFilesystem: true                     # Ensures root filesystem is immutable.
            privileged: false                                # Prevents privileged container mode.
            capabilities:
              drop: ["ALL"]                                  # Removes all Linux capabilities.

          volumeMounts:                                      # Mounts volumes into container filesystem.
            - name: tmp
              mountPath: /tmp                                # Writable tmp directory.
            - name: cache
              mountPath: /var/cache/app                      # Writable cache directory.

            # Optional: ConfigMap and Secret volumes for configuration and credentials.
            # Note: RBAC policies are not needed to allow the Pod to access ConfigMaps and Secrets mounted into it.
            - name: config                          # Volume to expose ConfigMap data as files.
              configMap:
                name: web-config                    # Name of the ConfigMap to mount.
            - name: secrets                         # Volume to expose Secret data as files.
              secret:
                secretName: web-secret              # Name of the Secret to mount.

          ports:
            - containerPort: 8080                   # Port the container listens on.
              name: http                            # Named port for probes and services.

          readinessProbe:                           # Determines when Pod is ready for traffic.
            httpGet:
              path: /health/ready                   # Readiness endpoint.
              port: http                            # Uses named port above.
            initialDelaySeconds: 5                  # Wait before first check.
            periodSeconds: 10                       # Probe frequency.
            timeoutSeconds: 2                       # Probe timeout.
            failureThreshold: 3                     # Failures required to mark unready.

          livenessProbe:                            # Detects hung or dead containers.
            httpGet:
              path: /health/live                    # Liveness endpoint.
              port: http
            initialDelaySeconds: 15                 # Delay before first liveness probe.
            periodSeconds: 20                       # Probe frequency.
            timeoutSeconds: 2                       # Probe timeout.
            failureThreshold: 3                     # Failures required to trigger restart.

          # Optional if startup is slow:            # Startup probe stabilizes slow boot.
          # startupProbe:
          #   httpGet:
          #     path: /health/ready                 # Startup health endpoint.
          #     port: http
          #   failureThreshold: 30                  # How long startup may take.
          #   periodSeconds: 2                      # Probe frequency during startup.

          resources:                                # Compute resource requests and limits.
            requests:
              cpu: "100m"                           # Minimum guaranteed CPU.
              memory: "128Mi"                       # Minimum guaranteed memory.
            limits:
              cpu: "500m"                           # Max CPU allowed.
              memory: "256Mi"                       # Max memory allowed.

          env:
            - name: APP_ENV                         # Environment variable for app config.
              value: "prod"                         # Sets production environment mode.

      terminationGracePeriodSeconds: 30             # Time allowed for graceful shutdown.

      # Optional: add priority if you use it        # Priority affects scheduling.
      # priorityClassName: "web-critical"
```
</details>

<details>
  <summary>ServiceAccount</summary>

```yaml
# ServiceAccount setup to authenticate to a Docker registry

--- # Create the registry credential
apiVersion: v1
kind: Secret
metadata:
  name: ghcr-web-pull
  namespace: app
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: <BASE64>

--- # Attach it to the ServiceAccount
apiVersion: v1
kind: ServiceAccount
metadata:
  name: web-api-sa
  namespace: app
imagePullSecrets:
  - name: ghcr-web-pull
```
</details>

<details>
  <summary>NetworkPolicies</summary>

```yaml
# NetworkPolicy setup to enforce a default deny-all, then only allow traffic within that namespace
# Make sure to apply this same policy to each namespace (except kube-system)

--- # Default deny for entire namespace.
apiVersion: networking.k8s.io/v1  # API version for NetworkPolicy.
kind: NetworkPolicy               # Object that controls Pod traffic.
metadata:
  name: web-default-deny          # Name of the policy.
  namespace: app                  # Namespace where it applies.
  labels:
    app: web
spec:
  podSelector:
    matchLabels:
      app: web                    # Applies to Pods with this label.
  policyTypes:
    - Ingress                     # Rules apply to incoming traffic.
    - Egress                      # Rules apply to outgoing traffic.
  ingress: []                     # No ingress allowed by default.
  egress: []                      # No egress allowed by default.

--- # Allow all traffic from other pods in same namespace.
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: web-allow-same-namespace  # Separate policy to open limited paths.
  namespace: app
  labels:
    app: web
spec:
  podSelector:
    matchLabels:
      app: web                    # Again, applies to web Pods.
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector: {}         # Allow from any Pod in the same namespace.
```
</details>

<details>
  <summary>PodDisruptionBudget</summary>

```yaml
# Ensure a minimum number of Pods are up during voluntary disruptions

apiVersion: policy/v1          # API version for PodDisruptionBudget.
kind: PodDisruptionBudget      # Object type: controls voluntary disruptions.
metadata:
  name: web-pdb                # Name of this PDB.
  namespace: app               # Namespace where the PDB applies.
  labels:
    app: web                   # Label to match the associated Deployment/Pods.
spec:
  minAvailable: 1              # Minimum number of Pods that must stay available.
  selector:
    matchLabels:
      app: web                 # Selects Pods this PDB protects (must match Pod labels).
```
</details>

<details>
  <summary>HorizontalPodAutoscaler</summary>

```yaml
# Scale up the web deployment when CPU usage reaches >80% of its original CPU request.

apiVersion: autoscaling/v2           # HPA v2 for richer metrics support.
kind: HorizontalPodAutoscaler        # Object that scales a target workload.
metadata:
  name: web-hpa                      # Name of the HPA.
  namespace: app                     # Namespace of the HPA and target workload.
  labels:
    app: web
spec:
  scaleTargetRef:                    # Reference to the workload to scale.
    apiVersion: apps/v1              # API version of the target.
    kind: Deployment                 # Kind of the target.
    name: web                        # Name of the target Deployment.
  minReplicas: 2                     # Lower bound of replicas the HPA can set.
  maxReplicas: 10                    # Upper bound of replicas.
  metrics:                           # Metrics used for scaling.
    - type: Resource                 # Resource based metric.
      resource:
        name: cpu                    # Use container CPU usage.
        target:
          type: Utilization          # Target expressed as percentage of requested CPU.
          averageUtilization: 80     # Aim for 80 percent average CPU utilization.
```
</details>

## Cluster shutdown/bootup

- Shutdown
  - Set Ceph cluster flags
    - `kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- sh`
    - `ceph osd set noout && ceph osd set norebalance && ceph osd set nobackfull && ceph osd set norecover`
  - Drain and shutdown non-Ceph worker nodes
    - `kubectl drain --ignore-daemonsets --delete-emptydir-data`
  - Drain and shutdown Ceph nodes
  - Shutdown control plane nodes
- Bootup
  - Start control plane nodes
  - Start Ceph worker nodes
  - Unset Ceph cluster flags
  - Wait for Ceph to become healthy again
    - `ceph -s` and see if the "objects degrated" percentage goes down
  - Start remaining worker nodes

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
<details>
  <summary>Show code</summary>

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
</details>

### [ReplicaSet](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/)
- Maintains the desired number of identical pods. Usually created by a deployment.

### [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)
- Alternative to ReplicaSet for deploying stateful pods (pods that use storage).
- Ensures restarted pods keep the same name and PVC (persistent identity).

### [DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)
- Ensures a single pod is running on all nodes of a given type. Useful for collecting node metrics.

### [Service](https://kubernetes.io/docs/concepts/services-networking/service/)
  - Abstraction layer to make pods accessible.
  - Matches a set of Pods using a label.

<details>
  <summary>Show code</summary>

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
</details>

### Services

#### [ClusterIP Service](https://kubernetes.io/docs/concepts/services-networking/service/#type-clusterip)
  - Makes a service available to pods inside the cluster.
  - Used by internal-only services that communicate with each other inside the cluster.
  - Provides a single IP to access all pods within that service from inside the cluster.

<details>
  <summary>Show code</summary>

  ```yaml
  ports:
    - protocol: TCP
      port: 80          # The port of the SERVICE - All traffic on this port routes to the `targetPort` of each pod
      targetPort: 3000  # The port of the POD - The service forwards traffic from `port` to `targetPort`
  ```
</details>

#### [NodePort Service](https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport)
  - Makes a service available outside the cluster on every node at a specific port.
  - Nodes that don't have the service's pod(s) scheduled on them will forward any traffic on that port to the node(s) with the pod(s) scheduled on them.
  - Automatically provisions a ClusterIP service.
  - Ports (in service definition file) [StackOverflow explanation](https://stackoverflow.com/questions/49981601/difference-between-targetport-and-port-in-kubernetes-service-definition)

<details>
  <summary>Show code</summary>

  ```yaml
ports:
  - protocol: TCP
    port: 80          # The port of the SERVICE - For NodePort services, this can be anything
    targetPort: 3000  # The port of the POD - The service forwards traffic from `port` to `targetPort`
    nodePort: 30432   # The port of the NODE - The node listens on this port and routes traffic to the service port
```
</details>

- incoming traffic -> nodePort (NODE) -> port (SERVICE) -> targetPort (POD)
- Example (in Lens GUI): `80:30432/TCP` - This service is accessible on each node's IP over port 30432. Port 30432 on every node will forward to port 80 on the service. Port 80 of the service will then forward traffic to the `targetPort` of the service pod(s).

#### [LoadBalancer Service](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer)
  - Provisions an external cloud-managed load balancer to forward traffic to backend pods.
  - Used with cloud providers.
  - Automatically provisions a NodePort and a ClusterIP service.
<details>
  <summary>Show code</summary>

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
</details>

### [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)
  - Acts as an HTTP/HTTPS (layer 7) load balancer in front of your services.
  - Instead of having `Client -> LoadBalancer -> Service -> Pod` for every service (which creates too many LoadBalancers), Ingresses act as a middleman: `Client -> LoadBalancer -> IngressController Service -> IngressController -> Service -> Pod`.
  1. Create an IngressController deployment (like Nginx)
  3. Expose the IngressController deployment with a LoadBalancer or NodePort service
  4. Create the Ingress resource
  5. Point DNS to the LoadBalancer's public IP

<details>
  <summary>Show code</summary>

  ```yaml
# IngressController deployment
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ingress-controller
  namespace: ingress-nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      app: ingress-nginx
  template:
    metadata:
      labels:
        app: ingress-nginx
    spec:
      serviceAccountName: ingress-nginx
      containers:
      - name: controller
        image: k8s.gcr.io/ingress-nginx/controller:v1.10.1
        args:
          - /nginx-ingress-controller
        ports:
          - name: http
            containerPort: 80
          - name: https
            containerPort: 443

# LoadBalancer service to expose IngressController
---
apiVersion: v1
kind: Service
metadata:
  name: ingress-nginx
  namespace: ingress-nginx
spec:
  type: LoadBalancer
  selector:
    app: ingress-nginx
  ports:
  - name: http
    port: 80
    targetPort: 80
  - name: https
    port: 443
    targetPort: 443

# Ingress rules that the IngressController uses
---
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
</details>

### Gateway API
  - Replaces Ingress.
  - Traffic flow: Client -> External HAProxy (running outside the cluster) -> Sends traffic to a node running a NodePort Gateway Controller Service -> Decides which Service(s) to send traffic to based on its HTTPRoute rules.
  - Istio can also be used as a gateway controller.

Example setup with HAProxy VM -> Nginx Gateway
<details>
  <summary>Show code</summary>

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
</details>

HAProxy config (uses TCP mode so HTTPS is terminated by Nginx):
<details>
  <summary>Show code</summary>

```
# /etc/haproxy/haproxy.cfg
backend be_https
  balance roundrobin
  option tcp-check
  server node1 10.0.0.11:30443 check
  server node2 10.0.0.12:30443 check
  server node3 10.0.0.13:30443 check
```
</details>

Example target service with HTTP routes

<details>
  <summary>Show code</summary>

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
</details>

### Endpoint
  - Lists the IPs/ports of all pods belonging to a service.

### Operator
  - Manages the desired state of custom resources.

### [CoreDNS](https://coredns.io/plugins/)

- Update CoreDNS to use an upstream DNS server:
```
kubectl edit configmap coredns -n kube-system
```
<details>
  <summary>Show code</summary>

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
</details>

## Pods

### Probes
- ReadinessProbe: Determines whether the main process is ready to receive traffic. If it fails, the Service won't route traffic to it.
- StartupProbe: Determines whether the Pod is still staring. The Readiness and Liveness probes are delayed until this succeeds.
- LivenessProbe: Determines whether the main process is stuck. If it fails, the Pod is restarted.

## Security

### Pod Security

#### [Pod Security Standards (PSS)](https://kubernetes.io/docs/concepts/security/pod-security-standards/)
- Predefined security profiles applied to a namespace. Prevents pods from running that fail the applied standard.
  - Privileged — No restrictions. Full host access, all capabilities allowed. Intended for system-level components (CNI, CSI, monitoring agents).
  - Baseline — Blocks known privilege-escalation paths but still allows typical app workloads. For example, it disallows privileged: true or hostPID, but doesn’t require runAsNonRoot.
  - Restricted — Enforces strict hardening and best practices. Requires non-root users, drops all Linux capabilities, prohibits hostPath and host namespaces.

#### [Pod Security Admission (PSA)](https://kubernetes.io/docs/concepts/security/pod-security-admission/)
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
<details>
  <summary>Show code</summary>

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
</details>

#### Secrets
- Create an encrypted `secrets.yml` file (similar to Ansible Vault).
  - The secret is encrypted when stored in the Git repo and automatically decrypted by the cluster when applied.

<details>
  <summary>Show code</summary>

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
</details>

`sealedsecret.yml`
<details>
  <summary>Show code</summary>

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
</details>

### Network Security

#### [Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies)
- Namespace-scoped; only applies to Pods within the same namespace.
- Can reference other namespaces using `namespaceSelector` but can’t control them directly.
- Multiple policies can apply to one Pod; the union of all rules defines allowed traffic.
- Once any policy selects a Pod, all other traffic is denied by default.
- If no policies select a Pod, that Pod is open.
- Make sure to allow DNS egress (UDP/TCP 53) if outbound traffic is restricted.
- NetworkPolicies are stateful, so all response traffic is allowed.

<details>
  <summary>Show code</summary>

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
    # A logical AND is applied to these rules. They all must match: the namespace AND the pod selector.
      # To use a logical OR, put a dash before the podSelector like "- podSelector".
      # See https://kubernetes.io/docs/concepts/services-networking/network-policies/#behavior-of-to-and-from-selectors
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
</details>

- Deny all traffic in the namespace. Start with this when hardening a cluster.
- Apply this policy to each namespace (except `kube-system`), then add other policies to only permit necessary traffic.
<details>
  <summary>Show code</summary>

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
</details>

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
<details>
  <summary>Show code</summary>

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
</details>

Bind the role to alice
<details>
  <summary>Show code</summary>

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
</details>

#### [Service Accounts](https://kubernetes.io/docs/concepts/security/service-accounts/)
- Accounts managed by the k8s API, unlike human users.
- Kubernetes creates a `default` ServiceAccount in each namespace with minimal permissions.
- All pods without a ServiceAccount specified use `default`.
- Custom ServiceAccounts should be created per workload that needs API access, each with its own least-privilege RBAC bindings.
