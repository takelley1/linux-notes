## DOCKER

`docker exec -it bitbucket /bin/bash` = enter a shell in the bitbucket container.  


add `:z` to end of volume mount to prevent SELinux from denying the container access:
```yaml
 db_data_mysql:
  image: busybox
  volumes:
   - ./env/var/lib/mysql:/var/lib/mysql:z
```
