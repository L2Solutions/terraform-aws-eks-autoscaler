locals {
  name                    = var.name
  cluster_id              = var.cluster_id
  cluster_version         = var.cluster_version
  oidc_id                 = trimprefix(var.cluster_oidc_issuer_url, "https://")
  deploy_autoscaler       = var.deploy_autoscaler
  autoscaler_tolerations  = var.autoscaler_tolerations
  autoscaler_nodeselector = var.autoscaler_nodeselector
  autoscaler_namespace    = var.autoscaler_namespace
}
