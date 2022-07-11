
variable "EventRuleName" {
  type = string
}

variable "LambdaName" {
  type = string
}

variable "zipName" {
  type = string
  default = "modules/EventBridge/helloworld.py.zip"
}

variable "Schedule" {
 default = "cron(0 0 1 */3 ? *)"
}

variable "LambdaIAM" {
  type = string
}