locals {
  name                    = var.name
  cluster_id              = var.cluster_id
  cluster_version         = var.cluster_version
  oidc_id                 = trimprefix(var.cluster_oidc_issuer_url, "https://")
  deploy_autoscaler       = var.deploy_autoscaler
  worker_iam_role_name    = var.worker_iam_role_name
  ca_version              = var.ca_version
  autoscaler_tolerations  = var.autoscaler_tolerations
  autoscaler_nodeselector = var.autoscaler_nodeselector
  autoscaler_namespace    = var.autoscaler_namespace
  deploy_nvidia_plugin    = count(var.groups) > 0
  nvidia_version          = var.nvidia_version
  min_size                = var.min_size
  max_size                = var.max_size
  instance_type           = var.instance_type
  root_block_device       = var.root_block_device
  security_group_ids      = var.security_group_ids

  groups = { for value in var.groups : value.name => {
    subnets       = value.subnets != null ? toset(value.subnets) : toset(var.subnets)
    node_labels   = join(",", [for key, val in merge(var.node_labels, value.node_labels) : "${key}=${val}"])
    instance_type = value.instance_type != null ? value.instance_type : var.instance_type
  } }


}
