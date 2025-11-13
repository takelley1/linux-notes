# Istio

- Service mesh for managing service-to-service traffic, security, and observability
- Key features: Traffic routing, mutual TLS, telemetry, policy enforcement, retries, and circuit breaking
- Exposes service metrics beyond what `kube-prometheus-stack` would do for regular Pods

## Commands

- `kubectl label namespace default istio-injection=enabled` = enable automatic sidecar injection
- `istioctl proxy-status` = view proxy sync and connection status
- `istioctl proxy-config routes <pod-name>` = inspect routing configuration for a pod
- `istioctl authn tls-check <pod>.<namespace>` = verify mTLS settings for a workload
- `istioctl analyze `= validate Istio configuration across namespaces
- Metrics Dashboards (replace these dashboards in prod with a full observability stack that scrapes Istio telemetry)
  - `istioctl dashboard kiali` = open the Kiali dashboard
  - `istioctl dashboard jaeger` = open the Jaeger tracing dashboard
  - `istioctl dashboard prometheus` = open Prometheus metrics dashboard

## CRDs

### Gateway + VirtualService
- Istio has its own Gateway + VirtualService CRD for handling traffic ingress.
- This can replace a standard k8s IngressController + Ingress config.
<br><br>
- A VirtualService is just a set of routing rules that controls how requests are routed to services.
- VirtualService resources can also be used for internal service-service (east-west) routing instead of just handling ingress traffic (north-south).
```yaml
# --- Service: Exposes Istio Ingress Gateway to the outside world ---
apiVersion: v1
kind: Service
metadata:
  name: istio-ingressgateway
  namespace: istio-system
  labels:
    istio: ingressgateway
spec:
  # This makes the gateway reachable from outside the cluster.
  # The cloud provider will provision a public IP or load balancer.
  type: LoadBalancer
  selector:
    istio: ingressgateway    # Matches the pods in the istio: ingressgateway deployment (this deployment is automatically created when Istio is installed)
  ports:
  - name: http2              # Optional HTTP port (can redirect to HTTPS)
    port: 80
    targetPort: 8080         # Envoy’s HTTP listener inside the pod
  - name: https              # Main HTTPS listener
    port: 443
    targetPort: 8443         # Envoy’s HTTPS listener
---
# --- Gateway: Defines the Envoy listener configuration ---
apiVersion: networking.istio.io/v1beta1
kind: Gateway
metadata:
  name: my-gateway
  namespace: istio-system
spec:
  selector:
    istio: ingressgateway    # Tells Istio which Envoy proxies this Gateway applies to
  servers:
  - port:
      number: 443
      name: https
      protocol: HTTPS
    tls:
      mode: SIMPLE           # SIMPLE = one-way TLS termination
      credentialName: app-tls  # Refers to the K8s secret containing cert/key
                               # Secret must be in istio-system namespace
                               # cert-manager can keep this secret up to date
    hosts:
    - app.example.com         # Hostname this listener accepts
---
# --- VirtualService: Routing logic after TLS termination (mTLS will still occur inside the cluster though) ---
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: my-service
  namespace: default
spec:
  hosts:
  - app.example.com            # Must match the host in the Gateway (or the hostname of the service if handling east-west traffic, like myservice.default.svc.cluster.local)
  gateways:
  - istio-system/my-gateway    # Bind this routing rule to the Gateway above
  http:
  - match:
    - uri:
        prefix: /              # Match any request path
    route:
    - destination:
        host: my-service.default.svc.cluster.local
        port:
          number: 80
        # The ingress Envoy forwards the request to this destination
        # Communication is secured by mTLS between Envoys inside the mesh
---
# --- Backend Service: Destination inside the mesh ---
apiVersion: v1
kind: Service
metadata:
  name: my-service
  namespace: default
spec:
  selector:
    app: my-service
  ports:
  - port: 80
    targetPort: 8080           # The application container’s listening port
```

### DestinationRules

- You can think of virtual services as how you route your traffic to a given destination, and then you use destination rules to configure what happens to traffic for that destination.
- Used for creating service subsets, which are logical divisions of a single service based on Pod labels.
<br><br>
- Enables a Canary rollout pattern
  - Useful for testing upgrades by gradually shifting traffic to the new version
```yaml
# The service that matches all versions of the app.
apiVersion: v1
kind: Service
metadata:
  name: payments
spec:
  selector:
    app: payments      # notice: no version here
  ports:
    - port: 80
      targetPort: 8080
---
# The old app version we're running currently.
apiVersion: apps/v1
kind: Deployment
metadata:
  name: payments-v1
spec:
  replicas: 5
  selector:
    matchLabels:
      app: payments
      version: v1
  template:
    metadata:
      labels:
        app: payments
        version: v1
    spec:
      containers:
      - name: payments
        image: your-registry/payments:v1
        ports:
        - containerPort: 8080
---
# The new app version we'll be rolling out by canary.
apiVersion: apps/v1
kind: Deployment
metadata:
  name: payments-v2
spec:
  replicas: 1           # start small
  selector:
    matchLabels:
      app: payments
      version: v2
  template:
    metadata:
      labels:
        app: payments
        version: v2
    spec:
      containers:
      - name: payments
        image: your-registry/payments:v2
        ports:
        - containerPort: 8080
---
# Split the app into v1 and v2 service subsets based on their deployment labels.
apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata:
  name: payments
spec:
  host: payments
  subsets:
  - name: v1
    labels:
      version: v1
  - name: v2
    labels:
      version: v2
---
# Create a canary VirtualService that routes 1% of traffic to the new version.
# Gradually change the weight until you're satisfied with the rollout.
# You can use ArgoCD to also do this automatically.
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: payments
spec:
  hosts:
  - payments
  http:
  - route:
    - destination:
        host: payments
        subset: v1
      weight: 99
    - destination:
        host: payments
        subset: v2
      weight: 1
```

### Enforce mTLS
```yaml
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: default
  namespace: default
spec:
  mtls:
    mode: STRICT
```

### Enable access logging
```yaml
apiVersion: telemetry.istio.io/v1alpha1
kind: Telemetry
metadata:
  name: access-logs
  namespace: istio-system
spec:
  accessLogging:
    - providers:
        - name: envoy
```
