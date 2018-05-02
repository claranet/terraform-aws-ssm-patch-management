tf-aws-ssm-patch-mgmt
-----

This module should be used to patch Windows instances based on a schedule.

The schedule must be in cron or rate format, for example by default the patch scan schedule occurs on a Wednesday 6PM, the patch install schedule occurs at 9PM. For further information on these formats please see the AWS user docs <a href="https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-maintenance-cron.html" _target="blank">here</a>.

#### Instance tagging
The instances that you wish to be covered by SSM patch management must be tagged with their corresponding "Patch Group". For example we have used the defaults here of "manual" for patch scanning, and "automatic" if you want patches automatically installed.

_By default:_
* Instances that are tagged with Key: 'Patch Group', Value: 'automatic' will be scanned for Windows updates and then will have the updates installed.

* Instances that are tagged with Key: 'Patch Group', Value: 'static' and or 'disposable' will just be scanned and not installed.

<br />

Usage
-----

```js

module "ssm-patching" {
  source           = "../modules/tf-aws-ssm-patch-mgmt"
  name             = "${var.customer}"
  envname          = "${var.envtype}"
  product_versions = ["WindowsServer2016", "WindowsServer2012R2", "WindowsServer2008R2"]

  scan_patch_groups = {
    "manual_static_1" = "cron(15 06 ? * SUN *)"
    "manual_static_2" = "cron(45 06 ? * SUN *)"
    "manual_asg_1"    = "cron(30 06 ? * SUN *)"
    "manual_asg_2"    = "cron(00 07 ? * SUN *)"
  }
  
  install_patch_groups = {
    "automatic" = "cron(15 06 ? * SUN *)"
  }
}

```


Variables
---------
_Variables marked with [*] are mandatory._

###### General variables
 - `source` - The source path to the terraform module, see <a href="https://www.terraform.io/docs/modules/sources.html" target="_blank">here</a> for further information on the `source` variable. [*]

 - `name` - This value will prefix all resources, and be added as the value for the `Name` tag where supported. [*]

 - `envname` - This label will be added after `name` on all resources, and be added as the value for the `Environment` tag where supported. [*]
 
###### Patch baseline variables
 - `approved_patches` - An explicit list of approved patches for the SSM baseline. [Default: []]

 - `rejected_patches` - An explicit list of rejected patches for the SSM baseline. [Default: []]

 - `product_versions` - An explicit list of rejected patches for the SSM baseline. [Default: []]

 - `product_versions` - The list of product versions for the SSM baseline. [Default: ["WindowsServer2016", "WindowsServer2012R2"]]

 - `patch_classification` - The list of patch classifications for the SSM baseline. [Default: ["CriticalUpdates", "SecurityUpdates"]]

 - `patch_severity` - The list of patch severities for the SSM baseline. [Default: ["Critical", "Important"]]

###### Maintenance Window variables
  
 - `maintenance_window_duration` - The duration of the _all_ Maintenance Windows in hours. [Default: "3"]

 - `maintenance_window_cutoff` - The number of hours before the end of any Maintenance Window that Systems Manager stops scheduling new tasks for execution. [Default: "1"]

 - `install_patch_groups` - A Map variable of _install_ patching groups and associated maintenance window schedules, one target will be created per entry in the Map. [Default: ["automatic"]]
                            The schedule of the _install_ Maintenance Window in the form of a cron or rate expression. You can find further information on the cron format <a href="https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-maintenance-cron.html" _target="blank">here</a>. [Default: "cron(0 0 21 ? * SUN *)"]

 - `scan_patch_groups` - A Map variable of _scan_ patching groups and associated maintenance window schedules, one target will be created per entry in this list. [Default: ["manual"]]
                         The schedule of the _scan_ Maintenance Window in the form of a cron or rate expression. You can find further information on the cron format <a href="https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-maintenance-cron.html" _target="blank">here</a>. [Default: "cron(0 0 18 ? * SUN *)"]

<br />

Outputs
---------
_(None)_

Issues
------
aws_ssm_maintenance_window_target - Resource does not currently support update. Terraform taint the resource before running terraform apply:

```
terraform taint -module=ssm-patching aws_ssm_maintenance_window_target.target_scan
```
```
terraform taint -module=ssm-patching aws_ssm_maintenance_window_target.target_install
```
