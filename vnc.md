
## VNC

### How to set up encrypted VNC user sessions with virtual X displays

- **See also:**
  - [Tiger VNC](https://wiki.archlinux.org/index.php/TigerVNC)

#### For users

*first you need to set your vnc password*

1. login to your account on the vnc server via ssh/console
2. run `vncpasswd` and set a password for vnc access. this is the password you will use in your vnc client
   1. if `vncpasswd` is not a recognized command, check to make sure you're connecting to the correct server
   2. if you're definitely connected to the right server, yell at your linux admin to install `tigervnc-server`
3. tell your linux admin you're ready to receive your "magic number" and wait until he/she gives it to you
   1. if your linux admin looks at you like you've got three heads, direct them to this document

*now you need to configure your ssh client for tunnelling vnc so the connection is encrypted*
4. open putty and create a new profile for your vnc tunnel
5. on the left sidebar, expand `SSH` and in the `X11` menu, turn on `Enable X11 forwarding`

*now we will configure the tunnel using your magic number*
6. open the `Tunnels` menu under `SSH` in putty
7. the `source port` field is `590[MAGIC-NUMBER]`, so if, for example, your magic number is `9`, the field would be `5909`
   1. if your Linux admin gives you a magic number two digits long, the field would be `59[MAGIC-NUMBER]`
   2. for example, if your magic number is `24`, the `source port` field would be `5924`
8. the `destination` field is `[VNC-SERVER-IP]:590[MAGIC-NUMBER]`
9. at the top, make sure to turn on `Local ports accept connections from other hosts`
10. save this profile and launch an ssh connection to the vnc server using your new profile.
11. authenticate to the vnc server using your regular user account name and password

*you're now tunneling your vnc port through ssh, now you just need to start the vnc session*
12. launch your vnc viewer of choice and connect to `localhost:590[MAGIC-NUMBER]`
13. if you're lucky, you'll be asked to authenticate using your vnc password and start the session.
14. thank your linux admin for configuring things properly

> NOTE: you may still receive a warning from your vnc client that your session is unencrypted. This is
        because the vnc client isn't aware it's being tunneled through ssh. In order to test this and make sure
        the session is encrypted, simply terminate your ssh connection to the vnc server. If your vnc session also
        terminates, then you know it was an encrypted session. You can also use the `netstat -plant` command to
        see the forwarded ports on the vnc server.


#### For admins

*these steps are to create new vnc service for a new user. do not begin these steps until the new user has
set their vnc password by logging into the vnc server machine and running "vncpasswd" with their user account.*

1. login to the vnc server and make sure the package `tigervnc-server` is installed
2. run `cd /etc/systemd/system` and check if other `vncserver-[USERNAME]@.service` files exist
3. if they do, then just copy one of them and call the new file `vncserver-[NEW-USERNAME]@.service`
4. edit the new file and replace the two instances of `[USERNAME]` with `[NEW-USERNAME]`

*now, the new user needs a unique port to connect to so they don't interfere with other users' sessions*
- vnc ports run from `5900` to `6001`
- each user gets a unique port
- the first vnc user on the server uses port `5901`, the second user uses port `5902`, etc.
- the "magic number" is just the last digit of the port number, so it's easier for the user to remember

3a - if other `vncserver-[USERNAME]@.service` files do not already exist, you must copy the original service file
3b - run `cp /usr/lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@.service.bak`
3c - cd into the `/etc/systemd/system/` directory
3d - run `cp vncserver@.service.bak vncserver-[NEW-USERNAME]@.service`
3e - edit `vncserver-[NEW-USERNAME]@.service` and replace the two instances of `<USER>` with `[NEW-USERNAME]`
3f - if this is the first vnc user on this server, then their magic number is `1`
3g - jump to step 8

5. to determine the correct "magic number" to give the new user, look for files with
   the name format `/etc/systemd/system/multi-user.target.wants/vncserver-[USERNAME]@[NUMBER].service`
6. you will see that each user in the `multi-user.target.wants directory` has a unique `[NUMBER]` assigned to them,
   these numbers are the users' "magic numbers". The new user's magic number will simply be the highest `[NUMBER]` in
   this directory plus one.

- now that you have the new user's magic number, you'll create and enable the new user's vnc service
- the "magic number" corresponds to the virtual display number of the vnc service, which also corresponds
  to the last digit of the port number they connect to, so everything is easy to remember
- ex: the fifth user on the vnc server will have a magic number of `5` and connect via port `5905` using virtual display #5

7. run `systemctl start vncserver-[NEW-USERNAME]@:[NEW-USER-MAGIC-NUMBER].service`
8. if the service starts without any errors, run
   `systemctl enable vncserver-[NEW-USERNAME]@:[NEW-USER-MAGIC-NUMBER].service`
9. give the user their magic number and tell them to not break anything

#### Troubleshooting

- common reasons for the vnc service not starting include:
  - the new user has not set their vnc password using the `vncpasswd` command
  - you forgot the colon after the `@` sign
  - you forgot you haven't created the service yet or you mistyped the service's name
  - you're having a bad day
  - the vnc server is having a bad day

- for port tunneling, enable sshd debug logging by editing `/etc/ssh/sshd_config`
  - sometimes `sshd` will misbehave and deny port forwards coming from port vnc ports
  - try closing all connections, restarting the corresponding vnc service, and restoring the ssh tunnel
  - you can also look at the output of `netstat -plant` to see if vnc is listening on the corretly tunneled port
    - vnc will appear as `Xvnc` in `ps` and "netstat" output
