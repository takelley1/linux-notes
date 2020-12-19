
## DOCKER

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
- `pkill -f 'docker service logs'` = Stop logs. <sup>[1]</sup>
<br><br>
- Add `:z` to end of volume mount to prevent SELinux from denying the container access:
```yaml
 db_data_mysql:
  image: busybox
  volumes:
   - ./env/var/lib/mysql:/var/lib/mysql:z
```

[1]: https://github.com/moby/moby/issues/31458
