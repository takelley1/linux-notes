## Fapolicyd

### Troubleshooting

Examples of issues caused by fapolicyd:
```
[root@host tkelley]# docker run -it --runtime crun hello-world
docker: Error response from daemon: OCI runtime start failed: crun did not terminate successfully: exit status 127: crun: error while loading shared libraries: libsystemd.so.0: cannot open shared object file: Operation not permitted
: unknown.
ERRO[0000] error waiting for container: context canceled

[root@host tkelley]# docker run -it --runtime crun hello-world
docker: Error response from daemon: failed to create task for container: failed to create shim task: OCI runtime create failed: unable to retrieve OCI runtime error (open /var/run/docker/containerd/daemon/io.containerd.runtime.v2.task/moby/e4299f10a6f953d2b0821b133aaf25eae24ebf3fddfed8f80b800b72947d86c7/log.json: no such file or directory): crun did not terminate successfully: exit status 127: crun: error while loading shared libraries: libsystemd.so.0: cannot open shared object file: Operation not permitted
: unknown.
ERRO[0000] error waiting for container: context canceled
```
