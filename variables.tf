variable "role_assignment" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}

locals {
  default = {
    // resource definition
    role_assignment = {
      name                                   = ""
      role_definition_id                     = null
      role_definition_name                   = null
      condition                              = null
      condition_version                      = null
      delegated_managed_identity_resource_id = null
      description                            = null
      skip_service_principal_aad_check       = null
      tags                                   = {}
    }
  }

  // compare and merge custom and default values
  role_assignment_values = {
    for role_assignment in keys(var.role_assignment) :
    role_assignment => merge(local.default.role_assignment, var.role_assignment[role_assignment])
  }

  // deep merge of all custom and default values
  role_assignment = {
    for role_assignment in keys(var.role_assignment) :
    role_assignment => merge(
      local.role_assignment_values[role_assignment],
      {}
    )
  }
}
