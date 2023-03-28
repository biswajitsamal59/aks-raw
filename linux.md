# (1) Install Azure CLI and Kubectl
- Install Azure CLI on Liux (don't use apt install azure-cli directly on WSL, use below script)
```shell
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

- Install kubectl using azure cli on Linux (Recommended for AKS)
```shell
sudo az aks install-cli
```

- kubectl and kubelogin will be downloaded to /usr/local/bin


# (2) Add auto completion and Set alias for kubectl as k
- open .bashrc file
```shell
vim ~/.bashrc
```

- Add following code to .bashrc
```shell
source <(kubectl completion bash)
complete -F __start_kubectl k
alias k=kubectl
alias kn='k config set-context --current --namespace'
```

- Reload bash profile
```shell
source ~/.bashrc
```

# (3) Connect to AKS Node (by running privileged pod on the node)
- Using kubectl debug (https://learn.microsoft.com/en-us/azure/aks/node-access)
- Using node-shell (Uses an alpine pod with nsenter for Linux nodes) (https://github.com/kvaps/kubectl-node-shell)

# (4) AKS linux networking command (For Kubenet network pugin)
- To see the node internal route table (Connect to the node)
- This displays the routing table which includes entries added by kubenet for routing traffic between pods in the same node
```shell
ip route show
```

- To see the ARP table
- Output indicates the pod ips, associated mac and interface
```shell
arp -a
```