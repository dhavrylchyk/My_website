#! /bin/bash

# Add terrraform repo in pacage manager
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Update and upgrade pacages
sudo apt update && sudo apt install terraform

# Set env vars
export AWS_ACCESS_KEY_ID=AKIAXVCQJPRCB6F3PB74
export AWS_SECRET_ACCESS_KEY=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

# Init terraform
terraform init