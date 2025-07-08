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
    amazon-cloudwatch-agent \
    git

# Configure timezone
timedatectl set-timezone UTC

# Install Docker
echo "Installing Docker..."
yum install -y docker

# Start and enable Docker
systemctl start docker
systemctl enable docker

# Add ec2-user to docker group
usermod -aG docker ec2-user

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install Node.js (for application runtime)
echo "Installing Node.js..."
curl -sL https://rpm.nodesource.com/setup_lts.x | bash -
yum install -y nodejs

# Install Python and pip
yum install -y python3 python3-pip

# Install Java (OpenJDK)
yum install -y java-11-openjdk-devel

# Create application directory
mkdir -p /opt/app
chown ec2-user:ec2-user /opt/app

# Create a sample application
cat > /opt/app/app.js <<EOF
const express = require('express');
const app = express();
const port = ${app_port};

// Health check endpoint
app.get('/health', (req, res) => {
    res.json({ 
        status: 'healthy', 
        timestamp: new Date().toISOString(),
        hostname: require('os').hostname(),
        uptime: process.uptime()
    });
});

// Main application endpoint
app.get('/', (req, res) => {
    res.json({
        message: 'Application Server is running',
        hostname: require('os').hostname(),
        port: port,
        environment: 'production',
        timestamp: new Date().toISOString()
    });
});

// API endpoint
app.get('/api/status', (req, res) => {
    res.json({
        service: 'application-server',
        version: '1.0.0',
        status: 'running',
        hostname: require('os').hostname(),
        timestamp: new Date().toISOString()
    });
});

app.listen(port, '0.0.0.0', () => {
    console.log(\`Application server listening at http://0.0.0.0:\${port}\`);
});
EOF

# Create package.json
cat > /opt/app/package.json <<EOF
{
    "name": "application-server",
    "version": "1.0.0",
    "description": "Sample application server",
    "main": "app.js",
    "scripts": {
        "start": "node app.js",
        "dev": "node app.js"
    },
    "dependencies": {
        "express": "^4.18.2"
    }
}
EOF

# Create Dockerfile
cat > /opt/app/Dockerfile <<EOF
FROM node:18-alpine

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE ${app_port}

CMD ["npm", "start"]
EOF

# Create docker-compose.yml
cat > /opt/app/docker-compose.yml <<EOF
version: '3.8'

services:
  app:
    build: .
    ports:
      - "${app_port}:${app_port}"
    environment:
      - NODE_ENV=production
      - PORT=${app_port}
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:${app_port}/health"]
      interval: 30s
      timeout: 10s
      retries: 3
    volumes:
      - ./logs:/usr/src/app/logs
EOF

# Install npm dependencies
cd /opt/app
npm install

# Create systemd service for the application
cat > /etc/systemd/system/app-server.service <<EOF
[Unit]
Description=Application Server
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/opt/app
ExecStart=/usr/bin/node app.js
Restart=always
RestartSec=10
Environment=NODE_ENV=production
Environment=PORT=${app_port}

[Install]
WantedBy=multi-user.target
EOF

# Start the application service
systemctl daemon-reload
systemctl enable app-server
systemctl start app-server

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
    },
    "logs": {
        "logs_collected": {
            "files": {
                "collect_list": [
                    {
                        "file_path": "/var/log/app-server.log",
                        "log_group_name": "/aws/ec2/app-server",
                        "log_stream_name": "{instance_id}"
                    }
                ]
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

# Create health check script
cat > /usr/local/bin/health-check.sh <<EOF
#!/bin/bash
curl -f http://localhost:${app_port}/health > /dev/null 2>&1
if [ \$? -eq 0 ]; then
    echo "Application server is healthy"
    exit 0
else
    echo "Application server is unhealthy"
    exit 1
fi
EOF

chmod +x /usr/local/bin/health-check.sh

# Set up log rotation
cat > /etc/logrotate.d/app-server <<EOF
/var/log/app-server.log {
    daily
    missingok
    rotate 52
    compress
    delaycompress
    notifempty
    create 0644 ec2-user ec2-user
    postrotate
        systemctl reload app-server > /dev/null 2>&1 || true
    endscript
}
EOF

# Configure Docker daemon
cat > /etc/docker/daemon.json <<EOF
{
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "10m",
        "max-file": "3"
    },
    "storage-driver": "overlay2"
}
EOF

systemctl restart docker

# Set ownership
chown -R ec2-user:ec2-user /opt/app

# Log installation completion
echo "Application server installation completed at $(date)" >> /var/log/user-data.log 