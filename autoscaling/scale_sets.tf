resource "azurerm_virtual_machine_scale_set" "demo" {
  name     = "scaleset-${var.prefix}-1"
  location = var.location

  resource_group_name = azurerm_resource_group.scalesets-loadbalancer-demo.name
  # automatic rolling upgarde
  automatic_os_upgrade = true
  upgrade_policy_mode  = "Rolling"

  rolling_upgrade_policy {
    max_batch_instance_percent              = 20
    max_unhealthy_instance_percent          = 20
    max_unhealthy_upgraded_instance_percent = 5
    pause_time_between_batches              = "PT05"
  }

  # required when using rolling upgrade policy 
  health_probe_id = azurerm_lb_probe.demo.id

  zones = var.zones

  sku {
    name     = "Standard_A1_v2"
    tier     = "Standard"
    capacity = 2
  }

  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_profile_os_disk {
    name              = "mydisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_profile_data_disk {
    lun           = 0
    caching       = "ReadWrite"
    create_option = "FromImage"
    disk_size_gb  = 10
  }

  os_profile {
    computer_name_prefix = "demo"
    admin_password       = "demo"
    custom_data          = local.custom_data
    #   custom_data = <<-CUSTOM_DATA
    #   #!/bin/bash
    #   apt-get update &&
    #   apt-get install -y nginx &&
    #   systemctl enable nginx &&
    #   systemctl start nginx
    # CUSTOM_DATA 
  }


  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("~/.ssh/authorized_keys/key.pub")
      path     = "/home/demo/.ssh/authorized_keys" # default path allowed to store public keys for UbuntuServer OS 
    }
  }

  network_profile {
    name                      = "networkprofile"
    primary                   = true
    network_security_group_id = azurerm_network_security_group.demo-instance.id

    ip_configuration {
      name                                   = "IPConfiguration"
      primary                                = true
      subnet_id                              = azurerm_subnet.demo-subnet-1.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpepool.id]
      load_balancer_inbound_nat_rules_ids    = [azurerm_lb_nat_pool.lbnatpool.id]
    }
  }

}