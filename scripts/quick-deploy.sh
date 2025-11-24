#!/bin/bash

echo " Quick deployment..."

cd /home/ubuntu/BellaTrix-v1
git pull origin main
pip3 install -r requirements.txt
sudo systemctl restart streamlit-BellaTrix-v1.service

echo " Deployment initiated. Check status with: sudo systemctl status streamlit-BellaTrix-v1.service"
