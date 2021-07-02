variable "cluster_version" {
  type        = string
  description = "Kubernetes version"
}

variable "cluster_id" {
  type        = string
  description = "EKS cluster id"
}

variable "name" {
  type        = string
  description = "Unique name, used in ASG resources"
}

variable "cluster_oidc_issuer_url" {
  type        = string
  description = "The url generated when OIDC is configured with EKS."
}

variable "deploy_autoscaler" {
  type        = bool
  description = "Deploys cluster-autoscaler as a helm-release"
  default     = true
}

variable "ca_version" {
  type        = string
  description = "Cluster-autoscaler helm release version"
  default     = "9.9.2"
}

variable "autoscaler_tolerations" {
  type = list(object({
    key    = string
    value  = string
    effect = string
  }))
  description = "Tolerations on cluster autoscaler helm release"
  default     = []
}

variable "autoscaler_nodeselector" {
  type        = map(string)
  description = "Node selector on cluster autoscaler helm release"
  default     = {}
}

variable "autoscaler_namespace" {
  type        = string
  description = "Namespace of cluster autoscaler helm release"
  default     = "kube-system"
}

variable "deploy_nvda_plugin" {
  type        = bool
  description = "Deploys nvidia plugin to enable gpu nodes"
  default     = false
}

variable "create_gpu_asg" {
  type        = bool
  description = "Creates gpu autoscaling groups"
  default     = false
}

variable "nvda_version" {
  type        = string
  description = "Chart version of nvidia plugin helm release"
  default     = "0.9.0"
}

