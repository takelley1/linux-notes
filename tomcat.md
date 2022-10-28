## [Apache Tomcat](https://tomcat.apache.org/)

- SSL:
  - [Full guide](https://crunchify.com/step-by-step-guide-to-enable-https-or-ssl-correct-way-on-apache-tomcat-server-port-8443/)
    - [For importing certs manually into keystore](https://docs.oracle.com/en/database/other-databases/nosql-database/21.2/security/import-key-pair-java-keystore.html)
  - SSL configuration (in `conf/server.xml`):
    ```xml
    <Connector port="443" protocol="HTTP/1.1" SSLEnabled="true"
               maxThreads="150" scheme="https" secure="true"
               keystoreFile="/opt/tomcat_certs/tomcat.keystore" keystorePass="QA4urSnTA5PTsr4i"
               clientAuth="false" sslProtocol="TLS" sslVerifyClient="optional"
               sslEnabledProtocols="TLSv1.2,TLSv1.1,SSLv2Hello"/>
    ```
