## 2.0.1 (January 31, 2018)

IMPROVEMENTS:
* Updated Instance tagging and Issues within README
* Removed unused variable s3_bucket_name

## 2.0.0 (January 24, 2018)

IMPROVEMENTS:
* Removed variable envtype
* Scan Patch Group Tag changed from static and disposable to manual
* Windows 2008R2 added to Product Versions

## 1.3.1 (September 22, 2017)

IMPROVEMENTS:
* Updated the examples in the README
* Added descriptions to the variables
* Added LICENSE and CHANGELOG

## 1.3.0 (July 21, 2017)

FEATURES:
* Added s3 logging

IMPROVEMENTS:
* Refactored module into seperate files
* Updated patch group tags

## 1.2.0 (June 23, 2017)

BUG FIXES:

* Fixed `max_concurrency` and `max_errors` which were not passed through to resource.

## 1.1.0 (June 21, 2017)

IMPROVEMENTS:

* Added support for customizing `max_concurrency` and `max_errors` in the maintaince_window_task
* Added `required_version` to terraform

BUG FIXES:

* Fixed `approved_patches` and `rejected_patches` variable defaults
* Added missing `envtype` variable

## 1.0.0 (June 14, 2017)

Initial version
