/**
* # authorization
*
* This module manages the azurerm authorization resources.
* For more information see https://registry.terraform.io/providers/azurerm/latest/docs > authorization
*
*/

resource "azurerm_role_assignment" "role_assignment" {
  for_each = var.role_assignment

  name                                   = local.role_assignment[each.key].name
  scope                                  = local.role_assignment[each.key].scope
  role_definition_id                     = local.role_assignment[each.key].role_definition_id
  role_definition_name                   = local.role_assignment[each.key].role_definition_name
  principal_id                           = local.role_assignment[each.key].principal_id
  condition                              = local.role_assignment[each.key].condition
  condition_version                      = local.role_assignment[each.key].condition_version
  delegated_managed_identity_resource_id = local.role_assignment[each.key].delegated_managed_identity_resource_id
  description                            = local.role_assignment[each.key].description
  skip_service_principal_aad_check       = local.role_assignment[each.key].skip_service_principal_aad_check
}

resource "azurerm_user_assigned_identity" "user_assigned_identity" {
  for_each = var.user_assigned_identity

  name                = local.user_assigned_identity[each.key].name == "" ? each.key : local.user_assigned_identity[each.key].name
  location            = local.user_assigned_identity[each.key].location
  resource_group_name = local.user_assigned_identity[each.key].resource_group_name
  tags                = local.user_assigned_identity[each.key].tags
}
