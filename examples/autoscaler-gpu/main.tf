// Example config, no gaurantee to run without complete resource configuration

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

module "mycluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.1.0"

  cluster_name     = "mycluster"
  cluster_version  = "1.20"
  write_kubeconfig = false
  enable_irsa      = true

  taints = [{
    "key"    = "zone"
    "value"  = "true"
    "effect" = "NoSchedule"
  }]
}

data "aws_subnet" "east2a" {}
data "aws_subnet" "east2b" {}

module "autoscaler" {
  source = "../.."

  name                    = "cluster-autoscaler"
  cluster_id              = module.mycluster.cluster_id
  cluster_oidc_issuer_url = module.mycluster.cluster_oidc_issuer_url
  cluster_version         = "1.20"
  autoscaler_tolerations = [{
    "key"    = "zone"
    "value"  = "true"
    "effect" = "NoSchedule"
  }]

  //GPU ASG args
  create_gpu_asg       = true
  max_size             = 10
  worker_iam_role_name = module.mycluster.worker_iam_role_name
  security_group_ids = [
    module.mycluster.cluster_security_group_id,
    module.mycluster.cluster_primary_security_group_id,
  ]

  data_per_az = [
    {
      name         = "east2a"
      vpc_zone_ids = [data.aws_subnet.east2a.id]
      node_labels  = [{ "k8szone" = "east2a" }]
    },
    {
      name         = "east2b"
      vpc_zone_ids = [data.aws_subnet.east2b.id]
      node_labels  = [{ "k8szone" = "east2b" }]
    }
  ]

}
