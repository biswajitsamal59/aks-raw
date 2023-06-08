While install prometheus using prometheus-community kube-prometheus-stack (https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack), sometime you might face 
issue on prometheus-prometheus-node-exporter deamonset.

Error: failed to generate container "e8adf515b2330a59dadeed4aa3a4343095895785140f78be6d83be29a34842e8" spec: failed to generate spec: path "/" is mounted on "/" but it is not a shared or 
slave mount

Follow below issue resoltion to resolve:
https://github.com/prometheus-community/helm-charts/issues/467#issuecomment-793682080


https://github.com/Azure/kubernetes-hackfest/tree/master/labs/monitoring-logging/prometheus-grafana
