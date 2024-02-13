variable "role_assignment" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}
variable "user_assigned_identity" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}

locals {
  default = {
    // resource definition
    role_assignment = {
      name                                   = null
      role_definition_id                     = null
      role_definition_name                   = null
      condition                              = null
      condition_version                      = null
      delegated_managed_identity_resource_id = null
      description                            = null
      skip_service_principal_aad_check       = null
    }

    user_assigned_identity = {
      name = ""
      tags = {}
    }
  }

  // compare and merge custom and default values
  role_assignment_values = {
    for role_assignment in keys(var.role_assignment) :
    role_assignment => merge(local.default.role_assignment, var.role_assignment[role_assignment])
  }
  user_assigned_identity_values = {
    for user_assigned_identity in keys(var.user_assigned_identity) :
    user_assigned_identity => merge(local.default.user_assigned_identity, var.user_assigned_identity[user_assigned_identity])
  }

  // deep merge of all custom and default values
  role_assignment = {
    for role_assignment in keys(var.role_assignment) :
    role_assignment => merge(
      local.role_assignment_values[role_assignment],
      {}
    )
  }
  user_assigned_identity = {
    for user_assigned_identity in keys(var.user_assigned_identity) :
    user_assigned_identity => merge(
      local.user_assigned_identity_values[user_assigned_identity],
      {}
    )
  }
}
