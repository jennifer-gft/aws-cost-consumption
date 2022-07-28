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
  default     = "cron(0 0 1 1/3 ? *)" // "quarterly"
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

variable "prefix" {
  type        = string
  description = "prefix that client uses for naming their resources"
}