## tf-aws-ssm-patch-mgmt
-----

This module should be used where customers wish to patch Windows instances based on a schedule.

The schedule must be in cron format, for example by default the patch scan schedule occurs on a Wednesday 6PM, the patch install schedule occurs at 9PM.

### Prerequisites

The instances that you wish to be covered by ssm patch management must be tagged with their corresponding "Patch Group". For example we have used the defaults here of "static" and "disposable" for patch scanning, and "automatic" if you want patches automatically installed.

By default:
Instances that are tagged with Key: Patch Group, Value: Disposable will be scanned for Windows updates and then will have the updates installed.
Instances that are tagged with Key: Patch Group, Value: Static will just be scanned and not installed.

Declare a module in your Terraform file, for example:

    module "ssm-patching" {
      source = "../modules/tf-aws-ssm-patch-mgmt"

      envtype                             = "${var.envtype}"
      scan_maintenance_window_schedule    = "cron(0 0 17 ? * SUN *)"
      install_maintenance_window_schedule = "cron(0 0 20 ? * SUN *)"
    }



### Variables

variable "envtype" {}

## patch baseline vars

variable "approved_patches" {
  type    = "list"
  default = [""]
}

variable "rejected_patches" {
  type    = "list"
  default = [""]
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
  default = "cron(0 0 18 ? * SUN *)"
}

variable "install_maintenance_window_schedule" {
  default = "cron(0 0 21 ? * SUN *)"
}

variable "maintenance_window_duration" {
  default = "3"
}

variable "maintenance_window_cutoff" {
  default = "1"
}

variable "patch_groups" {
  type    = "list"
  default = ["static", "disposable"]
}