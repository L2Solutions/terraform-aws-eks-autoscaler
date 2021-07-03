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
  deploy_nvda_plugin      = var.deploy_nvda_plugin || var.create_gpu_asg
  nvda_version            = var.nvda_version
  min_size                = var.min_size
  max_size                = var.max_size
  gpu_ami                 = var.gpu_ami
  instance_type           = var.instance_type
  root_block_device       = var.root_block_device
  security_group_ids      = var.security_group_ids

  data_per_az = var.create_gpu_asg ? { for value in var.data_per_az : value.name => {
    vpc_zone_identifier_ids = toset(value.vpc_zones_ids)
    node_labels             = value.node_labels
  } } : {}


}
