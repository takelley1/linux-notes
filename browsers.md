## BROWSERS

## Firefox Debug tools / Inspector menu

1. F12 or right-click -> `Inspect`

### Header Manipulation

2. Open `Network` tab
3. Request the desired URL in your browser
4. Click desired request in inspector
5. Click `Headers` tab in right side-bar
6. Click `Resend` -> `Edit and Resend`

### Copy request as CURL command

2. Open `Network` tab
3. Request the desired URL in your browser
4. Right click desired request in inspector -> Copy -> Copy as cURL (POSIX)
5. (Optional) Use [this site](https://curlconverter.com/) to convert to Python-style request
