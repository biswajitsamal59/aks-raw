# Prerequisite: AKS cluster
# Follow https://learn.microsoft.com/en-us/azure/aks/ingress-basic?tabs=azure-cli docs
NAMESPACE=ingress-basic

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install ingress-nginx ingress-nginx/ingress-nginx \
  --create-namespace \
  --namespace $NAMESPACE \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz

# Create a new namespace for running application workloads
NAMESPACE_APP=app-01
kubectl create ns $NAMESPACE_APP

# Run aks-helloworld-one.yaml and aks-helloworld-two.yaml files
kubectl apply -f manifest/aks-helloworld-one.yaml --namespace $NAMESPACE_APP
kubectl apply -f manifest/aaks-helloworld-two.yaml --namespace $NAMESPACE_APP

# Create a Public DNS zone with valid domain (e.g. biswajitsamal.xyz) and Add A-record with ingress-nginx-controller public IP (app01.biswajitsamal.xyz)

# Use HTTPS with self-signed cert
# Create a slef-signed certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls/tls.key -out tls/tls.crt \
-subj "/CN=*.biswajitsamal.xyz"

# Create a secret type tls using above generated key and certificate
k create secret tls ingress-secret --key tls/tls.key --cert tls/tls.crt --namespace $NAMESPACE_APP

# Run ingress manifest
k apply -f manifest/ingress-nginx.yaml -n $NAMESPACE_APP

# Run below curl command to check the cert details
# curl -v -k app02.biswajitsamal.xyz:443:20.242.248.12 https://app02.biswajitsamal.xyz
curl -v -k https://app02.biswajitsamal.xyz