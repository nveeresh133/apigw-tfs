resource "aws_api_gateway_rest_api" "rest_api"{
    name = var.rest_api_name
}

resource "aws_api_gateway_resource" "rest_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part = "dashboard"
  }

#OPTIONS Method
resource "aws_api_gateway_method" "option_method" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.rest_api_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "option_integration" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.rest_api_resource.id
  http_method = aws_api_gateway_method.option_method.http_method
  type                    = "MOCK"
  integration_http_method = "OPTIONS"
  passthrough_behavior    = "NEVER"
  
}

resource "aws_api_gateway_method_response" "option_response_200"{
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.rest_api_resource.id
  http_method = aws_api_gateway_method.option_method.http_method
  status_code = "200"
   response_models = {
    "application/json" = "ResponseSchema"
  }
  response_parameters = { 
    "method.response.header.Access-Control-Allow-Headers" = true 
    "method.response.header.Access-Control-Allow-Origin" = true 
    "method.response.header.Access-Control-Allow-Methods" = true                                                      
    }
}

resource "aws_api_gateway_integration_response" "option_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.rest_api_resource.id
  http_method = aws_api_gateway_integration.option_integration.http_method
  status_code = aws_api_gateway_method_response.option_response_200.status_code
  response_templates = {
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'"
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
     }
}