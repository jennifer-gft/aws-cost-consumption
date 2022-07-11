
variable "client_name" {
  type = string
}

variable "project_name" {
  type = string

}

variable "schedule" {
 type = string
 default = "cron(0 0 0 3,6,9,12 2 * )"
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
