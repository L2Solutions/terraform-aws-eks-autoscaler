resource "aws_iam_instance_profile" "this" {
  name_prefix = "eks-worker-instance-profile"
  role        = local.worker_iam_role_name
}

data "aws_ssm_parameter" "this" {
  name = local.ami
}

data "aws_ssm_parameter" "this_gpu" {
  name = local.ami_gpu
}

module "this" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "4.4.0"

  for_each = local.groups

  name                        = each.key
  create_asg                  = true
  vpc_zone_identifier         = each.value.subnets
  health_check_type           = "EC2"
  min_size                    = each.value.min_size
  max_size                    = each.value.max_size
  desired_capacity            = each.value.max_size // Set equal to max_size so we don't scale down instances in use
  wait_for_capacity_timeout   = 0
  associate_public_ip_address = true
  iam_instance_profile_name   = aws_iam_instance_profile.this.name
  lc_name                     = "${each.key}-config"
  use_lc                      = true
  create_lc                   = true
  image_id                    = each.value.is_gpu ? data.aws_ssm_parameter.this_gpu.value : data.aws_ssm_parameter.this.value
  instance_type               = each.value.instance_type
  security_groups             = local.security_group_ids
  root_block_device           = local.root_block_device

  user_data_base64 = base64encode(
    <<EOF
    #!/bin/bash
    set -o xtrace
    /etc/eks/bootstrap.sh ${local.cluster_id} \
    --kubelet-extra-args \
    '--node-labels=eks.amazonaws.com/nodegroup-image=${data.aws_ssm_parameter.this.value},${each.value.node_labels} --register-with-taints=${each.value.taints}'
    EOF
  )

  tags = concat(each.value.tags, each.value.is_gpu ? local.gpu_tag : [])

}
