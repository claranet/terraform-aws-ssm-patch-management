resource "aws_ssm_patch_baseline" "baseline" {
  name             = "${var.name}-${var.envname}-patch-baseline"
  description      = "${var.profile} patch baseline"
  approved_patches = ["${var.approved_patches}"]
  rejected_patches = ["${var.rejected_patches}"]

  approval_rule {
    approve_after_days = 7

    patch_filter {
      key    = "PRODUCT"
      values = ["${var.product_versions}"]
    }

    patch_filter {
      key    = "CLASSIFICATION"
      values = ["${var.patch_classification}"]
    }

    patch_filter {
      key    = "MSRC_SEVERITY"
      values = ["${var.patch_severity}"]
    }
  }
}

resource "aws_ssm_patch_group" "scan_patchgroup" {
  count       = "${length(var.scan_patch_groups)}"
  baseline_id = "${aws_ssm_patch_baseline.baseline.id}"
  patch_group = "${element(keys(var.scan_patch_groups), count.index)}"
}

resource "aws_ssm_maintenance_window" "scan_window" {
  count    = "${length(var.scan_patch_groups)}"
  name     = "${var.name}-${element(keys(var.scan_patch_groups), count.index)}-patch-maintenance-scan-mw"
  schedule = "${lookup(var.scan_patch_groups, (element(keys(var.scan_patch_groups), count.index)))}"
  duration = "${var.maintenance_window_duration}"
  cutoff   = "${var.maintenance_window_cutoff}"
}

resource "aws_ssm_maintenance_window_target" "target_scan" {
  count         = "${length(var.scan_patch_groups)}"
  window_id     = "${element(aws_ssm_maintenance_window.scan_window.*.id, count.index)}"
  resource_type = "INSTANCE"

  targets {
    key    = "tag:Patch Group"
    values = ["${element(keys(var.scan_patch_groups), count.index)}"]
  }
}

resource "aws_ssm_maintenance_window_task" "task_scan_patches" {
  count            = "${length(var.scan_patch_groups)}"
  window_id        = "${element(aws_ssm_maintenance_window.scan_window.*.id, count.index)}"
  task_type        = "RUN_COMMAND"
  task_arn         = "AWS-ApplyPatchBaseline"
  priority         = 1
  service_role_arn = "${aws_iam_role.ssm_maintenance_window.arn}"
  max_concurrency  = "${var.max_concurrency}"
  max_errors       = "${var.max_errors}"

  targets {
    key    = "WindowTargetIds"
    values = ["${element(aws_ssm_maintenance_window_target.target_scan.*.id, count.index)}"]
  }

  task_parameters {
    name   = "Operation"
    values = ["Scan"]
  }

  logging_info {
    s3_bucket_name = "${aws_s3_bucket.ssm_patch_log_bucket.id}"
    s3_region      = "${var.aws_region}"
  }
}

resource "aws_ssm_patch_group" "install_patchgroup" {
  count       = "${length(var.install_patch_groups)}"
  baseline_id = "${aws_ssm_patch_baseline.baseline.id}"
  patch_group = "${element(keys(var.install_patch_groups), count.index)}"
}


resource "aws_ssm_maintenance_window" "install_window" {
  count    = "${length(var.install_patch_groups)}"
  name     = "${var.name}-${element(keys(var.install_patch_groups), count.index)}-patch-maintenance-install-mw"
  schedule = "${lookup(var.install_patch_groups, (element(keys(var.install_patch_groups), count.index)))}"
  duration = "${var.maintenance_window_duration}"
  cutoff   = "${var.maintenance_window_cutoff}"
}

resource "aws_ssm_maintenance_window_target" "target_install" {
  count         = "${length(var.install_patch_groups)}"
  window_id     = "${element(aws_ssm_maintenance_window.install_window.*.id, count.index)}"
  resource_type = "INSTANCE"

  targets {
    key    = "tag:Patch Group"
    values = ["${element(keys(var.install_patch_groups), count.index)}"]
  }
}

resource "aws_ssm_maintenance_window_task" "task_install_patches" {
  count            = "${length(var.install_patch_groups)}"
  window_id        = "${element(aws_ssm_maintenance_window.install_window.*.id, count.index)}"
  task_type        = "RUN_COMMAND"
  task_arn         = "AWS-ApplyPatchBaseline"
  priority         = 1
  service_role_arn = "${aws_iam_role.ssm_maintenance_window.arn}"
  max_concurrency  = "${var.max_concurrency}"
  max_errors       = "${var.max_errors}"

  targets {
    key    = "WindowTargetIds"
    values = ["${element(aws_ssm_maintenance_window_target.target_install.*.id, count.index)}"]
  }

  task_parameters {
    name   = "Operation"
    values = ["Install"]
  }

  logging_info {
    s3_bucket_name = "${aws_s3_bucket.ssm_patch_log_bucket.id}"
    s3_region      = "${var.aws_region}"
  }
}
