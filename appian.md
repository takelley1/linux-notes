## [Appian](https://appian.com)

- Server is available at `https://{IP}:8443/suite`
- Logs: `/usr/local/appian/logs`

## Troubleshooting

- Issue: Data Server hangs when starting
  - Solution: Check `/etc/hosts`, make sure the server has the correct IP for itself
- Issue:
  - Web browser gives a 401 after logging into the web interface
  - `/usr/local/appian/logs/tomcat-stdOut.log` shows:
    ```
    2024-12-18 16:59:03,464 [https-jsse-nio-8443-exec-8] ERROR com.appiancorp.security.cors.CorsFilter - CORS request
    rejected; invalid request from {IP} to /auth javax.servlet.ServletException: CORS origin denied:
    {IP}:8443 is not on the allowed list:[] or the request path does not match the allowed paths.
    ```
  - Solution: Access the web interface using an FQDN rather than by IP. Do this by editing your client's hosts file.

### Installation

#### [Prerequisites](https://docs.appian.com/suite/help/22.3/Prerequisites.html)

```
# As root:

# INSTALL PREREQUISITES
yum update -y
amazon-linux-extras install postgresql12
yum install postgresql-jdbc -y

# SETUP ENVIRONMENT
vim /etc/profile.d/appian.sh
```
```
export APPIAN_HOME=/usr/local/appian
export JAVA_HOME=/usr/local/appian/java
export PATH=$JAVA_HOME/bin:$PATH:
```
```
# As root:

# SOURCE ENVIRONMENT
source /etc/profile.d/appian.sh

# CREATE INSTALL DIRECTORIES
mkdir -p $APPIAN_HOME
mkdir -p $JAVA_HOME

# CONFIGURE SYSTEM
ulimit -n 100000
vim /etc/sysctl.conf
```
```
vm.max_map_count=262144
```
```
# As root:
vim /etc/security/limits.conf
```
```
*                hard   nproc            unlimited
```
```
# As root:
# CREATE APPIAN SERVICE ACCOUNT
useradd appian
usermod -a -G wheel appian
passwd appian
```
```
<PROVIDE APPIAN USERPASSWORD>
```
```
# As root:
su appian
# As appian:
# TAKE OWNERSHIP OF INSTALL PATHS
sudo chown appian $APPIAN_HOME
sudo chown appian $JAVA_HOME
sudo reboot
```

#### [Installation guide](https://docs.appian.com/suite/help/22.3/Linux_Installation_Guide.html)

- *Download Appian installer onto target server*
```
# As root:
su appian
# As appian:
# LAUNCH INSTALLER
./setupLinux64_appian-22.3.270.0.bin
```
```
This will install Appian on your computer.  Continue? [n/Y] y
Where do you want to install Appian? [/home/appian/appian] /usr/local/appian
Install with these settings? [y/n] y
```
```
# As appian:
# REGISTER APPIAN ENVIRONMENT
cd $APPIAN_HOME/_admin/_scripts/configure
bash configure.sh
```
```
1 - Create or select repository
2 - Create initial backup of Appian installation
B - Back
Q - Quit
> 1

Enter path of repository directory
B - Back
Q - Quit
> /home/appian/appian_poc

1 - Change repository
2 - Create initial backup of Appian installation
3 - Register an environment
4 - Validate configurations
5 - Deploy configurations
6 - Tools
B - Back
Q - Quit
> 3

Existing environments: None
Add a new environment
B - Back
Q - Quit
> poc

1 - Change repository
2 - Create initial backup of Appian installation
3 - Register an environment
4 - Validate configurations
5 - Deploy configurations
6 - Tools
B - Back
Q - Quit
> Q
```

#### [Post-install](https://docs.appian.com/suite/help/22.3/Post-Install_Configurations.html)

```
# As appian:
# CONFIGURE APPIAN APP SERVER PROPERTIES
cd /home/appian/appian_poc/conf/
vim custom.properties.poc
```
```
conf.suite.SCHEME=https
conf.suite.SERVER_AND_PORT=appian.example.com:8443
server.conf.processcommon.MAX_EXEC_ENGINE_LOAD_METRIC=120
conf.data.APPIAN_DATA_SOURCE=jdbc/PostgreSqlDataSource
```
```
# As appian:
# SET APPIAN STARTUP PASSWORD
cd $APPIAN_HOME/services/bin
bash password.sh -p <PASSWORD HERE>
```

#### [Configuration](https://docs.appian.com/suite/help/22.3/Linux_Installation_Guide.html)

```
# As appian:
# TEST CONNECTING TO THE DATABASE
psql -h appian.example.us-west-1.rds.amazonaws.com -p 1473 -U appian appian
```
```
# As appian:
# ENCODE THE DATABASE PASSWORD FOR THE CONFIG FILE
cd $APPIAN_HOME/_admin/_scripts/configure
bash configure.sh
```
```
1 - Change repository
2 - Create initial backup of Appian installation
3 - Register an environment
4 - Validate configurations
5 - Deploy configurations
6 - Tools
B - Back
Q - Quit
> 6

Select a tool to execute
1 - Encode passwords for use in data source configuration
2 - Configure Tomcat clustering by specifying a node name
B - Back
Q - Quit
> 1

Enter the password to encode for use in datasource configuration
B - Back
Q - Quit
> <ENTER DATABASE PASSWORD>

<COPY THE RETURNED ENCODED VALUE>
```
```
# As appian:
# CONFIGURE DATABASE CONNECTION
cd /home/appian/appian_poc/conf/
vim tomcatResources.xml.poc
```
```
<Resource name="jdbc/PostgreSqlDataSource"
    factory="com.appiancorp.tomcat.datasource.EncodedPasswordDataSourceFactory"
    type="javax.sql.DataSource"
    driverClassName="org.postgresql.Driver"
    url="jdbc:postgresql://appian.example.us-gov-west-1.rds.amazonaws.com:1473/"
    username="appian"
    password="<PUT ENCODED DATABASE PASSWORD RETURNED BY configure.sh HERE>"
    initialSize="5"
    maxActive="200"
    defaultTransactionIsolation="READ_COMMITTED"
    maxWait="30000"
    minIdle="5"
    minEvictableIdleTimeMillis="90000"
    timeBetweenEvictionRunsMillis="450000"
    validationQuery="SELECT 1"
    testOnBorrow="true"
/>
```
```
# As appian:
# CONFIGURE DATABASE CONNECTOR PLUGIN
mkdir /home/appian/appian_poc/tomcat/apache-tomcat/lib dir
cd /home/appian/appian_poc/tomcat/apache-tomcat/lib dir
wget https://jdbc.postgresql.org/download/postgresql-42.5.0.jar
```
```
# As appian:
# DEPLOY THE CONFIGURED APPLICATION
cd $APPIAN_HOME/_admin/_scripts/configure
bash configure.sh
```
```
1 - Change repository
2 - Create initial backup of Appian installation
3 - Register an environment
4 - Validate configurations
5 - Deploy configurations
6 - Tools
B - Back
Q - Quit
> 4

1 - Change repository
2 - Create initial backup of Appian installation
3 - Register an environment
4 - Validate configurations
5 - Deploy configurations
6 - Tools
B - Back
Q - Quit
> 5

Select an environment to deploy the configuration files
1 - poc
B - Back
Q - Quit
> 1

Appian recommends to perform a backup prior to deploying configurations. Would you like to backup Appian now?
1 - Yes
2 - No
B - Back
Q - Quit
> 2

Select the type of deployment to perform on the environment poc
1 - Deploy configurations to Appian
B - Back
Q - Quit
> 1
```
```
# As root:
# DEPLOY K3 LICENSE FILE
cp ./k3.lic /usr/local/appian/server/_bin/k/linux64
cd /usr/local/appian/server/_bin/k/linux64
chown appian:appian k3.lic
./k
```
```
# Type `\\` to exit if a valid license is shown.
# If the license is valid, the system info will display.
```
```
# As root:
# DEPLOY K4 LICENSE FILE
cp k4.lic /usr/local/appian/data-server/engine/bin/q/l64/
cd /usr/local/appian/data-server/engine/bin/q/l64/
chown appian:appian k4.lic
QHOME=.. ./q
```
```
# If a valid license is found, there is a one-line message with the timestamp, like so:
'2022.10.05T17:56:31.844 appian.app
```
```
# As appian:
# TOMCAT TLS/SSL CONFIGURATION
# See https://crunchify.com/step-by-step-guide-to-enable-https-or-ssl-correct-way-on-apache-tomcat-server-port-8443/
# NOTE: Binding on port 443 is not possible when running as the appian user due to lack of permissions
cd /usr/local/appian/tomcat/apache-tomcat/
keytool -genkey -alias appian_tomcat -keyalg RSA -keystore ./appian_tomcat.keystore
keytool -certreq -keyalg RSA -alias appian_tomcat -file appian_tomcat.csr -keystore appian_tomcat.keystore
vim /usr/local/appian/tomcat/apache-tomcat/conf/server.xml
```
```
<Connector port="8443" connectionTimeout="20000" bindOnInit="false" protocol="HTTP/1.1" SSLEnabled="true"
           maxHttpHeaderSize="${conf.appserver.maxHeaderSize:-8192}" maxThreads="150" scheme="https" secure="true"
           keystoreFile="/usr/local/appian/tomcat/apache-tomcat/appian_tomcat.keystore" keystorePass="<PUT PASSWORD HERE>"
           clientAuth="false" sslProtocol="TLS" sslVerifyClient="optional"
           sslEnabledProtocols="TLSv1.2,TLSv1.1,SSLv2Hello"/>
```

#### Deployment, Startup and shutdown

```
# As appian:
# DEPLOYMENT
cd $APPIAN_HOME/_admin/_scripts/configure
bash configure.sh
```
```
# As appian:
# STARTUP
cd /usr/local/appian/services/bin
/usr/local/appian/services/bin/start.sh -p <PUT PASSWORD HERE> -s all
/usr/local/appian/data-server/bin/start.sh
/usr/local/appian/search-server/bin/start.sh
/usr/local/appian/tomcat/apache-tomcat/bin/start-appserver.sh && tail -f /usr/local/appian/logs/tomcat-stdOut.log
```
```
# As appian:
# SHUTDOWN
/usr/local/appian/tomcat/apache-tomcat/bin/stop-appserver.sh
/usr/local/appian/search-server/bin/stop.sh
/usr/local/appian/data-server/bin/stop.sh
/usr/local/appian/services/bin/stop.sh -p <PUT PASSWORD HERE> -s all
```
