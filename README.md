# DevOps Pipeline Simulation Project

This project demonstrates a complete DevOps pipeline implementation in a local environment without using Docker or cloud services. It simulates the entire CI/CD process, from development to production deployment, with monitoring and automated rollbacks.

## Overview

![DevOps Workflow](docs/workflow_diagram.png)

This project implements a DevOps pipeline with the following components:

1. **Web Application**: A simple Flask application with form submission functionality
2. **Version Control**: Git-based workflow with main and dev branches
3. **Continuous Integration**: GitHub Actions workflow for automated testing
4. **Infrastructure as Code**: Terraform and Ansible for environment setup and configuration
5. **Continuous Deployment**: Blue-Green deployment strategy with rollback capability
6. **Monitoring & Health Check**: Automated health checks with logging
7. **Status Dashboard**: A real-time view of application health and deployment status

## Components

### 1. Web Application

A simple Flask application that:
- Provides a form to submit name and message
- Has a health check endpoint at `/health`
- Returns JSON responses
- Includes unit tests to verify functionality

### 2. Version Control Strategy

This project uses Git with a branching strategy:
- `main`: Production-ready code
- `dev`: Development code ready for testing

All features should be developed in feature branches and merged to `dev` via pull requests.

### 3. Continuous Integration

The CI pipeline is implemented using GitHub Actions (`.github/workflows/ci.yml`). It:
- Runs automatically on pushes to `main` and `dev` branches
- Executes all unit tests
- Performs basic linting
- Provides feedback on code quality

### 4. Infrastructure as Code

The project uses both Terraform and Ansible:

**Terraform** (`terraform/main.tf`):
- Creates the directory structure
- Verifies required tools are installed
- Sets up the basic project environment

**Ansible** (`ansible/`):
- `setup.yml`: Initializes the application environment
- `deploy.yml`: Manages the deployment process
- `rollback.yml`: Handles rollback if needed

### 5. Continuous Deployment

The deployment process follows a Blue-Green deployment strategy:
1. Tests are run in a staging environment
2. If tests pass, the application is deployed to production
3. A symlink switches traffic to the new version
4. The old version is preserved for potential rollbacks

### 6. Monitoring & Health Checks

Health monitoring includes:
- A health check endpoint (`/health`)
- A monitoring script that runs periodically 
- Logging of application status
- Automatic rollback capability if health checks fail

### 7. Status Dashboard

A web-based dashboard (`http://localhost:7070`) that shows:
- Current application status
- Deployment information
- Recent health check logs

## Setup and Usage

### Prerequisites

- Python 3.6 or higher
- pip (Python package manager)
- Ansible
- Terraform
- Git

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/zuzukobaladze/devops-project.git
   cd devops-project
   ```

2. Initialize the environment with Terraform:
   ```
   cd terraform
   terraform init
   terraform apply
   ```

3. Set up the application environment with Ansible:
   ```
   cd ../ansible
   ansible-playbook -i inventory.ini setup.yml
   ```

4. Deploy the application:
   ```
   ansible-playbook -i inventory.ini deploy.yml
   ```

5. Start the application:
   ```
   cd ..
   python active/app.py
   ```

6. Start the status dashboard:
   ```
   cd scripts
   python status_dashboard.py
   ```

7. Set up health check monitoring:
   ```
   ./scripts/setup_cron.sh
   ```

### Usage

- Access the web application at `http://localhost:3000`
- View the status dashboard at `http://localhost:7070`
- Health checks run automatically every 5 minutes
- To manually trigger a rollback: `cd ansible && ansible-playbook -i inventory.ini rollback.yml`

## Project Structure

```
devops-mid/
├── ansible/                # Ansible playbooks and inventory
│   ├── inventory.ini      # Inventory file
│   ├── setup.yml          # Environment setup playbook
│   ├── deploy.yml         # Deployment playbook
│   └── rollback.yml       # Rollback playbook
├── app/                    # Flask application
│   ├── app.py             # Main application file
│   ├── requirements.txt   # Python dependencies
│   ├── templates/         # HTML templates
│   │   └── index.html     # Main page template
│   └── test_app.py        # Unit tests
├── terraform/              # Terraform configuration
│   └── main.tf            # Infrastructure definition
├── scripts/                # Utility scripts
│   ├── health_check.sh    # Health monitoring script
│   ├── setup_cron.sh      # Cron job setup script
│   ├── start_app.sh       # Application startup script
│   ├── start_dashboard.sh # Dashboard startup script
│   └── status_dashboard.py # Status dashboard application
├── .github/                # GitHub configuration
│   └── workflows/         # GitHub Actions workflows
│       └── ci.yml         # CI pipeline definition
├── logs/                   # Log files (created at runtime)
├── production/             # Production environment (created at runtime)
├── staging/                # Staging environment (created at runtime)
├── backup/                 # Backup storage (created at runtime)
├── .gitignore             # Git ignore file
└── README.md              # Project documentation
```

## CI/CD and IaC Explanation

### CI/CD Process

1. **Continuous Integration**:
   - Developer pushes code to GitHub
   - GitHub Actions runs tests and linting
   - Results are reported back to GitHub

2. **Continuous Deployment**:
   - Code is deployed to staging environment
   - Tests are run in staging
   - If successful, code is deployed to production
   - Blue-Green switch redirects traffic to new version

### Infrastructure as Code

1. **Terraform** handles the initial environment setup:
   - Creates required directories
   - Verifies required tools are installed
   - Prepares the project structure

2. **Ansible** manages application deployment:
   - Installs dependencies
   - Configures the environment
   - Handles deployments and rollbacks
   - Ensures application health

This approach allows for reliable, repeatable deployments and environment setups.

## Implementation Screenshots and Verification

The following screenshots demonstrate the implementation and functionality of various components:

1. **Web Application**: The Flask application with form functionality running on localhost:3000
2. **CI Pipeline**: GitHub Actions CI running tests on push to main/dev branch
3. **Deployment Process**: Successful deployment using Ansible with Blue-Green strategy
4. **Status Dashboard**: The health monitoring dashboard showing application status on port 7070
5. **Health Checks**: Log output showing successful health checks and monitoring
6. **Passing Tests**: Test results showing all tests passing

These screenshots are included in the PDF report accompanying this project.