
# Helm Chart Installation

  


#### 1-  **Nexus**
#### Install
``` sh
helm install --name nexus Helm/Nexus/
```
#### Upgrade
``` sh
helm upgrade nexus Helm/Nexus
```
#### Delete
```sh
helm del nexus --purge
```
#### 2- **Gitlab**
#### Install
``` sh
helm install --name gitlab Helm/Gitlab/
```
#### Upgrade
``` sh
helm upgrade gitlab Helm/Nexus
```
#### Delete
```sh
helm del gitlab --purge
```

# IAM Roles Configuration

>  To change the IAM roles that the containers assume, go to the 'values.yaml' file of the respective Helm chart and replace the IAM Role ARNs mentioned in all the **annotations** and also in the heading named **'roleName'**. Save the file afterwards.
After that,
1. If the Helm chart has already been installed in the cluster, then apply the *'helm upgrade'* command
2. If the Helm chart has not yet been installed, apply the *'helm install'* command.

# TLS
> To enable/disable SSL protocol, go to the *'values.yaml'* file of the respective Helm chart (Nexus or Gitlab), proceed to the heading named **tls** and change its value to true/false as required.