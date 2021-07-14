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

  tags = merge(local.default_tags, var.tags)

  gpu_instances = [
    "p2.xlarge", "p2.8xlarge", "p2.16xlarge",
    "p3.2xlarge", "p3.8xlarge", "p3.16xlarge", "p3dn.24xlarge",
    "p4dn.24xlarge",
    "g4dn.xlarge", "g4dn.2xlarge", "g4dn.4xlarge", "g4dn.8xlarge",
    "g4dn.16xlarge", "g4dn.12xlarge", "g4dn.metal",
    "g3s.xlarge", "g3s.4xlarge", "g3s.8xlarge", "g3s.16xlarge",
  ]

  groups = { for value in var.groups : value.name => {
    subnets        = toset(value.subnets != null ? value.subnets : var.subnets)
    node_labels    = join(",", [for key, val in merge(var.node_labels, value.node_labels) : "${key}=${val}"])
    instance_type  = value.instance_type != null ? value.instance_type : var.instance_type
    is_gpu         = contains(local.gpu_instances, value.instance_type != null ? value.instance_type : var.instance_type)
    min_size       = value.min_size != null ? value.min_size : local.min_size
    max_size       = value.max_size != null ? value.max_size : local.max_size
    taints         = join(",", [for key, val in merge(var.taints, value.taints) : "${key}=${val.value}:${val.effect}"])
    registertaints = merge(var.taints, value.taints) != null ? "--register-with-taints" : ""

    // Need to merge node labels and taints as tags so CA can see them on the ASG config
    tags = concat(
      [for key, value in merge(local.tags, value.tags != null ? value.tags : {}) : {
        "key"                 = key
        "value"               = value.value
        "propagate_at_launch" = value.propagate_at_launch != null ? value.propagate_at_launch : true
      }],
      [for key, val in merge(var.node_labels, value.node_labels) : {
        "key"                 = "k8s.io/cluster-autoscaler/node-template/label/${key}"
        "value"               = val
        "propagate_at_launch" = true
      }],
      [for key, val in merge(var.taints, value.taints) : {
        "key"                 = "k8s.io/cluster-autoscaler/node-template/taint/${key}"
        "value"               = "${val.value}:${val.effect}"
        "propagate_at_launch" = true
      }]
    )
  } }



}
