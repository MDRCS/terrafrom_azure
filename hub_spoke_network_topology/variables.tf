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
  org       = "tcm_labs"
  location  = "westeurope"
  fw_name   = "${local.org}-azfw"
  fw_policy = "${local.org}-fw-policy"
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