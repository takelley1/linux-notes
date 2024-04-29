## FreeIPA

### Troubleshooting

- Problem: FreeIPA server attempted to install and failed, and you can't run the install command again.
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

### Setup (On OEL8)
- [OEL8 FreeIPA guide](https://docs.oracle.com/en/learn/ol-freeipa/index.html#introduction)
- [RHEL FreeIPA guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/installing_identity_management/index)
- Set a static hostname
  ```
  hostnamectl set-hostname ipa.example.com
  ```
- Edit /etc/hosts
  ```
  10.128.1.1 ipa.example.com ipa
  127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
  ::1         localhost6 localhost6.localdomain6
  ```
- Create a DNS A record for the static hostname you set in /etc/hostname. Set the A record to resolve to the IPA server's private IP.
  ```
  resolvectl query --cache=false ipa.example.com
  dig ipa.example.com
  host $(hostname -f)
  ```
- Create a DNS PTR record that resolves the IPA server's private IP to its hostname.
  ```
  # Get the IP of the A record and check if the IP resolves to the hostname.
  resolvectl query --cache=false "$(resolvectl query --cache=false ipa.example.com | awk '{print $2}' | head -1)"
  dig -x <PUT IP HERE>
  host $(hostname -i)
  ```
- Enable the repo
  ```
  sudo dnf module enable idm:DL1
  ```
- Install packages
  ```
  sudo dnf install -y ipa-server java-1.8.0-opendk-devel
  ```
- Setup freeIPA
  ```
  sudo ipa-server-install
  ```
