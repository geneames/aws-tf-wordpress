output "efs_arn" {
  value = "${aws_efs_file_system.web_nfs.arn}"
}

output "efs_id" {
  value = "${aws_efs_file_system.web_nfs.id}"
}

output "efs_dns_name" {
  value = "${aws_efs_file_system.web_nfs.dns_name}"
}
