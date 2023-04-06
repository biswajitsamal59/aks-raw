#GitHUB TOKEN: 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
az group create -l eastus -n aks-rg

# az aks create -g aks-rg -n aks -s "Standard_B4ms" --node-count 1
az aks create -g aks-rg -n aks --node-vm-size "Standard_B4ms" --node-count 1

# aks for flux
az aks create -g aks-rg -n aks -s "Standard_B4ms" --node-count 1 --network-plugin azure

# enable secret store csi driver
az aks create -g aks-rg -n aks -s "Standard_B4ms" --node-count 1 --network-plugin azure --enable-addons azure-keyvault-secrets-provider
az aks create -g aks-rg -n aks -s "Standard_B4ms" --node-count 1 --enable-addons azure-keyvault-secrets-provider


flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=flux-aks \
  --branch=master \
  --path=./clusters/dev \
  --personal


export GITHUB_USER=biswajitsamal59
export GITHUB_TOKEN=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

az keyvault purge --subscription a57d3dc5-2c9c-482f-8a7f-dd6bad0717e5 -n aks-kv-bis01


NODE_GROUP=$(az aks show -g aks-rg -n aks --query nodeResourceGroup -o tsv)
NODES_RESOURCE_ID=$(az group show -n $NODE_GROUP -o tsv --query "id")
az role assignment create --role "Virtual Machine Contributor" --assignee d7a7974d-0fc2-42f0-bb42-c9be78780d17 --scope $NODES_RESOURCE_ID