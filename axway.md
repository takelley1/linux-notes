
## Oracle Axway API

Make a curl request to the API:
```bash
curl \
        --cert ./axway_api_cert.pem \
        --key ./axway_api_cert_key.pem \
        -vkL https://example.com/webservices/rest/MCCONFIGDATA/get_config_data/ \
        -H "Content-Type: application/json" \
        -d \
'{
"Get_ConfigData": {
        "@xmlns": "https://example.com/webservices/rest/MCCONFIGDATA/get_config_data/",
        "RESTHeader": {
            "xmlns": "https://example.com/webservices/rest/MCCONFIGDATA/get_config_data/"
        },
        "InputParameters": {
            "P_CONFIG_DATA_TYPE_NAME": "TASK_STATUS",
            "P_LAST_SYNC_DATE": "08-SEP-2022"
        }
        }
}'
```
