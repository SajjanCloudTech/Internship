#!/bin/bash
echo "Stopping existing PM2 processes..."
pm2 stop all || true
