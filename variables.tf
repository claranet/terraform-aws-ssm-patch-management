## General vars
variable "name" {
  description = "This name will prefix all resources, and be added as the value for the 'Name' tag where supported"
  type        = "string"
}

variable "envname" {
  description = "This label will be added after 'name' on all resources, and be added as the value for the 'Environment' tag where supported"
  type        = "string"
}

variable "profile" {
  description = "This label will be added to the SSM baseline description"
  type        = "string"
  default     = "Windows"
}

variable "aws_region" {
  description = "The AWS region to create this SSM resource in"
  type        = "string"
  default     = "eu-west-1"
}

## Patch baseline vars
variable "approved_patches" {
  description = "The list of approved patches for the SSM baseline"
  type        = "list"
  default     = []
}

variable "rejected_patches" {
  description = "The list of rejected patches for the SSM baseline"
  type        = "list"
  default     = []
}

varible "patch_approval_delay" {
  description = "The number of days to delay patch auto-approval by"
  default     = 7
}

variable "product_versions" {
  description = "The list of product versions for the SSM baseline"
  type        = "list"
  default     = ["WindowsServer2016", "WindowsServer2012R2", "WindowsServer2008R2"]
}

variable "patch_classification" {
  description = "The list of patch classifications for the SSM baseline"
  type        = "list"
  default     = ["CriticalUpdates", "SecurityUpdates"]
}

variable "patch_severity" {
  description = "The list of patch severities for the SSM baseline"
  type        = "list"
  default     = ["Critical", "Important"]
}

## Maintenance window vars
variable "maintenance_window_duration" {
  description = "The duration of the maintenence windows (hours)"
  type        = "string"
  default     = "3"
}

variable "maintenance_window_cutoff" {
  description = "The number of hours before the end of the Maintenance Window that Systems Manager stops scheduling new tasks for execution"
  type        = "string"
  default     = "1"
}

variable "scan_patch_groups" {
  description = "The map of scan patching groups and maintenance window schedules"
  type        = "map"

  default = {
    "manual" = "cron(0 0 18 ? * WED *)"
  }
}

variable "install_patch_groups" {
  description = "The map of install patching groups and maintenance window schedules"
  type        = "map"

  default = {
    "automatic" = "cron(0 0 21 ? * WED *)"
  }
}

variable "max_concurrency" {
  description = "The maximum amount of concurrent instances of a task that will be executed in parallel"
  type        = "string"
  default     = "20"
}

variable "max_errors" {
  description = "The maximum amount of errors that instances of a task will tollerate before being de-scheduled"
  type        = "string"
  default     = "50"
}
