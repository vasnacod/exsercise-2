resource "aws_dynamodb_table" "dynamotfstate" {
  name           = var.dynamotfstate
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
resource "aws_s3_bucket" "s3tfstate" {
    bucket = var.s3tfstate
}