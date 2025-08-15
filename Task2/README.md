# Task 2 - Basic Firewall Configuration with UFW

## Objective
Configure a basic firewall to allow SSH and deny HTTP traffic using UFW.

## Steps
1. Installed UFW:
   ```bash
   sudo apt install ufw -y
2.Allowed SSH:
sudo ufw allow ssh
3.Denied HTTP:
sudo ufw deny http
4.Enabled UFW:
sudo ufw enable
