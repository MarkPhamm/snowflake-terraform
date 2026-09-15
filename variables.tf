variable "organization_name" {
  type        = string
  description = "Snowflake organization name. From the Snowsight URL or CURRENT_ORGANIZATION_NAME()."
}

variable "account_name" {
  type        = string
  description = "Snowflake account name. From the Snowsight URL or CURRENT_ACCOUNT_NAME()."
}

variable "user" {
  type        = string
  description = "Service user created in 00-setup/initial_setup.sql."
  default     = "TERRAFORM_SVC"
}

variable "private_key_path" {
  type        = string
  description = "PEM private key that matches the public key on TERRAFORM_SVC."
  default     = ".ssh/snowflake_tf_snow_key.p8"
}

variable "provider_warehouse" {
  type        = string
  description = "Warehouse the provider session uses (needed to manage views). Trial accounts ship with COMPUTE_WH."
  default     = "COMPUTE_WH"
}
