// S3 Bucket For Logs
resource "aws_s3_bucket" "ssm_patch_log_bucket" {
  bucket        = "${var.name}-${var.envname}-${var.envtype}-ssm-patch-logs"
  force_destroy = true

  tags {
    Name        = "${var.name}"
    Environment = "${var.envname}"
    Envtype     = "${var.envtype}"
    Profile     = "${var.profile}"
  }
}
