apiVersion: v1
kind: ServiceAccount
metadata:
  name: ${pod_name}
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRole
metadata:
  name: ${pod_name}
rules:
- apiGroups: [""]
  resources: ["services"]
  verbs: ["get","watch","list"]
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get","watch","list"]
- apiGroups: ["extensions"]
  resources: ["ingresses"]
  verbs: ["get","watch","list"]
- apiGroups: [""]
  resources: ["nodes"]
  verbs: ["list"]
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: ${pod_name}-viewer
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: ${pod_name}
subjects:
- kind: ServiceAccount
  name: ${pod_name}
  namespace: kube-system
---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: ${pod_name}
  namespace: kube-system
spec:
  strategy:
    type: Recreate
  template:
    metadata:
      annotations:
          iam.amazonaws.com/role: ${dns_role}
      labels:
        app: ${pod_name}
    spec:
      serviceAccountName: ${pod_name}
      containers:
      - name: ${pod_name}
        image: registry.opensource.zalan.do/teapot/external-dns:${external_dns_version}
        args:
        - --source=service
        - --source=ingress
        - --domain-filter=${domain_name}
        - --provider=aws
        - --policy=${policy}
        - --aws-zone-type=${zone_type}
        - --registry=txt
        - --txt-owner-id=${cluster_name}
