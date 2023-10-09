# resource "azurerm_resource_group" "rg" {
#   location = var.location
#   name     = var.prefix
# }

# # Create virtual network
# resource "azurerm_virtual_network" "my_terraform_network" {
#   name                = "${var.vnetprefix}-koreacentral-alvin"
#   address_space       = ["172.16.0.0/16"]
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
# }

# # Create subnet
# resource "azurerm_subnet" "my_terraform_subnet" {
#   name                 = "${var.subnetprefix}1-koreacentral-alvin"
#   resource_group_name  = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.my_terraform_network.name
#   address_prefixes     = ["172.16.0.0/24"]
# }

# # Create public IPs
# resource "azurerm_public_ip" "my_terraform_public_ip" {
#   name                = "alvin-public-ip"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   allocation_method   = "Dynamic"
# }

# # Create Network Security Group and rules
# resource "azurerm_network_security_group" "my_terraform_nsg" {
#   name                = "alvin-nsg"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name

#   security_rule {
#     name                       = "RDP"
#     priority                   = 1000
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "*"
#     source_port_range          = "*"
#     destination_port_range     = "3389"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
#   security_rule {
#     name                       = "web"
#     priority                   = 1001
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "80"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
# }

# # Create network interface
# resource "azurerm_network_interface" "my_terraform_nic" {
#   name                = "${var.prefix}-nic"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name

#   ip_configuration {
#     name                          = "my_nic_configuration"
#     subnet_id                     = azurerm_subnet.my_terraform_subnet.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id
#   }
# }

# # Connect the security group to the network interface
# resource "azurerm_network_interface_security_group_association" "example" {
#   network_interface_id      = azurerm_network_interface.my_terraform_nic.id
#   network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
# }

# # Create storage account for boot diagnostics
# resource "azurerm_storage_account" "my_storage_account" {
#   name                     = "diagstg413"
#   location                 = azurerm_resource_group.rg.location
#   resource_group_name      = azurerm_resource_group.rg.name
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
# }


# resource "azurerm_virtual_machine" "main" {
#   name                  = "${var.vmprefix}1-koreacentral-alvin"
#   location              = azurerm_resource_group.rg.location
#   resource_group_name   = azurerm_resource_group.rg.name
#   network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]
#   vm_size               = "Standard_D2S_v3"

#   # Uncomment this line to delete the OS disk automatically when deleting the VM
#   # delete_os_disk_on_termination = true

#   # Uncomment this line to delete the data disks automatically when deleting the VM
#   # delete_data_disks_on_termination = true

#   storage_image_reference {
#     publisher = "MicrosoftWindowsServer"
#     offer     = "WindowsServer"
#     sku       = "2022-datacenter-azure-edition"
#     version   = "latest"
#   }
#   storage_os_disk {
#     name              = "myosdisk1"
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     managed_disk_type = "Standard_LRS"
#   }
#   os_profile {
#     computer_name  = "hostname"
#     admin_username = "testadmin"
#     admin_password = "Password1234!"
#   }

#   tags = {
#     environment = "staging"
#   }

  
# }

# # # Install IIS web server to the virtual machine
# # resource "azurerm_virtual_machine_extension" "web_server_install" {
# #   name                       = "${random_pet.prefix.id}-wsi"
# #   virtual_machine_id         = azurerm_windows_virtual_machine.main.id
# #   publisher                  = "Microsoft.Compute"
# #   type                       = "CustomScriptExtension"
# #   type_handler_version       = "1.8"
# #   auto_upgrade_minor_version = true

# #   settings = <<SETTINGS
# #     {
# #       "commandToExecute": "powershell -ExecutionPolicy Unrestricted Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools"
# #     }
# #   SETTINGS
# # }

# # # Generate random text for a unique storage account name
# # resource "random_id" "random_id" {
# #   keepers = {
# #     # Generate a new ID only when a new resource group is defined
# #     resource_group = azurerm_resource_group.rg.name
# #   }

# #   byte_length = 8
# # }

# # resource "random_password" "password" {
# #   length      = 20
# #   min_lower   = 1
# #   min_upper   = 1
# #   min_numeric = 1
# #   min_special = 1
# #   special     = true
# # }

# # resource "random_pet" "prefix" {
# #   prefix = var.prefix
# #   length = 1
# # }