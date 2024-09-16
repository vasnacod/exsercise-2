provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

/* module "tfstate" {
  source = "./tfstate/"
  dynamotfstate = var.dynamotfstate
  s3tfstate = var.s3tfstate  
} */

/* terraform {
  backend "s3" {
    bucket         = var.s3tfstate
    key            = var.s3key
    region         = var.region
    encrypt        = true
    dynamodb_table = var.dynamotfstate
  }
} */

module "sns" {
  source        = "./components/sns"
  project_name  = var.project_name
  email_address = var.email_address
  topic_name    = "${var.project_name}-${var.topic_name}"
}

module "lambda" {
  source        = "./components/lambda/"
  sns_topic_arn = module.sns.sns_topic_arn
  filename      = var.filename
  functionname  = var.functionname
  handler       = var.handler
  runtime       = var.runtime
}

module "apigw" {
  source       = "./components/apigw"
  functionname = var.functionname
  project_name = var.project_name
  region       = var.region
  lambda_arn   = module.lambda.lambda_function_arn
  accountid    = var.accountid
}

output "apiurl" {
  value = module.apigw.api_url
}
/* output "smanger_nameto" {
  value = module.secrets_manager.secret_name
} */
