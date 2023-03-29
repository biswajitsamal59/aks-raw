# Print certificate information
```shell
openssl x509 -in testcert.crt -text -noout
```

# Print certificate end date
```shell
openssl x509 -in testcert.crt -enddate -noout
```

# Convert CRT to PFX
```shell
openssl pkcs12 -export -out testcert.pfx -inkey testcert.key -in testcert.crt
```

# Convert PEM to PFX and upload to Azure Key vault
```shell
openssl pkcs12 -export -out testcert.pfx -inkey testcert.key -in testcert.pem
```
```shell
az keyvault certificate import --vault-name aks-kv -n testcert -f testcert.pfx
```

# Convert PEM to PFX along with RootCA and SubCA certificate
```shell
openssl pkcs12 -export -out testcert.pfx -inkey testcert-private-key.pem -in testcert.pem -certfile rootca.pem -certfile subca.pem
```

# Convert PFX to PEM
- If private key and certs are combined to a single PFX
```shell
openssl pkcs12 -in testcert.pfx -nocerts -out private-key-encrypted.pem
```
- Leave important password blank, type any text for pem passphrase
```shell
openssl rsa -in private-key-encrypted.pem -out private-key.pem
```
- Enter the passphrase set above, this will give an unencrypted key
- Now use below command to get client cert
```shell
openssl pkcs12 -in testcert.pfx -clcerts -nokeys -out testcert.pem
```