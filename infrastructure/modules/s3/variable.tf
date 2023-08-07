variable "bucket_name" {
  description = "the name of the bucket"
  type        = string
}

variable "force_destroy" {
  description = "(Optional, Default:false ) A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  type        = bool
  default     = false
}

# Tags

variable "environment" {
  type = string
}

variable "owner" {
  type = string
}

output "s3_object_access_policy" {
  value = aws_s3_bucket_policy.bucket_policy.policy
}