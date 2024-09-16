variable "aws_profile" {}
variable "region" {}
variable "project_name" {}
variable "accountid" {}

variable "dynamotfstate" {}
variable "s3tfstate" {}
variable "s3key" {}

#sns
variable "topic_name" {}
variable "email_address" {}

#lambda
variable "filename" {}
variable "functionname" {}
variable "handler" {}
variable "runtime" {}