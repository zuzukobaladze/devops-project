# DevOps Pipeline Simulation Project - Final Report

## Project Overview

This report provides documentation and evidence of the successful implementation of a complete DevOps pipeline simulation in a local environment. The project demonstrates the application of DevOps principles and practices without relying on Docker or cloud services.

## Components Implemented

1. Web Application (Flask)
2. Version Control (Git)
3. Continuous Integration (GitHub Actions)
4. Infrastructure as Code (Terraform and Ansible)
5. Continuous Deployment with Blue-Green strategy
6. Monitoring & Health Checks
7. Status Dashboard

## Implementation Evidence

### Screenshot 1: Web Application Running
[Insert screenshot of the web application running at http://localhost:5000]

**Description**: The Flask application running locally, showing the form for submitting name and message. The application provides a dynamic form that processes user input and returns JSON responses.

### Screenshot 2: Unit Tests Passing
[Insert screenshot of successful test results]

**Description**: All unit tests for the Flask application are passing. The tests verify the functionality of the health endpoint and the form submission process.

### Screenshot 3: GitHub Actions CI Pipeline
[Insert screenshot of GitHub Actions workflow running]

**Description**: GitHub Actions CI pipeline running successfully after pushing code to the repository. The pipeline automatically runs tests and linting on the codebase.

### Screenshot 4: Terraform Infrastructure Setup
[Insert screenshot of Terraform apply output]

**Description**: Terraform successfully creating the required infrastructure for the application environment. This includes directory structure creation and dependency verification.

### Screenshot 5: Ansible Deployment
[Insert screenshot of Ansible deployment output]

**Description**: Ansible deploying the application using the Blue-Green deployment strategy. The playbook tests the application in staging before promoting it to production.

### Screenshot 6: Status Dashboard
[Insert screenshot of the status dashboard at http://localhost:8080]

**Description**: The status dashboard showing the current health of the application, deployment information, and recent health check logs. This provides real-time monitoring of the application.

### Screenshot 7: Health Check Logs
[Insert screenshot of health check logs]

**Description**: The health check script running successfully and logging the application's health status. This demonstrates the monitoring capabilities and potential for automatic rollbacks.

## Tools and Technologies Used

- **Programming Language**: Python 3
- **Web Framework**: Flask
- **Testing**: pytest
- **Version Control**: Git
- **CI/CD**: GitHub Actions
- **Infrastructure as Code**: Terraform, Ansible
- **Monitoring**: Custom health check scripts and dashboard

## Challenges and Solutions

[Briefly describe 1-2 challenges faced during implementation and how they were resolved]

## Conclusion

This project successfully demonstrates a complete DevOps pipeline implementation in a local environment. It showcases various DevOps practices including CI/CD, Infrastructure as Code, automated testing, monitoring, and blue-green deployment strategies. The implementation provides a foundation for understanding DevOps principles and can be extended to incorporate additional features or cloud services in the future.

## Repository Link

GitHub Repository: [https://github.com/zuzukobaladze/devops-project](https://github.com/zuzukobaladze/devops-project) 