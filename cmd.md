
## Windows cmd.exe

- Loop command 200 times, waiting 10 seconds between loops
  ```cmd
  FOR /L %x IN (1,1,200) DO taskkill /F /FI "USERNAME eq troy.kelley" /IM CredentialUIBroker.exe && timeout 10
  ```
