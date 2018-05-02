tf-aws-ssm-patch-mgmt
-----

This module should be used to patch Windows instances based on a schedule.

The schedule must be in cron or rate format, for example by default the patch scan schedule occurs on a Wednesday 6PM, the patch install schedule occurs at 9PM. For further information on these formats please see the AWS user docs <a href="https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-maintenance-cron.html" _target="blank">here</a>.

#### Instance tagging
The instances that you wish to be covered by SSM patch management must be tagged with their corresponding "Patch Group". For example we have used the defaults here of "static" and "disposable" for patch scanning, and "automatic" if you want patches automatically installed.

_By default:_
* Instances that are tagged with Key: 'Patch Group', Value: 'automatic' will be scanned for Windows updates and then will have the updates installed.

* Instances that are tagged with Key: 'Patch Group', Value: 'static' and or 'disposable' will just be scanned and not installed.

<br />

Usage
-----

```js

module "ssm-patching" {
  source = "../modules/tf-aws-ssm-patch-mgmt"

  envtype                             = "${var.envtype}"
  scan_maintenance_window_schedule    = "cron(0 0 17 ? * SUN *)"
  install_maintenance_window_schedule = "cron(0 0 20 ? * SUN *)"
}

```


Variables
---------
_Variables marked with [*] are mandatory._

###### General variables
 - `source` - The source path to the terraform module, see <a href="https://www.terraform.io/docs/modules/sources.html" target="_blank">here</a> for further information on the `source` variable. [*]

 - `name` - This value will prefix all resources, and be added as the value for the `Name` tag where supported. [*]

 - `envname` - This label will be added after `name` on all resources, and be added as the value for the `Environment` tag where supported. [*]

 - `envtype` - This label will be added after `envname` on all resources, and be added as the value for the `Envtype` tag where supported. [*]

###### Patch baseline variables
 - `approved_patches` - An explicit list of approved patches for the SSM baseline. [Default: []]

 - `rejected_patches` - An explicit list of rejected patches for the SSM baseline. [Default: []]

 - `product_versions` - An explicit list of rejected patches for the SSM baseline. [Default: []]

 - `product_versions` - The list of product versions for the SSM baseline. [Default: ["WindowsServer2016", "WindowsServer2012R2"]]

 - `patch_classification` - The list of patch classifications for the SSM baseline. [Default: ["CriticalUpdates", "SecurityUpdates"]]

 - `patch_severity` - The list of patch severities for the SSM baseline. [Default: ["Critical", "Important"]]

###### Maintenance Window variables
 - `scan_maintenance_window_schedule` - The schedule of the _scan_ Maintenance Window in the form of a cron or rate expression. You can find further information on the cron format <a href="https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-maintenance-cron.html" _target="blank">here</a>. [Default: "cron(0 0 18 ? * SUN *)"]

 - `install_maintenance_window_schedule` - The schedule of the _install_ Maintenance Window in the form of a cron or rate expression. You can find further information on the cron format <a href="https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-maintenance-cron.html" _target="blank">here</a>. [Default: "cron(0 0 21 ? * SUN *)"]

 - `maintenance_window_duration` - The duration of the _all_ Maintenance Windows in hours. [Default: "3"]

 - `maintenance_window_cutoff` - The number of hours before the end of any Maintenance Window that Systems Manager stops scheduling new tasks for execution. [Default: "1"]

 - `install_patch_groups` - The list of _install_ patching groups, one target will be created per entry in this list. [Default: ["automatic"]]

  - `scan_patch_groups` - The list of _scan_ patching groups, one target will be created per entry in this list. [Default: ["static", "disposable"]]


<br />

Outputs
---------
_(None)_
