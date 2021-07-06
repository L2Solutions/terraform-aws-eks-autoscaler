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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_this"></a> [this](#module\_this) | terraform-aws-modules/autoscaling/aws | 4.4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [helm_release.cluster-autoscaler](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.nvidia-plugin](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.this_autoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this_oidc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_ssm_parameter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

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
| <a name="input_deploy_autoscaler"></a> [deploy\_autoscaler](#input\_deploy\_autoscaler) | Deploys cluster-autoscaler as a helm-release | `bool` | `true` | no |
| <a name="input_gpu_ami"></a> [gpu\_ami](#input\_gpu\_ami) | GPU ami to use, defaults to eks optmized based on `cluster_version` | `string` | `null` | no |
| <a name="input_groups"></a> [groups](#input\_groups) | Overrides per group | <pre>list(object({<br>    name          = string<br>    subnets       = optional(list(string))<br>    node_labels   = optional(map(string))<br>    instance_type = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type for gpu ASG | `string` | `"p2.xlarge"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Max ASG size | `number` | `5` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Min ASG size | `number` | `0` | no |
| <a name="input_name"></a> [name](#input\_name) | Unique name, used in ASG resources | `string` | n/a | yes |
| <a name="input_node_labels"></a> [node\_labels](#input\_node\_labels) | Global node labels | `map(string)` | `{}` | no |
| <a name="input_nvidia_version"></a> [nvidia\_version](#input\_nvidia\_version) | Chart version of nvidia plugin helm release | `string` | `"0.9.0"` | no |
| <a name="input_root_block_device"></a> [root\_block\_device](#input\_root\_block\_device) | Pass through to ASG module | `list(map(string))` | <pre>[<br>  {<br>    "volume_size": "100",<br>    "volume_type": "gp2"<br>  }<br>]</pre> | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group ids | `list(string)` | `[]` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of subnet ids | `list(string)` | `[]` | no |
| <a name="input_worker_iam_role_name"></a> [worker\_iam\_role\_name](#input\_worker\_iam\_role\_name) | EKS worker iam role name | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | ARN of IAM eks autoscaler role |
