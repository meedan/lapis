#!/bin/bash

dir=$(pwd)
cd $(dirname "${BASH_SOURCE[0]}")
cd ..

# Build
docker build -t meedan/%app_name% .

# Run
secret=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
docker run -d -p 3000:80 --name %app_name% -e SECRET_KEY_BASE=$secret meedan/%app_name%

echo
docker ps | grep '%app_name%'
echo

echo '-----------------------------------------------------------'
echo 'Now go to your browser and access http://localhost:3000/api'
echo '-----------------------------------------------------------'

