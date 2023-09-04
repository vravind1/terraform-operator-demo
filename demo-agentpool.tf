provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_manifest" "agentpool_demo_agent_pool" {
  manifest = {
    "apiVersion" = "app.terraform.io/v1alpha2"
    "kind"       = "AgentPool"
    "metadata" = {
      "name"      = "demo-agent-pool"
      "namespace" = "default"
    }
    "spec" = {
      "agentDeployment" = {
        "replicas" = 3
        "spec" = {
          "containers" = [
            {
              "image" = "hashicorp/tfc-agent:latest"
              "name"  = "tfc-agent"
            },
          ]
        }
      }
      "agentTokens" = [
        {
          "name" = "demo-agent"
        },
      ]
      "name"         = "agent-pool-demo"
      "organization" = "vishnu-test-org" # replace with your org name
      "token" = {
        "secretKeyRef" = {
          "key"  = "token"
          "name" = "tfc-operator"
        }
      }
    }
  }
}
