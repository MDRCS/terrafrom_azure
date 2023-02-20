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
  default = "default"
}

locals {
  org      = "tcm_labs"
  location = "westeurope"
  fw_name   = "${local.org}-azfw"
  fw_policy = "${local.org}-fw-policy"
}