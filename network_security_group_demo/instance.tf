#######################################
#            demo instance 1          #
#######################################
resource "azurerm_virtual_machine" "demo-instance-1" {
    name = "${var.prefix}-vm-1"
    location = var.location
    resource_group_name = azurerm_resource_group.network-security-group-demo.name
    network_interface_ids = [ azurerm_network_interface.demo-instance-1.id]
    vm_size = "Standard_A1_v2"

    # this a demo instance so we can delete all data on termination
    delete_os_disk_on_termination = true
    delete_data_disks_on_termination = true

    storage_image_reference {
        publisher = "Canonical"
        offer = "UbuntuServer"
        sku = "16.04-LTS"
        version = "latest"
    }

    storage_os_disk {
      name = "myosdisk1"
      caching = "ReadWrite"
      create_option = "FromImage"
      managed_disk_type = "Standard_LRS" # Locally redundant storage which replicates teh data three times within one datacenter
      # StandardSSD for ssd disk option
    }

    os_profile {
      computer_name = "demo-instance-1"
      admin_username = "demo"
      admin_password = "..."
    }

    os_profile_linux_config {
      disable_password_authentication = true
      ssh_keys {
        key_data = file("~/.ssh/authorized_keys/key.pub")
        path = "/home/demo/.ssh/authorized_keys" # default path allowed to store public keys for UbuntuServer OS 
      }
    }
}

resource "azurerm_network_interface" "demo-instance-1" {
    name = "${var.prefix}-instance-1"
    location = var.location
    resource_group_name = azurerm_resource_group.network-security-group-demo.name
       
    ip_configuration {
      name = "instance-1"
      subnet_id = azurerm_subnet.demo-internal-1.id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.demo-instance-1.id
    }

}

resource "azurerm_network_interface_security_group_association" "nsg_net_interface_association-1" {
   network_interface_id      = azurerm_network_interface.demo-instance-1.id
   network_security_group_id = azurerm_network_security_group.allow-ssh.id
}

resource "azurerm_public_ip" "demo-instance-1" {
    name = "instance-1-public-ip"
    location = var.location
    resource_group_name = azurerm_resource_group.network-security-group-demo.name
    allocation_method = "Dynamic"
}


# Application Security Groups
resource "azurerm_application_security_group" "demo-instance-group" {
  name = "internet-facing"
  location = var.location
  resource_group_name = azurerm_resource_group.network-security-group-demo.name
}

resource "azurerm_network_interface_application_security_group_association" "demo-instance-group" {
  network_interface_id = azurerm_network_interface.demo-instance-1.id
  application_security_group_id = azurerm_application_security_group.demo-instance-group.id
}


#######################################
#            demo instance 2          #
#######################################

resource "azurerm_virtual_machine" "demo-instance-2" {
    name = "${var.prefix}-vm-2"
    location = var.location
    resource_group_name = azurerm_resource_group.network-security-group-demo.name
    network_interface_ids = [ azurerm_network_interface.demo-instance-2.id]
    vm_size = "Standard_A1_v2"

    # this a demo instance so we can delete all data on termination
    delete_os_disk_on_termination = true
    delete_data_disks_on_termination = true

    storage_image_reference {
        publisher = "Canonical"
        offer = "UbuntuServer"
        sku = "16.04-LTS"
        version = "latest"
    }

    storage_os_disk {
      name = "myosdisk2"
      caching = "ReadWrite"
      create_option = "FromImage"
      managed_disk_type = "Standard_LRS" # Locally redundant storage which replicates teh data three times within one datacenter
      # StandardSSD for ssd disk option
    }

    os_profile {
      computer_name = "demo-instance-2"
      admin_username = "demo"
      admin_password = "..."
    }

    os_profile_linux_config {
      disable_password_authentication = true
      ssh_keys {
        key_data = file("~/.ssh/authorized_keys/key.pub")
        path = "/home/demo/.ssh/authorized_keys" # default path allowed to store public keys for UbuntuServer OS 
      }
    }
}

resource "azurerm_network_interface" "demo-instance-2" {
    name = "${var.prefix}-instance-2"
    location = var.location
    resource_group_name = azurerm_resource_group.network-security-group-demo.name
       
    ip_configuration {
      name = "instance-2"
      subnet_id = azurerm_subnet.demo-internal-1.id # They are in the same subnet
      private_ip_address_allocation = "Dynamic"
      # It have only private IP
      # public_ip_address_id = azurerm_public_ip.demo-instance-2.id
    }

}

resource "azurerm_network_interface_security_group_association" "nsg_net_interface_association-2" {
   network_interface_id      = azurerm_network_interface.demo-instance-2.id
   network_security_group_id = azurerm_network_security_group.internet-facing.id
}


