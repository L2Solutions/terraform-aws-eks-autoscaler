provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

module "autoscaler" {
  source = "../.."

  name                    = "cluster-autoscaler"
  cluster_id              = "mycluster"
  cluster_oidc_issuer_url = "https://oidc.eks.us-west-2.amazonaws.com/id/EXAMPLED539D4633E53DE1B716D3041E"
  cluster_version         = "1.20"

  autoscaler_nodeselector = {
    "nodes" = "services"
    "cpu"   = "xlarge"
  }
  autoscaler_tolerations = [{
    "key"    = "zone"
    "value"  = "true"
    "effect" = "NoSchedule"
  }]


}
