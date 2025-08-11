#!/bin/bash
# Update package list
sudo apt update -y

# Install tmux and jq
sudo apt install -y tmux jq

# Install Apache2
sudo apt install -y apache2

# Enable and start Apache2
sudo systemctl enable apache2
sudo systemctl start apache2

# Simple check to see if Apache is running for troubleshooting/logs
# This output will go to serial console logs of the GCE instance
echo "Apache2 installation and startup script finished."
sudo systemctl status apache2 | head -n 5
