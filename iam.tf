/*
    Sets up the IAM policies and roles associated with cluster-autoscaler
*/

// Policy Docs

data "aws_iam_policy_document" "this_oidc" {
  // checkov:skip=CKV_AWS_111: Ensure IAM policies does not allow write access without constraints
  statement {
    sid     = "ClusterOIDC"
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_id}"]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_id}:sub"
      values = [
        "sts.amazonaws.com",
        "system:serviceaccount:kube-system:aws-node",
        "system:serviceaccount:kube-system:cluster-autoscaler"
      ]
    }
  }
}

data "aws_iam_policy_document" "this_autoscaler" {
  // checkov:skip=CKV_AWS_111: Ensure IAM policies does not allow write access without constraints
  statement {
    sid    = "ClusterAutoscalerAll"
    effect = "Allow"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "ec2:DescribeLaunchTemplateVersions",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "ClusterAutoscalerOwn"
    effect = "Allow"

    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:UpdateAutoScalingGroup",
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "autoscaling:ResourceTag/kubernetes.io/cluster/${local.cluster_id}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "autoscaling:ResourceTag/k8s.io/cluster-autoscaler/enabled"
      values   = ["true"]
    }
  }
}

// Policies 

resource "aws_iam_policy" "this" {
  name_prefix = "eks_autoscaler"
  path        = "/"
  description = "EKS role for AWS Autoscaler"
  policy      = data.aws_iam_policy_document.this_autoscaler.json
}

// Roles 

resource "aws_iam_role" "this" {
  name_prefix        = "eks_autoscaler"
  assume_role_policy = data.aws_iam_policy_document.this_oidc.json
}

// Attachments

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
