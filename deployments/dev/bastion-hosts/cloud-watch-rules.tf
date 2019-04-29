//resource "aws_cloudwatch_event_rule" "console" {
//  name        = "capture-aws-sign-in"
//  description = "Capture each AWS Console Sign In"
//
//  event_pattern = <<PATTERN
//  {
//  "source": [
//    "aws.autoscaling"
//  ],
//  "detail-type": [
//    "EC2 Instance Launch Successful"
//  ],
//  "detail": {
//    "AutoScalingGroupName": [
//      "${module.bastion-asg.autoscaling_group_name}"
//    ]
//  }
//PATTERN
//}
//
//resource "aws_cloudwatch_event_target" "sns" {
//  rule      = "${aws_cloudwatch_event_rule.console.name}"
//  target_id = "SendToSNS"
//  arn       = ""
//}
