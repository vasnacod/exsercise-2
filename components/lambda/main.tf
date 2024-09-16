# Define the IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
       {
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
    ]
  })
}

# Define a policy to allow Lambda to publish to SNS
resource "aws_iam_policy" "lambda_sns_policy" {
  name        = "lambda_sns_policy"
  description = "Allow Lambda to publish messages to SNS topics"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sns:Publish"
        ]
        Effect   = "Allow"
        Resource = var.sns_topic_arn
      }
    ]
  })
}

# Attach the SNS policy to the Lambda role
resource "aws_iam_role_policy_attachment" "lambda_sns_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_sns_policy.arn
  role     = aws_iam_role.lambda_role.name
}
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role = aws_iam_role.lambda_role.name
}

# Define a policy to allow Lambda to write logs to CloudWatch
resource "aws_iam_policy" "lambda_cloudwatch_policy" {
  name        = "lambda_cloudwatch_policy"
  description = "Allow Lambda to write logs to CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Attach the CloudWatch policy to the Lambda role
resource "aws_iam_role_policy_attachment" "lambda_cloudwatch_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_cloudwatch_policy.arn
  role     = aws_iam_role.lambda_role.name
}

resource "aws_cloudwatch_log_group" "ordercloudlog" {
  name              = "/aws/lambda/${var.functionname}"
  retention_in_days = 7
}

resource "aws_lambda_function" "orderlam" {
  filename      = var.filename
  function_name = var.functionname
  role          = aws_iam_role.lambda_role.arn
  handler       = var.handler
  runtime       = var.runtime

  environment {
    variables = {
      SNS_TOPIC_ARN = var.sns_topic_arn
    }
  }
}
