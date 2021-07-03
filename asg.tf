resource "aws_iam_instance_profile" "this" {
  name_prefix = "eks-worker-instance-profile"
  role        = local.worker_iam_role_name
}

locals {
  default_gpu_ami = "/aws/service/eks/optimized-ami/${local.cluster_version}/amazon-linux-2-gpu/recommended/image_id"
  gpu_ami         = var.gpu_ami != null ? var.gpu_ami : local.default_gpu_ami
}

data "aws_ssm_parameter" "this" {
  name = local.gpu_ami
}

module "this" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "4.4.0"

  for_each = local.data_per_az

  name                        = each.key
  create_asg                  = true
  vpc_zone_identifier         = each.value.vpc_zone_identifier_ids
  health_check_type           = "EC2"
  min_size                    = 0
  max_size                    = local.max_size
  desired_capacity            = local.max_size // Set equal to max_size so we don't scale down instances in use
  wait_for_capacity_timeout   = local.min_size
  associate_public_ip_address = true
  iam_instance_profile_name   = aws_iam_instance_profile.this.name
  lc_name                     = "${local.name}-config"
  image_id                    = data.aws_ssm_parameter.this.value
  instance_type               = local.instance_type
  security_groups             = local.security_group_ids
  root_block_device           = local.root_block_device

  user_data_base64 = base64encode(
    <<EOF
    #!/bin/bash
    set -o xtrace
    /etc/eks/bootstrap.sh ${local.cluster_id} \
    --kubelet-extra-args \
    '--node-labels=eks.amazonaws.com/nodegroup-image=,${data.aws_ssm_parameter.this.value},${join(",", [for key, value in each.value.node_labels : "${key}=${value}"])}'
    EOF
  )

  tags = [
    {
      key                 = "k8s.io/cluster-autoscaler/node-template/gpu-enabled"
      value               = "true"
      propagate_at_launch = true
    },
    {
      key                 = "kubernetes.io/cluster/${local.cluster_id}"
      value               = "owned"
      propagate_at_launch = true
    },
    {
      key                 = "eks:cluster-name"
      value               = local.cluster_id
      propagate_at_launch = true
    },
    {
      key                 = "k8s.io/cluster-autoscaler/enabled"
      value               = "TRUE"
      propagate_at_launch = true
    },
    {
      key                 = "k8s.io/cluster-autoscaler/${local.cluster_id}"
      value               = "owned"
      propagate_at_launch = true
    }
  ]
}
