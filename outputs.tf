output "role_assignments" {
  description = "Outputs all attributes of resource_type."
  value = {
    for role_assignment in keys(azurerm_role_assignment.role_assignment) :
    role_assignment => {
      for key, value in azurerm_role_assignment.role_assignment[role_assignment] :
      key => value
    }
  }
}

output "user_assigned_identity" {
  description = "Outputs all attributes of resource_type."
  value = {
    for user_assigned_identity in keys(azurerm_user_assigned_identity.user_assigned_identity) :
    user_assigned_identity => {
      for key, value in azurerm_user_assigned_identity.user_assigned_identity[user_assigned_identity] :
      key => value
    }
  }
}

output "variables" {
  description = "Displays all configurable variables passed by the module. __default__ = predefined values per module. __merged__ = result of merging the default values and custom values passed to the module"
  value = {
    default = {
      for variable in keys(local.default) :
      variable => local.default[variable]
    }
    merged = {
      role_assignment = {
        for key in keys(var.role_assignment) :
        key => local.role_assignment[key]
      }
      user_assigned_identity = {
        for key in keys(var.user_assigned_identity) :
        key => local.user_assigned_identity[key]
      }
    }
  }
}
