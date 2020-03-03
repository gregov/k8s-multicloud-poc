variable "client_id" {
}

variable "client_secret" {
}

variable "agent_count" {
    default = 3
}

variable "ssh_public_key" {
    default = "~/.ssh/id_rsa.pub"
}

variable "dns_prefix" {
    default = "k8s-multicloud-poc"
}

variable aks_cluster_name {
    default = "k8s-multicloud-poc-azure"
}

variable resource_group_name {
    default = "azure-k8s-multicloud-poc"
}

variable aks_location {
    default = "Canada Central"
}
