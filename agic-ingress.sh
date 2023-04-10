export MY_RESOURCE_GROUP=aks-rg
export MY_CLUSTER=aks
export LOCATION=eastus
az group create -l $LOCATION -n $MY_RESOURCE_GROUP
az aks create -g $MY_RESOURCE_GROUP -n $MY_CLUSTER -s "Standard_B4ms" --node-count 1 --network-plugin azure \
    --enable-managed-identity \
    -a ingress-appgw --appgw-name myApplicationGateway --appgw-subnet-cidr "10.244.2.0/24"

az aks create -n $MY_CLUSTER -g $MY_RESOURCE_GROUP -s "Standard_B4ms" --node-count 1 --network-plugin azure \
    --enable-managed-identity -a ingress-appgw \
    --appgw-name myApplicationGateway --appgw-subnet-cidr "10.225.0.0/16" --generate-ssh-keysls

# Deploy application
k create deploy my-simple-website --image andreibarbu95/my-simple-website:v1

k expose deploy my-simple-website --port 80 --name my-simple-website-svc

# Create a Public DNS zone with valid domain (e.g. biswajitsamal.xyz) and Add A-record with application gateway public IP

# Apply manifest/ingress-appgw.yaml to AKS cluster

# Use HTTPS with self-signed cert
# Create a slef-signed certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls/tls.key -out tls/tls.crt \
-subj "/CN=*.biswajitsamal.xyz"

# Create a secret type tls using above generated key and certificate
k create secret tls ingress-secret --key tls/tls.key --cert tls/tls.crt

# Update manifest/ingress-appgw.yaml by adding tls section

# Run 2nd application
k create deploy nginx --image nginx
k expose deploy nginx --port 80 --name nginx-svc

# Add new A-record with nginx and appgw public ip

# Update manifest/ingress-appgw.yaml with a new host and tls entry

