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
variable "pim_eligible_role_assignment" {
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
    pim_eligible_role_assignment = {
      justification = null
      schedule = {
        expiration = {
          duration_days  = null
          duration_hours = null
          end_date_time  = null
        }
        start_date_time = null
      }
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
  pim_eligible_role_assignment_values = {
    for pim_eligible_role_assignment in keys(var.pim_eligible_role_assignment) :
    pim_eligible_role_assignment => merge(local.default.pim_eligible_role_assignment, var.pim_eligible_role_assignment[pim_eligible_role_assignment])
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
  pim_eligible_role_assignment = {
    for pim_eligible_role_assignment in keys(var.pim_eligible_role_assignment) :
    pim_eligible_role_assignment => merge(
      local.pim_eligible_role_assignment_values[pim_eligible_role_assignment],
      {
        for config in ["schedule"] :
        config => lookup(var.pim_eligible_role_assignment[pim_eligible_role_assignment], config, {}) == {} ? null : merge(
          merge(local.default.pim_eligible_role_assignment[config], local.pim_eligible_role_assignment_values[pim_eligible_role_assignment][config]),
          {
            for subconfig in ["expiration"] :
            subconfig => merge(local.default.pim_eligible_role_assignment[config][subconfig], lookup(local.pim_eligible_role_assignment_values[pim_eligible_role_assignment][config], subconfig, {}))
          }
        )
      }
    )
  }
}
