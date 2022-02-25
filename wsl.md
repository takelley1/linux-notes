
### Troubleshooting

- [The I/O operation has been aborted because of either a thread exit or an application request](https://github.com/microsoft/WSL/issues/5633)
  1. Reboot, then try again
  2. Export and import the distro, then try again
  ```
  wsl --export Ubuntu ubuntu.backup
  wsl --import Ubuntu ubunti.backup
  ```
