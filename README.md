# Cloud GPU Setup Guide

## TL;DR
Quickly set up your [Vast.ai](https://vast.ai/) cloud GPU workstation with these
commands:
```bash
git clone https://github.com/muranski/cloud_gpu_setup /tmp/cloud_gpu_setup
GIT_USER_NAME=<your git user name> \
GIT_USER_EMAIL=<your git user email> \
/tmp/cloud_gpu_setup/vastai_setup.sh
source ~/.bashrc
```
Replace `<your git user email>` with your actual Git user email address.

## Introduction
This document will guide you through setting up your cloud GPU workstation on the
Vast.ai platform.

## Prerequisites
Ensure that you have:
- Provisioned a workstation on the [Vast.ai](https://vast.ai/) platform.
- Terminal access to your provisioned workstation.

## Detailed Setup Instructions

### 1. Clone the Setup Repository
Clone the `cloud_gpu_setup` repository to your workstation:
```bash
git clone https://github.com/muranski/cloud_gpu_setup /tmp/cloud_gpu_setup
```

### 2. Run the Setup Script
Execute the setup script with your Git user name and email:
```bash
GIT_USER_NAME=<your git user name> \
GIT_USER_EMAIL=<your git user email> \
/tmp/cloud_gpu_setup/vastai_setup.sh
```

### 3. Reload Shell Configuration
Apply the changes by reloading your shell configuration:
```bash
source ~/.bashrc
```
