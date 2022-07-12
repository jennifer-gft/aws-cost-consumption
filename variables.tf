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
 type = string
 default = "quarterly" // "cron(0 0 0 3,6,9,12 2 * )" 
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

variable "destintion_account"{
    type = string
}

#####SQS Variables

variable "queue_name" {
  description = "The name of the queue. Used as a prefix for related resource names."
  type = string
  default = "report-delivery-queue"
}


variable "retention_period" {
  description = "Time (in seconds) that messages will remain in queue before being purged"
  type = number
  default = 86400
}


variable "visibility_timeout" {
  description = "Time (in seconds) that consumers have to process a message before it becomes available again"
  type = number
  default = 60
}


variable "receive_count" {
  description = "The number of times that a message can be retrieved before being moved to the dead-letter queue"
  type = number
  default = 3
}
