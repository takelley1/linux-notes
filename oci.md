## OCI

(Oracle Cloud Infrastructure)

Error:
```
│ Error: 404-NotAuthorizedOrNotFound, Authorization failed or requested resource not found.
│ Suggestion: Either the resource has been deleted or service Core Instance need policy to access this resource. Policy reference: https://docs.oracle.com/en-us/iaas/Content/Identity/Reference/policyreference.htm
│ Documentation: https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_instance
│ API Reference: https://docs.oracle.com/iaas/api/#/en/iaas/XXXXXXXX/Instance/LaunchInstance
│ Request Target: POST https://iaas.us-langley-1.oraclegovcloud.com/XXXXXXXX/instances
│ Provider version: 5.6.0, released on 2023-07-26.
│ Service: Core Instance
│ Operation Name: LaunchInstance
│ OPC request ID: dd13c7e65331d7df71bf48fefb2a3b1e/EBC8622C14E998B0EA5256F6C6956488/40485C9F2F915606B901F52941067FD6
```

Resolution:
- Remove `kms_key_id` from the resource in question.
- This issue can be caused by a number of unspecified things. Any issue that OCI doesn't like, such as an incorrect OCID or incorrect terraform syntax.
