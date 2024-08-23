#!/bin/bash

sudo apt-get update

sudo apt install nginx -y

sudo systemctl start nginx

sudo systemctl enable nginx

# Enter your Datadog API Key in below command.

DD_API_KEY=DATADOG_API_KEY DD_SITE="us5.datadoghq.com" bash -c "$(curl -L https://install.datadoghq.com/scripts/install_script_agent7.sh)"

# Creating configuration file of datadog agent's nginx's configuration file

sudo bash -c 'cat <<EOL >> /etc/datadog-agent/conf.d/nginx.d/conf.yaml

server {
    listen 80;
    server_name localhost;

    location /nginx_status {
        stub_status on;
        allow 127.0.0.1; # Only allow requests from localhost
        deny all;        # Deny all other addresses
    }
}
EOL'

sudo bash -c 'cat <<EOL >> /etc/datadog-agent/conf.d/nginx.d/conf.yaml
init_config:

instances:
  - nginx_status_url: http://localhost:80/nginx_status
    tags:
      - env:production
      - app:webserver
EOL'

# Enable logs

sudo bash -c 'cat <<EOL >> /etc/datadog-agent/datadog.yaml
logs_enabled: true
EOL'

# Restart Services

sudo systemctl reload nginx
sudo systemctl restart nginx
sudo service datadog-agent restart
