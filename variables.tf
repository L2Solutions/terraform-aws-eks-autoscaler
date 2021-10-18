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
  default     = "9.10.4"
}

variable "ca_image_tag" {
  type        = string
  description = "Cluster-autoscaler helm image tag. This is versioned differently than the image. Make sure to align this tag with your k8s version."
  default     = "v1.21.1"
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

variable "nvidia_version" {
  type        = string
  description = "Chart version of nvidia plugin helm release"
  default     = "0.9.0"
}

variable "min_size" {
  type        = number
  description = "Min ASG size"
  default     = 0
}

variable "max_size" {
  type        = number
  description = "Max ASG size"
  default     = 1
}

variable "instance_type" {
  description = "Instance type for ASG"
  type        = string
  default     = "t2.small"
}

variable "root_block_device" {
  description = "Pass through to ASG module"
  type        = list(map(string))
  default = [{
    volume_size = "100"
    volume_type = "gp2"
  }]
}

variable "node_labels" {
  type        = map(string)
  description = "Global node labels for ASG"
  default     = {}
}

variable "groups" {
  description = "Overrides to global ASG per group. Will detect GPU instance from built in list."
  type = list(object({
    name          = string
    subnets       = optional(list(string))
    node_labels   = optional(map(string))
    instance_type = optional(string)
    min_size      = optional(number)
    max_size      = optional(number)

    taints = optional(map(object({
      value  = string
      effect = string
    })))

    tags = optional(map(object({
      value               = string
      propagate_at_launch = optional(bool)
    })))
  }))
  default = []
}

variable "taints" {
  type = map(object({
    value  = string
    effect = string
  }))
  default     = null
  description = "Taints to apply globally to all ASGs."
}

variable "tags" {
  type = map(object({
    value               = string
    propagate_at_launch = optional(bool)
  }))
  default     = {}
  description = "Global tags to apply to each ASG. `propagate_at_launch` defaults to true"
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
  default     = []
}

variable "deploy_nvidia_plugin" {
  description = "Flag to deploy nvidia daemonset"
  default     = false
  type        = bool
}

variable "gpu_node_labels" {
  default     = {}
  type        = map(string)
  description = "Node labels for Nvidia Daemon helm chart."
}

variable "args" {
  default     = {}
  description = "Extra args for cluster autoscaler"
  type        = map(any)
}
