terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "2.4.0"
    }
  }
}

provider "local" {}

resource "local_file" "mock_deployment" {
  content  = "This is a mock deployment file"
  filename = "${path.module}/mock_deployment.txt"
}

output "mock_output" {
  value = "Mock deployment completed successfully"
  description = "A mock output to demonstrate successful deployment"
} 