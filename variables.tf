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

variable "nvda_version" {
  type        = string
  description = "Chart version of nvidia plugin helm release"
  default     = "0.9.0"
}

variable "gpu_ami" {
  type        = string
  description = "GPU ami to use, defaults to eks optmized based on `cluster_version`"
  default     = null
}

variable "min_size" {
  type        = number
  description = "Min ASG size"
  default     = 0
}

variable "max_size" {
  type        = number
  description = "Max ASG size"
  default     = 5
}

variable "instance_type" {
  description = "Instance type for gpu ASG"
  type        = string
  default     = "p2.xlarge"
}

variable "root_block_device" {
  description = "Pass through to ASG module"
  type        = list(map(string))
  default = [{
    volume_size = "100"
    volume_type = "gp2"
  }]
}

variable "groups" {
  description = "Overrides per group"
  type = list(object({
    name          = string
    subnets       = optional(list(string))
    node_labels   = optional(map(string))
    instance_type = optional(string)
  }))
  default = []
}

variable "worker_iam_role_name" {
  type        = string
  description = "EKS worker iam role name"
  default     = null
}

variable "security_group_ids" {
  description = "List of security group ids"
  type        = list(string)
  default     = []
}

variable "subnets" {
  description = "List of subnet ids"
  type        = list(string)
}
