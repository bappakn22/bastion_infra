module "rg" {
  source              = "../../modules/01_azurerm_resource_group"
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "vnet" {
  depends_on          = [module.rg]
  source              = "../../modules/02_azurerm_vnet"
  vnet_name           = "missionjob_vnet"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = ["10.0.0.0/16"]
}

module "subnet" {
  depends_on          = [module.vnet]
  source              = "../../modules/03_azurerm_subnet"
  subnet_name         = "missionjob_subnet"
  resource_group_name = var.resource_group_name
  vnet_name           = "missionjob_vnet"
  address_prefixes    = ["10.0.1.0/24"]
}

module "bastion_subnet" {
  depends_on          = [module.vnet]
  source              = "../../modules/03_azurerm_subnet"
  subnet_name         = "AzureBastionSubnet"
  resource_group_name = var.resource_group_name
  vnet_name           = "missionjob_vnet"
  address_prefixes    = ["10.0.2.0/24"]
}

module "public_ip" {
  depends_on          = [module.rg]
  source              = "../../modules/04_azurerm_public_ip"
  public_ip_name      = "missionjob_public_ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

module "bastion" {
  depends_on            = [module.bastion_subnet, module.public_ip]
  source                = "../../modules/05_azurerm_bastion"
  bastion_name          = "missionjob_bastion"
  resource_group_name   = var.resource_group_name
  location              = var.location
  ip_configuration_name = "bastion_ip_config"
  subnet_id             = data.azurerm_subnet.bastion_subdata.id
  public_ip_address_id  = data.azurerm_public_ip.pipdata.id
}

module "frontend_vm1" {
  depends_on          = [module.rg, ]
  source              = "../../modules/06_virtual_machine"
  vm_name             = "missionjob_vm"
  resource_group_name = var.resource_group_name
  location            = var.location
  admin_username      = data.azurerm_key_vault_secret.kv-username.value
  admin_password      = data.azurerm_key_vault_secret.kv-password.value
  nic_name            = "missionjob_nic"
  subnet_id           = data.azurerm_subnet.subdata.id
  nsg_name            = "missionjob_nsg"
}

module "frontend_vm2" {
  depends_on          = [module.rg, module.subnet]
  source              = "../../modules/06_virtual_machine"
  vm_name             = "missionjob_vm"
  resource_group_name = var.resource_group_name
  location            = var.location
  admin_username      = data.azurerm_key_vault_secret.kv-username.value
  admin_password      = data.azurerm_key_vault_secret.kv-password.value
  nic_name            = "missionjob_nic"
  subnet_id           = data.azurerm_subnet.subdata.id
  nsg_name            = "missionjob_nsg"
}

module "nsg" {
  depends_on          = [module.rg, module.subnet]
  source              = "../../modules/08_azurerm_nsg"
  nsg_name            = "missionjob_nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.subdata.id
}

module "sql" {
  depends_on          = [module.rg]
  source              = "../../modules/07_sql_server"
  sql_server_name     = "miss-sqlserver"
  resource_group_name = var.resource_group_name
  location            = var.location
  sql_admin_username  = data.azurerm_key_vault_secret.kv-username.value
  sql_admin_password  = data.azurerm_key_vault_secret.kv-password.value
  sql_database_name   = "missionjob_db"
}
