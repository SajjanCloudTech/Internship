#!/bin/bash
echo "Restarting applications with PM2..."
pm2 restart all
pm2 save
