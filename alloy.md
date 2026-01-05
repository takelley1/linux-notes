# Alloy

- Troubleshoot prometheus blackbox exporter probe inside alloy pod:
  - port-forward the alloy pod to localhost, then run
  - `curl "http://localhost:12345/api/v0/component/prometheus.exporter.blackbox.default/probe?target=https://example.com&module=http_2xx&debug=true"`

- Example config scraping metrics from `node-exporter` pods in a k8s cluster:
  ```hcl
  discovery.kubernetes "node_exporter_pods" {
      role = "pod"
  }
  
  // Filter out the node exporter pods we want to scrape metrics from
  discovery.relabel "node_exporter_targets" {
    targets = discovery.kubernetes.node_exporter_pods.targets
  
    // Filter out the node exporter pods by name
    rule {
      source_labels = ["__meta_kubernetes_pod_label_app_kubernetes_io_name"]
      regex = "prometheus-node-exporter"
      action = "keep"
    }
  
    // Only scrape the pod on port 9100
    rule {
      source_labels = ["__meta_kubernetes_pod_ip"]
      target_label = "__address__"
      replacement = "$1:9100"
    }
  
    // Name the node exporter pod after the instance it's on
    rule {
      source_labels = ["__meta_kubernetes_pod_node_name"]
      target_label = "instance"
    }
  }
  
  // Get metrics from node exporter pods
  prometheus.scrape "node_exporter" {
    job_name = "node-exporter"
  
    targets = discovery.relabel.node_exporter_targets.output
    forward_to = [prometheus.remote_write.mimir.receiver]
  }
  
  // Remote write to mimir
  prometheus.remote_write "mimir" {
    endpoint {
      url = "http://mimir-gateway.mimir.svc.cluster.local/api/v1/push"
    }
  
    // Identifty the cluster the metrics are coming from
    external_labels = {
      cluster = "My Monitoring Cluster",
    }
  }
  ```
