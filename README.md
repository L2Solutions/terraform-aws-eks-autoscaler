Deploys configures IAM roles that allow a kubernetes cluster autoscaler helm release to correctly autoscale a EKS cluster. Added support for Nvidia Daemonset Plugin

- [Registry](https://registry.terraform.io/modules/L2Solutions/eks-autoscaler/aws/latest)

### Charts

- [cluster-autoscaler](https://kubernetes.github.io/autoscaler)
- [nvidia-plugin](https://nvidia.github.io/k8s-device-plugin)

## terraform-docs usage

`sed -i '/^<!--- start terraform-docs --->/q' README.md && terraform-docs md . >> README.md`

<!--- start terraform-docs --->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [helm_release.cluster-autoscaler](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.nvidia-plugin](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.this_autoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this_oidc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_autoscaler_namespace"></a> [autoscaler\_namespace](#input\_autoscaler\_namespace) | Namespace of cluster autoscaler helm release | `string` | `"kube-system"` | no |
| <a name="input_autoscaler_nodeselector"></a> [autoscaler\_nodeselector](#input\_autoscaler\_nodeselector) | Node selector on cluster autoscaler helm release | `map(string)` | `{}` | no |
| <a name="input_autoscaler_tolerations"></a> [autoscaler\_tolerations](#input\_autoscaler\_tolerations) | Tolerations on cluster autoscaler helm release | <pre>list(object({<br>    key    = string<br>    value  = string<br>    effect = string<br>  }))</pre> | `[]` | no |
| <a name="input_ca_version"></a> [ca\_version](#input\_ca\_version) | Cluster-autoscaler helm release version | `string` | `"9.9.2"` | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | EKS cluster id | `string` | n/a | yes |
| <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url) | The url generated when OIDC is configured with EKS. | `string` | n/a | yes |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Kubernetes version | `string` | n/a | yes |
| <a name="input_create_gpu_asg"></a> [create\_gpu\_asg](#input\_create\_gpu\_asg) | Creates gpu autoscaling groups | `bool` | `false` | no |
| <a name="input_deploy_autoscaler"></a> [deploy\_autoscaler](#input\_deploy\_autoscaler) | Deploys cluster-autoscaler as a helm-release | `bool` | `true` | no |
| <a name="input_deploy_nvda_plugin"></a> [deploy\_nvda\_plugin](#input\_deploy\_nvda\_plugin) | Deploys nvidia plugin to enable gpu nodes | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Unique name, used in ASG resources | `string` | n/a | yes |
| <a name="input_nvda_version"></a> [nvda\_version](#input\_nvda\_version) | Chart version of nvidia plugin helm release | `string` | `"0.9.0"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | ARN of IAM eks autoscaler role |
