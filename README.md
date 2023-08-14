# Terraform Kubernetes Operator 
This repository contains instructions and necessary configuration files to manage TFC resources using Kubernetes Operator.

## Prerequisites
It expects you already have a Kubernetes cluster and ```kubectl``` installed.
If you don't have one, follow this [instructions](https://github.com/vravind1/terraform-eks) to create a EKS cluster in AWS Cloud.

## Setup

###  Add the Helm repository
```
$ helm repo add hashicorp https://helm.releases.hashicorp.com
```

### Update your local Helm chart repository cache
```
$ helm repo update
```
### Install TFC Operator
This will create a new namespace 'tfc-operator-system'
```
helm install \
  demo hashicorp/terraform-cloud-operator \
  --version 2.0.0-beta7 \
  --namespace tfc-operator-system \
  --create-namespace
```

### Create a new Secret
Get TFC organization token and store it as a Kubernetes Secret
```
$ kubectl create secret generic tfc-operator --from-literal=token=<TFC-Org-Token>
```

## Agents

### Create an Agent pool with three agents

#### Deploy Agentpool and Agents
* Add the below content to demo-agent.yaml
* Update the organization name in the configuration file
```
apiVersion: app.terraform.io/v1alpha2
kind: AgentPool
metadata:
  name: demo-agent-pool
spec:
  name: agent-pool-demo
  organization: <tfc-org-name>
  token:
    secretKeyRef:
      name: tfc-operator
      key: token
  agentDeployment:
    replicas: 3
    spec:
      containers:
        - name: tfc-agent
          image: "hashicorp/tfc-agent:latest"
  agentTokens:
    - name: demo-agent
```
Run the following command to perform Kubernetes apply
```
$ kubectl apply -f demo-agent.yaml
```
Now you should be able to see the pods running in the ```default``` namespace using the follwing command.
```
$ kubectl get pods
````
You should also be able to see the Agentpool and Agents in the TFC GUI under,   
Workspace -> Settings -> Agents

### Delete Agentpool and Agents
Run this command to delete Agentpool and Agents
```
$ kubectl delete -f demo-agent.yaml
```
### Create an Agent pool with three agents (using Terraform)
#### tfk8s
* [tfk8s](https://github.com/jrhouston/tfk8s) is a tool that makes it easier to work with the Terraform Kubernetes Provider.
* It is used to migrate existing YAML manifests and use them with Terraform without having to convert YAML to HCL manually.

#### Convert YAML to HCL

Install ```tfk8s```
```
go install github.com/jrhouston/tfk8s@latest
```
#### Terraform Init
Initialize Terraform to get Kubernetes provider.
```
$ terraform init
```

#### Terraform Plan
Create execution plan.
```
$ terraform plan
```

#### Terraform Apply
Execute the actions proposed in a Terraform plan.
```
$ terraform apply
```
You should also be able to see the Agentpool and Agents in the TFC GUI under,   
Workspace -> Settings -> Agents

#### Terraform Destroy
Delete AgentPool and Agents
```
$ terraform destroy
```
