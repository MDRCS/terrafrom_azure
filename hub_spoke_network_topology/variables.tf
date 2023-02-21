variable "subnet_hub_addresses" {
  type = list(string)
  default = ["10.0.4.0/24"]
}

variable "subnet_spoke_a_addresses" {
  type = list(string)
  default = ["10.1.1.0/24"]
}

variable "subnet_spoke_b_addresses" {
  type = list(string)
  default = ["10.2.1.0/24"]
}

variable "subscription_id" {
  type    = string
  default = "default"
}
variable "client_id" {
  type    = string
  default = "default"
}
variable "client_secret" {
  type    = string
  default = "default"
}
variable "tenant_id" {
  type    = string
  default = "2c6c2e08-0cde-4449-b611-14d951d5dbc9"
}

locals {
  org       = "tcm-labs"
  location  = "westeurope"
  fw_name   = "tcm-labs-azfw"
  fw_policy = "tcm-labs-fw-policy"
}

# la = [
#   {
#     "cloudName": "AzureCloud",
#     "homeTenantId": "2c6c2e08-0cde-4449-b611-14d951d5dbc9",
#     "id": "b41c9ffc-cf8c-4276-8758-def8f2efc8d9",
#     "isDefault": true,
#     "managedByTenants": [],
#     "name": "Azure subscription 1",
#     "state": "Enabled",
#     "tenantId": "2c6c2e08-0cde-4449-b611-14d951d5dbc9",
#     "user": {
#       "name": "azurecloud010@gmail.com",
#       "type": "user"
#     }
#   }
# ]