# Terraform AWS EKS Autoscaler Module

Configures IAM roles that allows a Kubernetes cluster autoscaler helm release to correctly autoscale an EKS cluster. Added support for Nvidia Daemonset Plugin. All ASG created will use latest AMIs based on cluster version. GPU enabled AMIs are auto detected when GPU enabled instance types are chosen.

- [Registry](https://registry.terraform.io/modules/OmniTeqSource/eks-autoscaler/aws/latest)

### Charts

- [cluster-autoscaler](https://kubernetes.github.io/autoscaler)
- [nvidia-plugin](https://nvidia.github.io/k8s-device-plugin)

<!-- BEGIN_TF_DOCS -->

{{ .Content }}

<!-- END_TF_DOCS -->
