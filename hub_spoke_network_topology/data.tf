data "external" "my_ip" {
  program = ["curl", "ifconfig.co"]
}