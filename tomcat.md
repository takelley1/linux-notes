## APACHE TOMCAT

- SSL:
  - See also: https://crunchify.com/step-by-step-guide-to-enable-https-or-ssl-correct-way-on-apache-tomcat-server-port-8443/
  - SSL configuration (in `conf/server.xml`):
    ```xml
        <Connector port="443" protocol="org.apache.coyote.http11.Http11NioProtocol"
                   maxThreads="150" SSLEnabled="true">
            <SSLHostConfig>
                    <Certificate certificateFile="/opt/tomcat_certs/cert.pem" certificateKeyFile="/opt/tomcat_certs/certkey.pem"
                                 type="RSA" />
            </SSLHostConfig>
        </Connector>
    ```
