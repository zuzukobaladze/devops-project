# Setting Up Git Repository

This document explains how to set up a Git repository for this project.

## GitHub Repository Setup

1. Create a new repository on GitHub
   - Go to [GitHub](https://github.com)
   - Click the "+" icon in the top right corner
   - Select "New repository"
   - Name your repository (e.g., "devops-pipeline")
   - Add a description
   - Choose public or private
   - Click "Create repository"

2. Connect your local repository to GitHub
   ```bash
   # If you've already initialized your local repository:
   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
   git push -u origin main
   ```

3. Working with branches
   ```bash
   # Create and switch to dev branch (already done in local setup)
   git checkout -b dev
   
   # Push dev branch to GitHub
   git push -u origin dev
   
   # To switch between branches
   git checkout main
   git checkout dev
   ```

4. Typical workflow
   ```bash
   # Create a feature branch from dev
   git checkout dev
   git checkout -b feature/new-feature
   
   # Make changes and commit
   git add .
   git commit -m "Add new feature"
   
   # Push the feature branch
   git push -u origin feature/new-feature
   
   # Then create a pull request on GitHub to merge into dev
   # After approval, merge into dev, then later merge dev into main
   ```

## GitLab Repository Setup

1. Create a new repository on GitLab
   - Go to [GitLab](https://gitlab.com)
   - Click the "New project" button
   - Select "Create blank project"
   - Name your repository
   - Add a description
   - Choose visibility level
   - Click "Create project"

2. Connect your local repository to GitLab
   ```bash
   # If you've already initialized your local repository:
   git remote add origin https://gitlab.com/YOUR_USERNAME/YOUR_REPO_NAME.git
   git push -u origin main
   ```

3. The branching strategy is the same as with GitHub.

## CI/CD Setup

Once you've pushed to your Git repository:

1. GitHub Actions CI will automatically run when you push to main or dev branches
   - The workflow is defined in `.github/workflows/ci.yml`
   - You can view the results in the "Actions" tab of your GitHub repository

2. If using GitLab, you'll need to add a `.gitlab-ci.yml` file similar to the GitHub Actions workflow.

## Cloning the Repository

To clone this repository to a new machine:

```bash
git clone https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
cd YOUR_REPO_NAME
./setup.sh
``` 