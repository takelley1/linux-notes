
- **See also:**
  - [CNCF landscape](https://landscape.cncf.io/)

## [DOCKER](https://docs.docker.com/)

### Building

- `docker build -t mycontainer:latest .` = Build container in current context with name *mycontainer*.
- `docker run -it mycontainer` = Run container and attach to its shell.

### Swarm

- `docker stack rm zabbix` = Remove zabbix stack.
- `docker stack deploy zabbix -c zabbix-stack.yml` = Deploy zabbix stack using the *zabbix-stack.yml* file.

### Managing

- `docker rm -f $(docker ps -aq)` = Remove all stopped containers.
- `docker image rm $(docker image ls -q)` = Remove all images.
<br><br>
- `docker exec -it bitbucket /bin/bash` = Enter a shell in the bitbucket container.
<br><br>
- `docker stack services -q jitsi | xargs -L1 -I{} sh -c 'docker service logs -f {} &'` = Tail combined logs for all services in the jitsi stack.
- `pkill -f 'docker service logs'` = [Stop logs.](https://github.com/moby/moby/issues/31458)
<br><br>
- Add `:z` to end of volume mount to prevent SELinux from denying the container access:
```yaml
 db_data_mysql:
  image: busybox
  volumes:
   - ./env/var/lib/mysql:/var/lib/mysql:z
```


---
## [PODMAN](https://docs.podman.io/en/latest/#)

- **See also:**
  - [Podman networking](https://www.redhat.com/sysadmin/container-networking-podman)
  - [Moving from Docker to Podman](https://www.redhat.com/sysadmin/compose-podman-pods)


---
## [LXC](https://linuxcontainers.org/lxc/introduction/)


![image](images/lxc-vs-docker.png)

---
### Container implementations comparison
```
 Application Containers (Docker, Podman)
┌───────────────┐   ┌───────────────┐
│  Application  │   │  Application  │
├───────────────┤   ├───────────────┤
│   Container   │   │   Container   │
├───────────────┴───┴───────────────┤
│            OS + Kernel            │
└───────────────────────────────────┘

 OS Containers (LXC/LXD, FreeBSD Jails)
┌─────┐   ┌──────┐ ┌─────┐   ┌──────┐
│App 1│...│App 99│ │App 1│...│App 99│
├─────┴───┴──────┤ ├─────┴───┴──────┤
│ OS + Container │ │ OS + Container │
├────────────────┴─┴────────────────┤
│            OS + Kernel            │
└───────────────────────────────────┘

 Unikernels (ClickOS, IncludeOS)
┌───────────────┐   ┌───────────────┐
│  Application  │   │  Application  │
├───────────────┤   ├───────────────┤
│    Kernel     │   │    Kernel     │
├───────────────┴───┴───────────────┤
│            Hypervisor             │
└───────────────────────────────────┘

 Virtual Machines (KVM, QEMU, Xen, Bhyve)
┌─────┐   ┌──────┐ ┌─────┐   ┌──────┐
│App 1│...│App 99│ │App 1│...│App 99│
├─────┴───┴──────┤ ├─────┴───┴──────┤
│  OS + Kernel   │ │  OS + Kernel   │
├────────────────┴─┴────────────────┤
│            Hypervisor             │
└───────────────────────────────────┘
```
