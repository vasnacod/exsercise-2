# Define the API Gateway REST API
resource "aws_api_gateway_rest_api" "orderapi" {
  name        = "${var.project_name}-api"
  description = "API Gateway for Lambda integration for orders"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# Define a resource (e.g., /order)
resource "aws_api_gateway_resource" "orderres" {
  rest_api_id = aws_api_gateway_rest_api.orderapi.id
  parent_id   = aws_api_gateway_rest_api.orderapi.root_resource_id
  path_part    = "order"
}

# Define a method (e.g., POST) for the resource
resource "aws_api_gateway_method" "ordermet" {
  rest_api_id = aws_api_gateway_rest_api.orderapi.id
  resource_id   = aws_api_gateway_resource.orderres.id
  http_method   = "POST"
  authorization = "NONE"
}

# Define the integration of the method with an actual service (e.g., Lambda)
resource "aws_api_gateway_integration" "order_integration" {
  rest_api_id = aws_api_gateway_rest_api.orderapi.id
  resource_id   = aws_api_gateway_resource.orderres.id
  http_method = aws_api_gateway_method.ordermet.http_method

  integration_http_method = "POST"
  type                    = "AWS" # Use appropriate integration type
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
}

resource "aws_api_gateway_integration_response" "order_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.orderapi.id
  resource_id   = aws_api_gateway_resource.orderres.id
  http_method   = aws_api_gateway_method.ordermet.http_method
  status_code   = "200"
  
  response_templates = {
    "application/json" = "{}"  # This is a simple empty JSON object
  }
}

# Define the method response to map the integration response
resource "aws_api_gateway_method_response" "order_method_response" {
  rest_api_id = aws_api_gateway_rest_api.orderapi.id
  resource_id   = aws_api_gateway_resource.orderres.id
  http_method   = aws_api_gateway_method.ordermet.http_method
  status_code   = "200"

  # Define the response model
  response_models = {
    "application/json" = "Empty"
  }
}

# Define the deployment of the API
resource "aws_api_gateway_deployment" "order_deployment" {
  depends_on = [aws_api_gateway_integration.order_integration]
  rest_api_id = aws_api_gateway_rest_api.orderapi.id
  stage_name  = "dev"
}

# Allow API Gateway to invoke your Lambda function (if using Lambda integration)
resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.functionname
  principal     = "apigateway.amazonaws.com"
  #source_arn    = "${aws_api_gateway_deployment.order_deployment.execution_arn}/*"
  source_arn = "${aws_api_gateway_rest_api.orderapi.execution_arn}/*"
  #source_arn    = "arn:aws:execute-api:${var.region}:${var.accountid}:${aws_api_gateway_rest_api.orderapi.id}/*/*/*"
}

output "api_url" {
  value = "https://${aws_api_gateway_rest_api.orderapi.id}.execute-api.${var.region}.amazonaws.com/${aws_api_gateway_deployment.order_deployment.stage_name}/order"
}
