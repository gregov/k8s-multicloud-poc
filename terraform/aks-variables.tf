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
    default = "arctiq-ext-mission"
}

variable aks_cluster_name {
    default = "arctiq-ext-mission-azure"
}

variable resource_group_name {
    default = "azure-arctiq-ext-mission"
}

variable aks_location {
    default = "Canada Central"
}
