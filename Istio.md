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
- `istioctl dashboard kiali` = open the Kiali dashboard
- `istioctl dashboard jaeger` = open the Jaeger tracing dashboard
- `istioctl dashboard prometheus` = open Prometheus metrics dashboard

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
