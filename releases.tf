locals {
  autoscaler_release = yamlencode({
    "nameOverride"     = "cluster-autoscaler"
    "fullnameOverride" = "cluster-autoscaler"
    "cloudProvider"    = "aws"
    "awsRegion"        = data.aws_region.current.name
    "tolerations"      = local.autoscaler_tolerations
    "nodeSelector"     = local.autoscaler_nodeselector
    "autoDiscovery" = {
      "clusterName" = local.cluster_id
    }
    "extraArgs" = {
      "expander" = "priority"
    }
    "rbac" = {
      "serviceAccount" = {
        "name" = "cluster-autoscaler"
        "annotations" = {
          "eks.amazonaws.com/role-arn" = aws_iam_role.this.arn
        }
      }
    }
  })
}

resource "helm_release" "cluster-autoscaler" {
  count = local.deploy_autoscaler ? 1 : 0

  name       = "cluster-autoscaler"
  namespace  = local.autoscaler_namespace
  version    = "9.9.2"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  values     = [autoscaler_release]

}
