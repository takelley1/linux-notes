## FreeIPA

- [RHEL FreeIPA configuration guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/configuring_and_managing_identity_management/index#doc-wrapper)

### Commands

`ipa user-find --all --raw` = Print all FreeIPA users with their raw attribute names.

### Troubleshooting

- Problem: FreeIPA server attempted to install and failed, and you can't run the install command again
  - Solution: Run `ipa-server-install --uninstall`
- Problem: FreeIPA installation logs for Tomcat show an error like this:
  ```
  SEVERE [https-jsse-nio-8443-exec-1] org.apache.catalina.core.StandardWrapperValve.invoke Servlet.service() for servlet [jsp] in context with path [] threw exception [org.apache.jasper.
  JasperException: Unable to compile class for JSP] with root cause
  Unable to find a javac compiler;
  com.sun.tools.javac.Main is not on the classpath.
  Perhaps JAVA_HOME does not point to the JDK.
  It is currently set to "/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.412.b08-2.0.1.el8.x86_64/jre"
  ```
  - Solution: Install `java-1.8.0-opendk-devel`

### Server Setup (On OEL8)
- [OEL8 FreeIPA server guide](https://docs.oracle.com/en/learn/ol-freeipa/index.html#introduction)
- [RHEL FreeIPA server guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/installing_identity_management/index)
- A subdomain for the FreeIPA server is recommended. e.g. if your domain is `example.com` and your server is `freeipa`, then create a subdomain `ipa.example.com` so the FQDN of the FreeIPA server is `freeipa.ipa.example.com`
- Allow FreeIPA clients to reach the FreeIPA server on these ports:
  ```
  HTTP/HTTPS  80,443   TCP
  LDAP/LDAPS  389,636  TCP
  Kerberos    88,464   TCP & UDP
  NTP         123      UDP
  DNS         53       TCP & UDP
  ```
- Set a static hostname
  ```bash
  hostnamectl set-hostname freeipa.ipa.example.com
  ```
- Edit /etc/hosts
  ```
  10.128.1.1  freeipa.ipa.example.com freeipa
  127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
  ::1         localhost6 localhost6.localdomain6
  ```
- Create a DNS A record for the static hostname you set in /etc/hostname. Set the A record to resolve to the IPA server's private IP
  ```bash
  resolvectl query --cache=false freeipa.ipa.example.com
  dig freeipa.ipa.example.com
  host $(hostname -f)
  ```
- Create a DNS PTR record that resolves the IPA server's private IP to its hostname
  ```bash
  # Get the IP of the A record and check if the IP resolves to the hostname.
  resolvectl query --cache=false "$(resolvectl query --cache=false freeipa.ipa.example.com | awk '{print $2}' | head -1)"
  dig -x <PUT IP HERE>
  host $(hostname -i)
  ```
- Enable the repo
  ```bash
  sudo dnf module enable idm:DL1
  ```
- Install packages
  ```bash
  sudo dnf install -y ipa-server ipa-server-dns java-1.8.0-opendk-devel
  ```
- Setup FreeIPA as a server
  ```bash
  sudo ipa-server-install -v
  sudo ipa-dns-install --allow-zone-overlap
  ```
- Confirm server is listening on ports
  ```bash
  nmap localhost
  netstat -plant | grep "LISTEN" | grep -E "80|53|443|389|636|88|464|123"
  ```

### Linux Client Setup (OEL8)
- [RHEL FreeIPA client guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/installing_identity_management/assembly_installing-an-idm-client_installing-identity-management#doc-wrapper)
- Set a static hostname
  ```bash
  hostnamectl set-hostname ipaclient.ipa.example.com
  ```
- Edit /etc/hosts
  ```
  10.128.1.1  ipaclient.ipa.example.com ipaclient
  127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
  ::1         localhost6 localhost6.localdomain6
  ```
- Enable the repo
  ```bash
  sudo dnf module enable idm:client
  ```
- Install package (and troubleshooting tools)
  ```bash
  sudo dnf install -y ipa-client nmap
  ```
- Confirm client can resolve server
  ```bash
  dig freeipa.ipa.example.com
  ```
- Confirm client can reach server on required ports
  ```bash
  sudo nmap freeipa.ipa.example.com
  ```
- Setup FreeIPA as a client
  ```bash
  sudo ipa-client-install -v
  ```
- Test logging in as a domain user
  ```bash
  id admin@IPA.EXAMPLE.COM
  su admin@IPA.EXAMPLE.COM
  ```

### Windows Client Setup (Windows Server 2022)
- [Windows authentication in FreeIPA](https://www.freeipa.org/page/Windows_authentication_against_FreeIPA)
- [Joining Windows systems to FreeIPA](https://www.rootusers.com/how-to-login-to-windows-with-a-freeipa-account/)
>NOTE: For Windows clients, the FreeIPA server MUST be configured to provide DNS and the Windows client must use the FreeIPA server as its primary DNS server. Otherwise the Windows client won't know which server to use to authenticate domain accounts.
- ON FREEIPA SERVER (Web GUI):
  - Add Windows host: `Identity` -> `Hosts` -> `Add`
- ON FREEIPA SERVER (Shell)
  - Login as Admin
    ```bash
    # Login
    kinit admin
    # Check for valid ticket
    klist
    ```
  - Create keytab for the Windows host
    ```bash
    # Show permitted encryption types. This will be used for the -e option.
    ipa-getkeytab --permitted-enctypes
    
    # Assumes the hostname of the windows host is windowsclient.ipa.example.com
    # Assumes the hostname of the FreeIPA server is freeipa.ipa.example.com
    # Creates the krb5.keytab.windowsclient.example.com file at ./
    # The Principal password used here is used by the Windows client in a later step
    ipa-getkeytab -s freeipa.ipa.example.com -p host/windowsclient.ipa.example.com -e aes256-cts -k krb5.keytab.windowsclient.ipa.example.com -P
    ```
- ON WINDOWS CLIENT:
  - Confirm client can resolve server
    ```powershell
    nslookup freeipa.ipa.example.com
    ```
  - Confirm client can reach server on required ports
    ```powershell
    Test-NetConnection freeipa.ipa.example.com -port 88
    Test-NetConnection freeipa.ipa.example.com -port 389
    Test-NetConnection freeipa.ipa.example.com -port 464
    Test-NetConnection freeipa.ipa.example.com -port 636
    ```
  - Configure client
    ```cmd
    ksetup /setdomain EXAMPLE.COM
    ksetup /addkdc EXAMPLE.COM freeipa.ipa.example.com
    ksetup /addkpasswd EXAMPLE.COM freeipa.ipa.example.com
    :: Use the Principal password that you set during the ipa-getkeytab command earlier
    ksetup /setcomputerpassword MySuperSecretPassword!
    ksetup /mapuser * *
    ```
  - Reboot client
  - Add local users on the client corresponding to the users in FreeIPA who you wish to have access. Don't include the `@IPA.EXAMPLE.COM` part (the realm name) when adding the local user.
    - Run `lusrmgr.msc` to add local users.
    - Don't create a password for the local user since you'll be using FreeIPA to authenticate.
  - Under `Groups` -> `Remote Desktop Users`, add the user you created to the group to permit RDP login.
  - Disable Network Level Authentication
      - Run `sysdm.cpl` -> `Remote` -> disable `Allow connections only from computers running Remote Desktop with Network Level Authentication` (See [here](https://windowsreport.com/disable-nla/) for for more info)
  - Test logging in as the new user over RDP.
    - Run `mstsc` on a different PC
    - Login with the domain account: `user@IPA.EXAMPLE.COM`

### Shared NFS home directory configuration
- [NFS in IdM](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/configuring_and_managing_identity_management/index#autofs-and-automount-in-idm_using-automount-in-idm)
- ON NFS/FREEIPA SERVER (in this example the NFS server and the FreeIPA server are on the same host)
  - Cloud: configure ports
    - Ensure the NACL for the subnet the FreeIPA server is on allows the following traffic outbound.
      ```
      NFS  2049  TCP & UDP
      RPC  111   TCP & UDP
      ```
    - Ensure the Security Group for the FreeIPA server allows all TCP traffic outbound.
  - Disable firewall and SELinux
    ```bash
    setenforce 0
    systemctl disable --now firewalld
    ```
  - Obtain a Kerberos ticket as admin
    ```bash
    kinit admin
    ```
  - Create an NFS service principal
    ```bash
    ipa service-add nfs/ipa.example.com
    ```
  - Store the service principal in the Kerberos keytab file
    ```bash
    ipa-getkeytab -s ipa.example.com -p nfs/ipa.example.com -k /etc/krb5.keytab
    ```
  - View the principals
    ```bash
    klist -k /etc/krb5.keytab
    ```
  - Create home directories for users
    ```bash
    mkdir -p /nfs/ipahome/admin
    mkdir -p /nfs/ipahome/myuser
    
    chown root:root /nfs/
    chown root:root /nfs/ipahome/
    chown admin@EXAMPLE.COM:admins /nfs/ipahome/admin/
    chown myuser@EXAMPLE.COM:developers /nfs/ipahome/myuser/
    ```
  - Update /etc/exports (assumes exporting `/nfs/ipahome` on the server to clients at `*`)
    ```
    /nfs/ipahome *(rw,sec=krb5p)
    ```
  - Reload the exports
    ```bash
    exportfs -r
    ```
  - Enable and start NFS server
    ```bash
    dnf install nfs-utils -y
    systemctl enable --now nfs-server
    systemctl status nfs-server
    ```
  - Check if rpcbind and NFS are listening on the server
    ```bash
    nmap localhost
    ```
  - Create the automount location (assumes the automount location is called `homedirs`)
    ```bash
    ipa automountlocation-add homedirs
    ```
  - Create the automount map for the automount location (assumes the automount map is called `auto.ipahome`)
    ```bash
    ipa automountmap-add homedirs auto.ipahome
    ```
  - Update the `auto.ipahome` map with mount information
    ```bash
    ipa automountkey-add homedirs auto.ipahome --key='*' --info='-sec=krb5p,vers=4 ipa.example.com:/nfs/ipahome/&'
    ```
  - Update the `auto.master` map with the `auto.ipahome` map.
    ```bash
    ipa automountkey-add homedirs auto.master --key=/ipahome --info=auto.ipahome
    ```
- ON FREEIPA SERVER WEB GUI
  - Update the home directory paths of users (assumes users are `admin` and `myuser`)
    ```
    Identity -> Users -> Active users -> select user -> Home directory -> change to /ipahome/admin or /ipahome/myuser
    ```
- ON FREEIPA CLIENT
  - Cloud: configure ports
    - Ensure the NACL for the subnet the FreeIPA client is on allows all TCP traffic from the subnet the FreeIPA server is on.
    - Ensure the Security Group for the FreeIPA client allows all TCP traffic from the FreeIPA server.
  - Disable firewall and SELinux
    ```bash
    setenforce 0
    systemctl disable --now firewalld
    ```
  - Install AutoFS
    ```bash
    dnf install autofs -y
    ```
  - Mount the configured location
    ```bash
    ipa-client-automount --location homedirs
    systemctl stop autofs ; sss_cache -E ; systemctl start autofs
    ```
  - Check mounts
    ```bash
    mount | grep autofs
    ```
  - Test logging in as users
    ```bash
    su admin@EXAMPLE.COM
    cd
    echo "test content" > myfile.txt
    ls -al
    su myuser@EXAMPLE.COM
    ```
