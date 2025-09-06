data "azurerm_key_vault" "keyvault" {
  name                = "tijori"
  resource_group_name = "bappa-remotestate-rg"
}

data "azurerm_key_vault_secret" "kv-username" {
  name         = "tijoriname"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

data "azurerm_key_vault_secret" "kv-password" {
  name         = "tijoripassword"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

data "azurerm_subnet" "subdata" {
    depends_on = [ module.subnet ]
  name                 = "missionjob_subnet"
  virtual_network_name = "missionjob_vnet"
  resource_group_name  = var.resource_group_name
}

data "azurerm_subnet" "bastion_subdata" {
    depends_on = [ module.bastion_subnet ]
  name                 = "AzureBastionSubnet"
  virtual_network_name = "missionjob_vnet"
  resource_group_name  = var.resource_group_name
}

data "azurerm_public_ip" "pipdata" {
    depends_on = [ module.public_ip ]
  name                = "missionjob_public_ip"
  resource_group_name = var.resource_group_name
}