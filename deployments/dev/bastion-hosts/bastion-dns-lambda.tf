######################################################
# Data
######################################################
data "aws_caller_identity" "current" {}

######################################################
# Archive Lambda Code
######################################################
data "archive_file" "init" {
  type        = "zip"
  source_file = "${path.module}/../../../lambdas/asg-manage-bastion-dns/handler.py"
  output_path = "${path.module}/files/handler.zip"
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "bastion-asg-event-lambda-role"
  assume_role_policy = "${data.aws_iam_policy_document.assume.json}"
}

data "aws_iam_policy_document" "assume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

data "aws_iam_policy_document" "lambda_policy_doc" {
  statement {
    effect = "Allow"
    actions   = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:*"]
  }
  statement {
    effect = "Allow"
    actions   = ["ec2:DescribeInstances"]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions   = [
      "route53:ChangeResourceRecordSets",
      "route53:CreateHealthCheck",
      "route53:DeleteHealthCheck",
      "route53:UpdateHealthCheck"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "lambda_policy" {
  policy = "${data.aws_iam_policy_document.lambda_policy_doc.json}"
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  policy_arn = "${aws_iam_policy.lambda_policy.arn}"
  role = "${aws_iam_role.lambda_execution_role.name}"
}

resource "aws_lambda_function" "manage_bastion_dns_rsets" {
  function_name = "bastion_dns"
  handler = "handler.manage_bastion_dns"
  role = "${aws_iam_role.lambda_execution_role.arn}"
  runtime = "python3.6"
  filename = "${path.module}/files/handler.zip"

  environment {
    variables = {
      // Debug Log Level
      LOG_LEVEL = "10"
    }
  }
}

resource "aws_lambda_permission" "cloud_watch" {
  statement_id = "AllowFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.manage_bastion_dns_rsets.function_name}"
  principal = "events.amazonaws.com"
  source_arn = "arn:aws:events:us-west-2:476778078169:rule/test-rule"
}

resource "aws_cloudwatch_event_rule" "asg_lifecycle" {
  name        = "bastion-asg-lifecycle-events"
  description = "Capture instance lifecycle events and make appropriate updates to Route53"

  event_pattern = <<PATTERN
{
  "detail-type": [
    "EC2 Instance-launch Lifecycle Action",
    "EC2 Instance-terminate Lifecycle Action"
  ]
}
PATTERN
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule      = "${aws_cloudwatch_event_rule.asg_lifecycle.name}"
  target_id = "SendToLambda"
  arn       = "${aws_lambda_function.manage_bastion_dns_rsets.arn}"
}
