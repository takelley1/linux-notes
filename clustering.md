## Clustering

### [Pacemaker](https://clusterlabs.org/pacemaker/doc/)

- `pcs status --full` = Show general cluster status.
- `pcs config` = Show entire cluster configuration.
- `pcs constraint show --full` = Show constraints with IDs.
<br><br>
- `pcs node standby`/`pcs node unstandby` = Temporarily enable/disable the current node.
- `pcs cluster stop --all && pcs cluster start --all` = Restart cluster.

#### Properties
- `pcs property set stonith-enabled=false` = Disable STONITH.
- `pcs property set no-quorum-policy=ignore` = Keep resources running even if quorum is lost.
- `pcs resource defaults resource-stickiness=100` = Ensure cluster resources don't move from their current node.

#### Resources
- `pcs resource agents` = List available resource agents.
- `pcs resource create zabbix_ip ocf:heartbeat:IPaddr2 ip=10.0.0.20 op monitor interval=5s --group zabbix_cluster` = Create a floating IP for the cluster.
- `pcs resource create zabbix_web systemd:rh-nginx116-nginx op monitor interval=20s --group zabbix_cluster` = Create an Nginx systemd resource.
- `pcs resource cleanup` = Reset failed or stopped resources.

#### Constraints
- `pcs constraint order zabbix_ip then zabbix_server` = Ensure the *zabbix_ip* resource starts before *zabbix_server*.
- `pcs constraint colocation add zabbix_ip with zabbix_server INFINITY` = Ensure *zabbix_ip* resource is on the same node as *zabbix_server*.
