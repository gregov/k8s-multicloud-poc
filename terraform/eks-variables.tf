#
# Variables Configuration
#

variable "eks_cluster_name" {
  default = "arctiq-ext-mission-aws"
  type    = string
}

variable "eks_region" {
  default = "sa-east-1"
  type    = string
}