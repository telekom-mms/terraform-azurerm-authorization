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

resource "azurerm_pim_eligible_role_assignment" "pim_eligible_role_assignment" {
  for_each = var.pim_eligible_role_assignment

  principal_id       = local.pim_eligible_role_assignment[each.key].principal_id
  role_definition_id = local.pim_eligible_role_assignment[each.key].role_definition_id
  scope              = local.pim_eligible_role_assignment[each.key].scope

  dynamic "schedule" {
    for_each = length(compact(concat([for key in
    setsubtract(keys(local.pim_eligible_role_assignment[each.key].schedule), ["expiration"]) : local.pim_eligible_role_assignment[each.key].schedule[key]], values(local.pim_eligible_role_assignment[each.key].schedule["expiration"])))) > 0 ? [0] : []

    content {
      start_date_time = local.pim_eligible_role_assignment[each.key].schedule.start_date_time

      dynamic "expiration" {
        for_each = length(compact(values(local.pim_eligible_role_assignment[each.key].schedule.expiration))) > 0 ? [0] : []

        content {
          duration_days  = local.pim_eligible_role_assignment[each.key].schedule.expiration.duration_days
          duration_hours = local.pim_eligible_role_assignment[each.key].schedule.expiration.duration_hours
          end_date_time  = local.pim_eligible_role_assignment[each.key].schedule.expiration.end_date_time
        }
      }
    }
  }
}
