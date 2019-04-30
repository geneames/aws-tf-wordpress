######################################################
# Archive Lambda Code
######################################################
data "archive_file" "init" {
  type        = "zip"
  source_file = "${path.module}/../../../lambdas/asg-manage-bastion-dns/handler.py"
  output_path = "${path.module}/files/handler.zip"
}

######################################################
# Lambda IAM Policy
######################################################
data "template_file" "iam_policy" {
  template = "${file("${path.module}/files/bastion-dns-lambda-policy.json.tpl")}"

  vars {
    sns_topic_arn = "${aws_sns_topic.asg-lifecycle-topic.arn}"
  }
}

resource "aws_iam_policy" "lambda_role_policies" {
  policy = "${data.template_file.iam_policy.rendered}"
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "bastion-asg-event-lambda-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com",
          "sns.amazonaws.com",
          "route53.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda-execution-policy-attachment" {
    role = "${aws_iam_role.lambda_execution_role.name}"
    policy_arn = "${aws_iam_policy.lambda_role_policies.arn}"
}

resource "aws_lambda_function" "manage_bastion_dns_rsets" {
  function_name = "bastion_dns"
  handler = "handler.manage_bastion_dns"
  role = "${aws_iam_role.lambda_execution_role.arn}"
  runtime = "python3.6"
  filename = "${path.module}/files/handler.zip"
}

resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = "${aws_sns_topic.asg-lifecycle-topic.arn}"
  protocol  = "lambda"
  endpoint  = "${aws_lambda_function.manage_bastion_dns_rsets.arn}"
}


