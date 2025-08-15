#!/bin/bash
# Install UFW
sudo apt update
sudo apt install ufw -y

# Allow SSH
sudo ufw allow ssh

# Deny HTTP
sudo ufw deny http

# Enable UFW
sudo ufw --force enable

# Show status
sudo ufw status verbose
