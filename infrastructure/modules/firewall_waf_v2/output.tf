output "arn" {
  value       = aws_wafv2_web_acl.waf_v2_acl.arn
  description = "The arn of the web acl."
}