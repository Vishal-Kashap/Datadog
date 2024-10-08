#!/bin/bash

sudo apt-get update

sudo apt install apache2 -y

sudo systemctl start apache2

sudo systemctl enable apache2

# Datadog Agent installation on Ubuntu Server.
# Enter your Datadog API Key in below command.

DD_API_KEY=YOUR_DATADOG_API_KEY DD_SITE="datadoghq.com"  bash -c "$(curl -L https://install.datadoghq.com/scripts/install_script_agent7.sh)"

# Creating configuration file of datadog agent's apache's configuration file

sudo bash -c 'cat <<EOL >> /etc/datadog-agent/conf.d/apache.d/conf.yaml

init_config:

instances:

  - apache_status_url: http://localhost/server-status?auto

logs:
  - type: file
    path: /var/log/apache2/access.log
    source: apache
    service: apache
    sourcecategory: http_web_access

  - type: file
    path: /var/log/apache2/error.log
    source: apache
    service: apache
    sourcecategory: http_web_error
EOL'

# Set permissions to access logs of apache

sudo chmod -R 777 /var/log/apache2

# Enable logs

sudo bash -c 'cat <<EOL >> /etc/datadog-agent/datadog.yaml
logs_enabled: true
EOL'

# Restart Services

sudo systemctl reload apache2
sudo systemctl restart apache2
sudo service datadog-agent restart