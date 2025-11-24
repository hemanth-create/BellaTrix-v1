#!/bin/bash

# Systemd Service Setup Script for Streamlit BellaTrix-v1 App
# This script sets up Streamlit as a systemd service for automatic restarts

set -e

echo " Setting up systemd service for Streamlit BellaTrix-v1 App..."

# Check if running as root or with sudo
if [ "$EUID" -ne 0 ]; then 
    echo "  This script needs sudo privileges. Please run with sudo."
    echo "Usage: sudo ./scripts/setup-systemd.sh"
    exit 1
fi

PROJECT_DIR="/home/ubuntu/BellaTrix-v1"
SERVICE_FILE="/etc/systemd/system/streamlit-BellaTrix-v1.service"

# Check if project directory exists
if [ ! -d "$PROJECT_DIR" ]; then
    echo " Project directory not found: $PROJECT_DIR"
    exit 1
fi

# Check if service file exists in project
if [ ! -f "$PROJECT_DIR/streamlit-BellaTrix-v1.service" ]; then
    echo " Service file not found: $PROJECT_DIR/streamlit-BellaTrix-v1.service"
    exit 1
fi

# Copy service file
echo " Copying service file..."
cp "$PROJECT_DIR/streamlit-BellaTrix-v1.service" "$SERVICE_FILE"

# Reload systemd
echo " Reloading systemd daemon..."
systemctl daemon-reload

# Enable service (start on boot)
echo " Enabling service (will start on boot)..."
systemctl enable streamlit-BellaTrix-v1.service

# Check if service is already running
if systemctl is-active --quiet streamlit-BellaTrix-v1.service; then
    echo "  Service is already running. Restarting..."
    systemctl restart streamlit-BellaTrix-v1.service
else
    echo " Starting service..."
    systemctl start streamlit-BellaTrix-v1.service
fi

# Wait a moment
sleep 3

# Check status
echo ""
echo " Service Status:"
systemctl status streamlit-BellaTrix-v1.service --no-pager -l

echo ""
echo " Systemd service setup complete!"
echo ""
echo " Useful commands:"
echo "   Start:   sudo systemctl start streamlit-BellaTrix-v1.service"
echo "   Stop:    sudo systemctl stop streamlit-BellaTrix-v1.service"
echo "   Restart: sudo systemctl restart streamlit-BellaTrix-v1.service"
echo "   Status:  sudo systemctl status streamlit-BellaTrix-v1.service"
echo "   Logs:    sudo journalctl -u streamlit-BellaTrix-v1.service -f"
echo ""

