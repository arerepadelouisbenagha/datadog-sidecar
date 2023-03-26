resource "aws_ssm_parameter" "datadog_api_key" {
  name        = "/dev/datadog/docker-dev-api-key"
  description = "The parameter description"
  type        = "SecureString"
  value       = var.datadog_api_key
}

data "template_file" "datadog_yaml" {
  template = file("../datadog-sidecar/datadog.yaml")
  vars = {
    datadog_api_key = aws_ssm_parameter.datadog_api_key.value
  }
}

data "template_file" "docker_compose_yaml" {
  template = file("../docker-compose.yml")
  vars = {
    datadog_api_key = aws_ssm_parameter.datadog_api_key.value
  }
}
