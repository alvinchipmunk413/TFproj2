

# Create virtual network
/* resource "azurerm_virtual_network" "my_terraform_network_v3" {
  name                = "${var.vnetprefix}-centralindia-alvin"
  address_space       = ["192.168.0.0/16"]
  location            = var.location2
  resource_group_name = azurerm_resource_group.rg.name
  depends_on = [ azurerm_resource_group.rg ]
}
 */
# Create subnet
resource "azurerm_subnet" "my_terraform_subnet_v3" {
  name                 = "${var.subnetprefix}2-centralindia-alvin"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.my_terraform_network_v2.name
  address_prefixes     = ["192.168.2.0/24"]
  # depends_on = [ azurerm_virtual_network.my_terraform_network ]
}

# Create public IPs
resource "azurerm_public_ip" "my_terraform_public_ip_v3" {
  name                = "alvin-public-ip_v3"
  location            = var.location2
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Create Network Security Group and rules
/* resource "azurerm_network_security_group" "my_terraform_nsg_v3" {
  name                = "alvin-nsg_v3"
  location            = var.location2
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "web"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
} */


# Create network interface
resource "azurerm_network_interface" "my_terraform_nic_v3" {
  name                = "${var.prefix}-nic_v3"
  location            = var.location2
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "my_nic_configuration"
    subnet_id                     = azurerm_subnet.my_terraform_subnet_v3.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip_v3.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example_v3" {
  network_interface_id      = azurerm_network_interface.my_terraform_nic_v3.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg_v2.id
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "my_storage_account_v3" {
  name                     = "diagstg413v3"
  location                 = var.location2
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


# Create virtual machine
resource "azurerm_windows_virtual_machine" "main_v3" {
  name                  = "${var.vmprefix}1-centralindia-alvin"
  admin_username        = "azureuser"
  admin_password        = "Password1234!"
  location              = var.location2
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.my_terraform_nic_v3.id]
  size                  = "Standard_D2S_v3"
  computer_name = "Pedro"
  os_disk {
    name                 = "myOsDisk_v3"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }


  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.my_storage_account_v3.primary_blob_endpoint
  }
}

# # Install IIS web server to the virtual machine
# resource "azurerm_virtual_machine_extension" "web_server_install" {
#   name                       = "${random_pet.prefix.id}-wsi"
#   virtual_machine_id         = azurerm_windows_virtual_machine.main.id
#   publisher                  = "Microsoft.Compute"
#   type                       = "CustomScriptExtension"
#   type_handler_version       = "1.8"
#   auto_upgrade_minor_version = true

#   settings = <<SETTINGS
#     {
#       "commandToExecute": "powershell -ExecutionPolicy Unrestricted Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools"
#     }
#   SETTINGS
# }

# # Generate random text for a unique storage account name
# resource "random_id" "random_id" {
#   keepers = {
#     # Generate a new ID only when a new resource group is defined
#     resource_group = azurerm_resource_group.rg.name
#   }

#   byte_length = 8
# }

# resource "random_password" "password" {
#   length      = 20
#   min_lower   = 1
#   min_upper   = 1
#   min_numeric = 1
#   min_special = 1
#   special     = true
# }

# resource "random_pet" "prefix" {
#   prefix = var.prefix
#   length = 1
# } 


resource "azurerm_virtual_network_peering" "example-1" {
  name                      = "peer1to2"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.my_terraform_network_v2.name
  remote_virtual_network_id = azurerm_virtual_network.my_terraform_network.id
}

resource "azurerm_virtual_network_peering" "example-2" {
  name                      = "peer2to1"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.my_terraform_network.name
  remote_virtual_network_id = azurerm_virtual_network.my_terraform_network_v2.id
}