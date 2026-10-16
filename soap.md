# SOAP (Simple Object Access Protocol)

- A method for designing web APIs.
- SOAP: Exposes operations, such as GetUser() or CreateOrder(). XML over HTTP
- REST: Exposes resources, such as /users/123. JSON over HTTP
<br><br>
- Request
```xml
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetUser>
      <UserId>123</UserId>
    </GetUser>
  </soap:Body>
</soap:Envelope>
```
- Response
```xml
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetUserResponse>
      <Name>John</Name>
    </GetUserResponse>
  </soap:Body>
</soap:Envelope>
```
