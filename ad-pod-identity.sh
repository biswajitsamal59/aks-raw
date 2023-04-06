# Docs: https://learn.microsoft.com/en-us/azure/aks/use-azure-ad-pod-identity
# Role Assignment: https://azure.github.io/aad-pod-identity/docs/getting-started/role-assignment/#performing-role-assignments
# Helm Repo Link: https://azure.github.io/aad-pod-identity/docs/configure/pod_identity_in_managed_mode/
# AD Pod managed identities supports two operation mode: Standard and Managed
# In this example we are implementing using Standard and helm package

export MY_RESOURCE_GROUP=aks-rg
export MY_CLUSTER=aks
export LOCATION=eastus
az group create -l $LOCATION -n $MY_RESOURCE_GROUP
az aks create -g $MY_RESOURCE_GROUP -n $MY_CLUSTER -s "Standard_B4ms" --node-count 1 --network-plugin azure --enable-addons azure-keyvault-secrets-provider
az aks update -g $MY_RESOURCE_GROUP -n $MY_CLUSTER --enable-pod-identity

export IDENTITY_RESOURCE_GROUP="myIdentityResourceGroup"
export IDENTITY_NAME="application-identity"
az group create --name ${IDENTITY_RESOURCE_GROUP} --location eastus
az identity create --resource-group ${IDENTITY_RESOURCE_GROUP} --name ${IDENTITY_NAME}
export IDENTITY_CLIENT_ID="$(az identity show -g ${IDENTITY_RESOURCE_GROUP} -n ${IDENTITY_NAME} --query clientId -otsv)"
export IDENTITY_RESOURCE_ID="$(az identity show -g ${IDENTITY_RESOURCE_GROUP} -n ${IDENTITY_NAME} --query id -otsv)"

# AKS kubelet managed identity should have Managed Identity Operator and Virtual Machine Contributor role assignment to NodeResourceGroup
az role assignment create --role "Managed Identity Operator" --assignee <ID> --scope /subscriptions/<SubscriptionID>/resourcegroups/<NodeResourceGroup>
az role assignment create --role "Virtual Machine Contributor" --assignee <ID> --scope /subscriptions/<SubscriptionID>/resourcegroups/<NodeResourceGroup>

# MCI will automatically manage identity assignment (eg. application-identity) and removal from VMSS, but it will take some time while doing this operation
# You can use below command to explicitly add it
az vmss identity assign -n <VMSS name> -g <rg> --identities <IdentityResourceID>

# After this follow flux-aks repo for configuring aad-pod-identity and application deployment