variable "client_id" {
  default = "<from secrets/azure_variables.tfvars>"
}

variable "client_secret" {
  default = "<from secrets/azure_variables.tfvars>"
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

variable cluster_name {
    default = "arctiq-ext-mission-azure"
}

variable resource_group_name {
    default = "azure-arctiq-ext-mission"
}

variable location {
    default = "Canada Central"
}

variable log_analytics_workspace_name {
    default = "testLogAnalyticsWorkspaceName"
}

# refer https://azure.microsoft.com/global-infrastructure/services/?products=monitor for log analytics available regions
variable log_analytics_workspace_location {
    default = "canadacentral"
}

# refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing 
variable log_analytics_workspace_sku {
    default = "PerGB2018"
}