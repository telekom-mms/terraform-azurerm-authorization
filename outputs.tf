output "role_assignment" {
  description = "Outputs all attributes of resource_type."
  value = {
    for role_assignment in keys(azurerm_role_assignment.role_assignment) :
    role_assignment => {
      for key, value in azurerm_role_assignment.role_assignment[role_assignment] :
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
    }
  }
}
