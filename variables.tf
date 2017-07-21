variable "name" {}

variable "envname" {}

variable "envtype" {}

variable "profile" {
  default = "Windows"
}

variable "aws_region" {
  default = "eu-west-1"
}

## patch baseline vars

variable "approved_patches" {
  type    = "list"
  default = []
}

variable "rejected_patches" {
  type    = "list"
  default = []
}

variable "product_versions" {
  type    = "list"
  default = ["WindowsServer2016", "WindowsServer2012R2"]
}

variable "patch_classification" {
  type    = "list"
  default = ["CriticalUpdates", "SecurityUpdates"]
}

variable "patch_severity" {
  type    = "list"
  default = ["Critical", "Important"]
}

## maintenance window vars

variable "scan_maintenance_window_schedule" {
  default = "cron(0 0 18 ? * WED *)"
}

variable "install_maintenance_window_schedule" {
  default = "cron(0 0 21 ? * WED *)"
}

variable "maintenance_window_duration" {
  default = "3"
}

variable "maintenance_window_cutoff" {
  default = "1"
}

variable "scan_patch_groups" {
  type    = "list"
  default = ["static", "disposable"]
}

variable "install_patch_groups" {
  type    = "list"
  default = ["automatic"]
}

variable "max_concurrency" {
  default = "20"
}

variable "max_errors" {
  default = "50"
}

## logging info

variable "s3_bucket_name" {}
