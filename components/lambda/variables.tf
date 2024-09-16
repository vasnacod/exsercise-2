variable "sns_topic_arn" {
  description = "ARN of the SNS topic to which the Lambda will publish"
  type        = string
}
variable "filename" {}
variable "functionname" {}
variable "handler" {}
variable "runtime" {}