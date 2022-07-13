variable "region" {
  type = string
}

variable "client_name" {
  type = string
}

variable "project_name" {
  type = string

}

variable "schedule" {
  type        = string
  default     = "quarterly" // "cron(0 0 0 3,6,9,12 2 * )" 
  description = "values supported are weekly, monthly, quarterly, yearly"
}

variable "project_description" {
  type = string
}

variable "client_env" {
  type = string

}

variable "total_client_env" {
  type = string
}

variable "install_date" {
  type = string
}

variable "cross_account_role" {
  type = string
}
