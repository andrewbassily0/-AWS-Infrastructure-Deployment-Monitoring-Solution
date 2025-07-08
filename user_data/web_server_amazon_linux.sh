#!/bin/bash

# Update system packages
yum update -y

# Install common packages
yum install -y \
    curl \
    wget \
    unzip \
    htop \
    awscli \
    amazon-cloudwatch-agent

# Configure timezone
timedatectl set-timezone UTC

# Install and configure web server based on type
if [ "${web_server_type}" == "nginx" ]; then
    echo "Installing Nginx..."
    amazon-linux-extras install nginx1 -y
    
    # Create a simple index page
    cat > /usr/share/nginx/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to Web Server</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        h1 { color: #333; }
        .info { background: #f0f0f0; padding: 20px; border-radius: 5px; margin-top: 20px; }
    </style>
</head>
<body>
    <h1>Welcome to Nginx Web Server</h1>
    <p>This is a web server running on Amazon Linux 2</p>
    <div class="info">
        <strong>Server Information:</strong><br>
        Hostname: \$(hostname)<br>
        IP Address: \$(hostname -I | cut -d' ' -f1)<br>
        Date: \$(date)<br>
        Web Server: Nginx<br>
        OS: Amazon Linux 2
    </div>
</body>
</html>
EOF
    
    # Start and enable Nginx
    systemctl start nginx
    systemctl enable nginx
    
    # Configure Nginx for better performance
    cat > /etc/nginx/conf.d/default.conf <<EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    
    root /usr/share/nginx/html;
    index index.html index.htm;
    
    server_name _;
    
    location / {
        try_files \$uri \$uri/ =404;
    }
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    
    # Logging
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
}
EOF
    
    # Test configuration and restart
    nginx -t && systemctl reload nginx
    
elif [ "${web_server_type}" == "apache" ]; then
    echo "Installing Apache..."
    yum install -y httpd
    
    # Create a simple index page
    cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to Web Server</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        h1 { color: #333; }
        .info { background: #f0f0f0; padding: 20px; border-radius: 5px; margin-top: 20px; }
    </style>
</head>
<body>
    <h1>Welcome to Apache Web Server</h1>
    <p>This is a web server running on Amazon Linux 2</p>
    <div class="info">
        <strong>Server Information:</strong><br>
        Hostname: \$(hostname)<br>
        IP Address: \$(hostname -I | cut -d' ' -f1)<br>
        Date: \$(date)<br>
        Web Server: Apache<br>
        OS: Amazon Linux 2
    </div>
</body>
</html>
EOF
    
    # Configure Apache
    cat > /etc/httpd/conf.d/security.conf <<EOF
# Security headers
Header always set X-Frame-Options "SAMEORIGIN"
Header always set X-Content-Type-Options "nosniff"
Header always set X-XSS-Protection "1; mode=block"

# Hide Apache version
ServerTokens Prod
ServerSignature Off
EOF
    
    # Start and enable Apache
    systemctl start httpd
    systemctl enable httpd
fi

# Configure CloudWatch agent
cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json <<EOF
{
    "metrics": {
        "namespace": "AWS/EC2",
        "metrics_collected": {
            "cpu": {
                "measurement": [
                    "cpu_usage_idle",
                    "cpu_usage_iowait",
                    "cpu_usage_user",
                    "cpu_usage_system"
                ],
                "metrics_collection_interval": 60
            },
            "disk": {
                "measurement": [
                    "used_percent"
                ],
                "metrics_collection_interval": 60,
                "resources": [
                    "*"
                ]
            },
            "mem": {
                "measurement": [
                    "mem_used_percent"
                ],
                "metrics_collection_interval": 60
            }
        }
    }
}
EOF

# Start CloudWatch agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    -a fetch-config \
    -m ec2 \
    -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
    -s

# Create a health check script
cat > /usr/local/bin/health-check.sh <<EOF
#!/bin/bash
curl -f http://localhost/ > /dev/null 2>&1
if [ \$? -eq 0 ]; then
    echo "Web server is healthy"
    exit 0
else
    echo "Web server is unhealthy"
    exit 1
fi
EOF

chmod +x /usr/local/bin/health-check.sh

# Set up log rotation
cat > /etc/logrotate.d/web-server <<EOF
/var/log/nginx/*.log /var/log/httpd/*.log {
    daily
    missingok
    rotate 52
    compress
    delaycompress
    notifempty
    create 0644 nginx nginx
    postrotate
        systemctl reload nginx > /dev/null 2>&1 || true
        systemctl reload httpd > /dev/null 2>&1 || true
    endscript
}
EOF

# Log installation completion
echo "Web server installation completed at $(date)" >> /var/log/user-data.log 