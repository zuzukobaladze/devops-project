terraform {
  required_version = ">= 0.14"
}

# Use local-exec to create directories and setup environment
resource "null_resource" "setup_environment" {
  # This provisioner will run every time
  provisioner "local-exec" {
    command = <<-EOT
      #!/bin/bash
      set -e
      
      # Define directories to create
      PROJECT_ROOT="${path.module}/.."
      DIRS=(
        "$PROJECT_ROOT/app"
        "$PROJECT_ROOT/app/templates"
        "$PROJECT_ROOT/production"
        "$PROJECT_ROOT/staging"
        "$PROJECT_ROOT/backup"
        "$PROJECT_ROOT/logs"
      )
      
      # Create directories
      for DIR in "$${DIRS[@]}"; do
        mkdir -p "$DIR"
        echo "Created directory: $DIR"
      done
      
      # Create log file if it doesn't exist
      LOG_FILE="$PROJECT_ROOT/logs/health_checks.log"
      if [ ! -f "$LOG_FILE" ]; then
        touch "$LOG_FILE"
        echo "Created log file: $LOG_FILE"
      fi
      
      echo "Environment setup complete!"
    EOT
  }
}

# Use local-exec to check Python installation
resource "null_resource" "check_python" {
  provisioner "local-exec" {
    command = <<-EOT
      #!/bin/bash
      
      # Check if Python is installed
      if command -v python3 &>/dev/null; then
        echo "Python is installed: $(python3 --version)"
      else
        echo "Python is not installed, please install Python 3"
        exit 1
      fi
      
      # Check if pip is installed
      if command -v pip3 &>/dev/null; then
        echo "Pip is installed: $(pip3 --version)"
      else
        echo "Pip is not installed, please install pip for Python 3"
        exit 1
      fi
    EOT
  }
}

# Use local-exec to check Ansible installation
resource "null_resource" "check_ansible" {
  provisioner "local-exec" {
    command = <<-EOT
      #!/bin/bash
      
      # Check if Ansible is installed
      if command -v ansible &>/dev/null; then
        echo "Ansible is installed: $(ansible --version | head -n1)"
      else
        echo "Ansible is not installed, installing via pip..."
        pip3 install ansible
        echo "Ansible installed: $(ansible --version | head -n1)"
      fi
    EOT
  }
  
  depends_on = [null_resource.check_python]
}

# Output with instructions
output "setup_complete" {
  value = <<-EOT
    Environment setup completed!
    
    Next steps:
    1. Run Ansible playbook:
       cd ../ansible && ansible-playbook -i inventory.ini setup.yml
    
    2. Deploy the application:
       cd ../ansible && ansible-playbook -i inventory.ini deploy.yml
    
    3. Start the application:
       ../scripts/start_app.sh
    
    4. Start the dashboard:
       ../scripts/start_dashboard.sh
    
    5. Set up health check cron:
       ../scripts/setup_cron.sh
  EOT
  
  depends_on = [
    null_resource.setup_environment,
    null_resource.check_python,
    null_resource.check_ansible
  ]
} 