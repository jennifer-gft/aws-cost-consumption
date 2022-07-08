
variable "LambdaName" {
  type = string
}

variable "zipName" {
  type = string
  default = "helloworld.py.zip"
}

variable "Schedule" {
 type = string
 default = "cron(0 0 0 3,6,9,12 2 * )"
}

variable "LambdaIAM" {
  type = string
}