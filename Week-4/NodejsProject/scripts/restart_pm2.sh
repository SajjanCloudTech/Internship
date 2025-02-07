#!/bin/bash
export NVM_DIR="$HOME/.nvm"
source ~/.nvm/nvm.sh

# Reload PM2 processes
sudo -u root pm2 reload all

# Save PM2 process list (optional)
sudo -u root pm2 save
