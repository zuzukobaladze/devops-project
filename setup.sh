#!/bin/bash

# Master setup script for DevOps Pipeline Project

echo "=========================================================="
echo "DevOps Pipeline Project - Setup Script"
echo "=========================================================="
echo

# Get the project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_ROOT" || exit 1

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
echo "Checking prerequisites..."

# Check Python
if command_exists python3; then
  echo "✓ Python 3 is installed: $(python3 --version)"
else
  echo "✗ Python 3 is not installed. Please install Python 3."
  exit 1
fi

# Check pip
if command_exists pip3; then
  echo "✓ pip is installed: $(pip3 --version)"
else
  echo "✗ pip is not installed. Please install pip for Python 3."
  exit 1
fi

# Check Terraform
if command_exists terraform; then
  echo "✓ Terraform is installed: $(terraform --version | head -n1)"
else
  echo "✗ Terraform is not installed. Please install Terraform."
  exit 1
fi

# Check Ansible
if command_exists ansible; then
  echo "✓ Ansible is installed: $(ansible --version | head -n1)"
else
  echo "✗ Ansible is not installed."
  read -p "Would you like to install Ansible now? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    pip3 install ansible
    echo "✓ Ansible installed: $(ansible --version | head -n1)"
  else
    echo "Please install Ansible and run this script again."
    exit 1
  fi
fi

echo
echo "All prerequisites met!"
echo

# Setup environment using Terraform
echo "Setting up environment with Terraform..."
cd "$PROJECT_ROOT/terraform" || exit 1
terraform init
terraform apply -auto-approve

# Setup application environment with Ansible
echo
echo "Setting up application environment with Ansible..."
cd "$PROJECT_ROOT/ansible" || exit 1
ansible-playbook -i inventory.ini setup.yml

# Deploy the application
echo
echo "Deploying the application..."
ansible-playbook -i inventory.ini deploy.yml

# Make all scripts executable
echo
echo "Making scripts executable..."
chmod +x "$PROJECT_ROOT/scripts/"*.sh
chmod +x "$PROJECT_ROOT/scripts/"*.py

echo
echo "=========================================================="
echo "Setup complete! Here's how to use the application:"
echo "=========================================================="
echo
echo "1. Start the application:"
echo "   ./scripts/start_app.sh"
echo
echo "2. Start the status dashboard:"
echo "   ./scripts/start_dashboard.sh"
echo
echo "3. Set up health check monitoring:"
echo "   ./scripts/setup_cron.sh"
echo
echo "4. Access the web application at http://localhost:5000"
echo
echo "5. View the status dashboard at http://localhost:8080"
echo
echo "6. To manually trigger a rollback:"
echo "   cd ansible && ansible-playbook -i inventory.ini rollback.yml"
echo
echo "Enjoy your DevOps pipeline!" 