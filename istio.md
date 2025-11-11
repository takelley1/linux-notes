# Istio

- Service mesh for managing service-to-service traffic, security, and observability  
- Core components: Envoy proxy (sidecar), Pilot (traffic management), Citadel (security), Galley (config validation)  
- Key features: Traffic routing, mutual TLS, telemetry, policy enforcement, retries, and circuit breaking  
- Data plane: Envoy sidecars handling actual request flow  
- Benefits: Zero-code traffic management, observability with distributed tracing, fine-grained access control

## Commands

- `kubectl label namespace default istio-injection=enabled` = enable automatic sidecar injection
- `istioctl proxy-status` = view proxy sync and connection status
- `istioctl proxy-config routes <pod-name>` = inspect routing configuration for a pod
- `istioctl authn tls-check <pod>.<namespace>` = verify mTLS settings for a workload
- `istioctl analyze `= validate Istio configuration across namespaces
- Metrics (replace these in prod with a full observability stack)
  - `istioctl dashboard kiali` = open the Kiali dashboard
  - `istioctl dashboard jaeger` = open the Jaeger tracing dashboard
  - `istioctl dashboard prometheus` = open Prometheus metrics dashboard

## CRDs

### Gateway + VirtualService
- Istio has its own Gateway + VirtualService CRD for handling traffic ingress
- This replaces a standard k8s IngressController + Ingress config
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
    istio: ingressgateway    # Matches the pods in the istio-ingressgateway deployment
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
# --- VirtualService: Routing logic after TLS termination ---
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: my-service
  namespace: default
spec:
  hosts:
  - app.example.com            # Must match the host in the Gateway
  gateways:
  - istio-system/my-gateway    # Bind this routing rule to the Gateway above
  http:
  - match:
    - uri:
        prefix: /              # Match any request path
    route:
    - destination:
        host: my-service.default.svc.cluster.local  # Internal mesh service
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

## Examples

### 80/20 Traffic split
Directs traffic to different versions of a service.
```yaml
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: reviews
spec:
  hosts:
    - reviews
  http:
    - route:
        - destination:
            host: reviews
            subset: v1
          weight: 80
        - destination:
            host: reviews
            subset: v2
          weight: 20
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
