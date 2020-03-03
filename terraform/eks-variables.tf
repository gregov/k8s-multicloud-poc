#
# Variables Configuration
#

variable "eks_cluster_name" {
  default = "k8s-multicloud-poc-aws"
  type    = string
}

variable "eks_region" {
  default = "sa-east-1"
  type    = string
}