data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "ssm-policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}
