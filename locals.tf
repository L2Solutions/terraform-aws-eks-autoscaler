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
  deploy_nvidia_plugin    = var.deploy_nvidia_plugin
  nvidia_version          = var.nvidia_version
  min_size                = var.min_size
  max_size                = var.max_size
  instance_type           = var.instance_type
  root_block_device       = var.root_block_device
  security_group_ids      = var.security_group_ids
  ami_gpu                 = "/aws/service/eks/optimized-ami/${local.cluster_version}/amazon-linux-2-gpu/recommended/image_id"
  ami                     = "/aws/service/eks/optimized-ami/${local.cluster_version}/amazon-linux-2/recommended/image_id"
  gpu_tag = [{
    key                 = "k8s.io/cluster-autoscaler/node-template/gpu-enabled"
    value               = "true"
    propagate_at_launch = true
  }]



  default_tags = {
    "kubernetes.io/cluster/${local.cluster_id}" = {
      value               = "owned"
      propagate_at_launch = true
    }
    "eks:cluster-name" = {
      value               = local.cluster_id
      propagate_at_launch = true
    }
    "k8s.io/cluster-autoscaler/enabled" = {
      value               = "true"
      propagate_at_launch = true
    }
    "k8s.io/cluster-autoscaler/${local.cluster_id}" = {
      value               = "owned"
      propagate_at_launch = true
    }
  }

  tags = merge(default_tags, var.tags)

  gpu_instances = [
    "p2.xlarge", "p2.8xlarge", "p2.16xlarge",
    "p3.2xlarge", "p3.8xlarge", "p3.16xlarge", "p3dn.24xlarge",
    "p4dn.24xlarge",
    "g4dn.xlarge", "g4dn.2xlarge", "g4dn.4xlarge", "g4dn.8xlarge",
    "g4dn.16xlarge", "g4dn.12xlarge", "g4dn.metal",
    "g3s.xlarge", "g3s.4xlarge", "g3s.8xlarge", "g3s.16xlarge",
  ]

  groups = { for value in var.groups : value.name => {
    subnets       = toset(lookup(value, "subnets", var.subnets))
    node_labels   = join(",", [for key, val in merge(var.node_labels, value.node_labels) : "${key}=${val}"])
    instance_type = lookup(value, "instance_type", var.instance_type)
    is_gpu        = contains(local.gpu_instances, lookup(value, "instance_type", var.instance_type))
    min_size      = lookup(value, "min_size", var.min_size)
    max_size      = lookup(value, "max_size", var.max_size)

    tags = [for key, value in merge(local.tags, lookup(value, "tags", {})) : {
      "key"                 = key
      "value"               = value.value
      "propagate_at_launch" = lookup(value, "propagate_at_launch", true)
    }]
  } }



}
