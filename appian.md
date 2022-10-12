## [Appian](https://appian.com)

### Installation

#### [Prerequisites](https://docs.appian.com/suite/help/22.3/Prerequisites.html)

```
# As root:
yum update -y
amazon-linux-extras install postgresql12
yum install postgresql-jdbc -y
vim /etc/profile.d/appian.sh
```
```
export APPIAN_HOME=/usr/local/appian
export JAVA_HOME=/usr/local/appian/java
export PATH=$JAVA_HOME/bin:$PATH:
```
```
# As root:
source /etc/profile.d/appian.sh
mkdir -p $APPIAN_HOME
mkdir -p $JAVA_HOME
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
./setupLinux64_appian-22.3.270.0.bin
```
```
This will install Appian on your computer.  Continue? [n/Y] y
Where do you want to install Appian? [/home/appian/appian] /usr/local/appian
Install with these settings? [y/n] y
```
```
# As appian:
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
cd $APPIAN_HOME/services/bin
bash password.sh -p <PASSWORD HERE>
```

