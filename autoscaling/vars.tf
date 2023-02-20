variable "location" {
  type    = string
  default = "westeurope"
}

variable "prefix" {
  type    = string
  default = "demo"
}


variable "ssh-source-address" {
  type    = string
  default = "*" # * : means everypne could connect to your instance though ssh.
}

variable "zones" {
  type    = list(string)
  default = []
}