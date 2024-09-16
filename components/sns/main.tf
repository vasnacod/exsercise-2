resource "aws_sns_topic" "ordersns" {
  name = var.topic_name
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.ordersns.arn
  protocol  = "email"
  endpoint  = var.email_address
}