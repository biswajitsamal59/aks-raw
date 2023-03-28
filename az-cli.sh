az group create -l eastus -n aks-rg

# az aks create -g aks-rg -n aks -s "Standard_B4ms" --node-count 2
az aks create -g aks-rg -n aks --node-vm-size "Standard_B4ms" --node-count 1