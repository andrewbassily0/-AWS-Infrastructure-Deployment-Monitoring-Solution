# 🖥️ Server Monitor Installation Guide

## Overview
The Server Monitor comes in two versions:
1. **GUI Version** (`server_monitor.py`) - Full-featured tkinter interface
2. **Console Version** (`server_monitor_console.py`) - Terminal-based interface

## System Requirements
- Python 3.7 or higher
- Linux, Windows, or macOS
- Network access for ping functionality
- SMTP access for email notifications

## Installation Options

### Option 1: GUI Version (Recommended)

#### Install tkinter (Linux)
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install python3-tk

# CentOS/RHEL/Fedora
sudo yum install tkinter
# or
sudo dnf install python3-tkinter

# Arch Linux
sudo pacman -S tk
```

#### Install tkinter (Windows)
```bash
# Usually included with Python installation
# If missing, reinstall Python with "tcl/tk and IDLE" option checked
```

#### Install tkinter (macOS)
```bash
# Usually included with Python installation
# If using Homebrew:
brew install python-tk
```

#### Verify tkinter installation
```bash
python3 -c "import tkinter; print('✅ Tkinter available')"
```

### Option 2: Console Version (No GUI Dependencies)

The console version works with any Python 3.7+ installation without additional dependencies.

```bash
# Test console version
python3 server_monitor_console.py
```

## Quick Setup

### 1. Download Files
```bash
# Download all server monitor files
# (server_monitor.py, server_monitor_console.py, setup_env.py, etc.)
```

### 2. Configure Email (Optional)
```bash
# Interactive configuration
python3 setup_env.py

# Or manually set environment variables
export SMTP_SERVER=smtp.gmail.com
export SMTP_PORT=587
export SMTP_USERNAME=your-email@gmail.com
export SMTP_PASSWORD=your-app-password
export SMTP_FROM=your-email@gmail.com
export SMTP_TO=admin@company.com
export SMTP_USE_TLS=true
```

### 3. Run the Application

#### GUI Version
```bash
python3 server_monitor.py
```

#### Console Version
```bash
python3 server_monitor_console.py
```

## Testing Your Installation

### Test Basic Functionality
```bash
# Test ping functionality
ping 8.8.8.8

# Test Python version
python3 --version

# Test email libraries
python3 -c "import smtplib; print('✅ Email libraries available')"
```

### Test with Demo
```bash
# Run comprehensive demo
python3 demo_usage.py
```

## Troubleshooting

### Common Issues

#### 1. "No module named 'tkinter'" Error
**Solution**: Install tkinter using the commands above for your OS.

**Alternative**: Use the console version instead:
```bash
python3 server_monitor_console.py
```

#### 2. "ping: command not found"
**Solution**: Install ping utility:
```bash
# Ubuntu/Debian
sudo apt-get install iputils-ping

# CentOS/RHEL
sudo yum install iputils

# Windows: Usually pre-installed
# macOS: Usually pre-installed
```

#### 3. Permission Denied for Ping
**Solution**: Run with appropriate permissions:
```bash
# Linux/macOS - may need sudo for some network operations
sudo python3 server_monitor.py

# Windows - run as Administrator if needed
```

#### 4. SMTP Authentication Errors
**Gmail Users**:
1. Enable 2-factor authentication
2. Generate app password: Google Account → Security → App passwords
3. Use app password instead of regular password

**Outlook Users**:
1. Enable 2-factor authentication
2. Use app password or regular password

#### 5. Firewall Issues
**Solution**: Ensure ICMP (ping) traffic is allowed:
```bash
# Linux - check iptables rules
sudo iptables -L

# Windows - check Windows Firewall
# Allow "File and Printer Sharing (Echo Request - ICMPv4-In)"
```

## Feature Comparison

| Feature | GUI Version | Console Version |
|---------|-------------|-----------------|
| Visual Interface | ✅ Modern tkinter GUI | ✅ Colored console |
| Server Management | ✅ Point & click | ✅ Menu-driven |
| Real-time Monitoring | ✅ Live updates | ✅ Live updates |
| Email Notifications | ✅ Full support | ✅ Full support |
| Status Dashboard | ✅ Graphical | ✅ Text-based |
| Configuration | ✅ GUI dialogs | ✅ Menu options |
| System Requirements | Requires tkinter | Python only |
| Remote Server Use | Limited | ✅ SSH-friendly |

## Recommended Usage

### GUI Version - Best for:
- Desktop environments
- Visual monitoring
- Interactive configuration
- Development/testing

### Console Version - Best for:
- Servers without GUI
- SSH connections
- Automated deployments
- Minimal resource usage
- Headless systems

## Advanced Installation

### Virtual Environment Setup
```bash
# Create virtual environment
python3 -m venv server_monitor_env

# Activate virtual environment
source server_monitor_env/bin/activate  # Linux/macOS
server_monitor_env\Scripts\activate     # Windows

# Install optional dependencies
pip install -r requirements.txt
```

### Systemd Service (Linux)
```bash
# Create service file
sudo nano /etc/systemd/system/server-monitor.service

[Unit]
Description=Server Monitor
After=network.target

[Service]
Type=simple
User=your-username
WorkingDirectory=/path/to/server_monitor
ExecStart=/usr/bin/python3 server_monitor_console.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target

# Enable and start service
sudo systemctl enable server-monitor
sudo systemctl start server-monitor
```

### Windows Service
```batch
# Use Task Scheduler or a service wrapper like NSSM
# Download NSSM from https://nssm.cc/
nssm install ServerMonitor python3 c:\path\to\server_monitor_console.py
```

## Environment Variables Reference

```bash
# Required for email notifications
SMTP_SERVER=smtp.gmail.com          # SMTP server address
SMTP_PORT=587                       # SMTP port (usually 587 or 465)
SMTP_USE_TLS=true                   # Use TLS encryption
SMTP_USERNAME=your-email@gmail.com  # Email username
SMTP_PASSWORD=your-app-password     # Email password (use app password for Gmail)
SMTP_FROM=your-email@gmail.com      # From address
SMTP_TO=admin@company.com           # Alert recipient

# Optional configuration
SERVER_CHECK_INTERVAL=30            # Check interval in seconds
SERVER_MAX_FAILURES=3               # Max failures before email alert
```

## Security Considerations

1. **Email Credentials**: Use app passwords, not regular passwords
2. **File Permissions**: Protect .env file with appropriate permissions
3. **Network Access**: Monitor only authorized servers
4. **User Privileges**: Run with minimum required permissions

## Performance Tuning

### Optimal Settings
```bash
# For monitoring 1-10 servers
SERVER_CHECK_INTERVAL=30
SERVER_MAX_FAILURES=3

# For monitoring 50+ servers
SERVER_CHECK_INTERVAL=60
SERVER_MAX_FAILURES=5

# For critical servers
SERVER_CHECK_INTERVAL=15
SERVER_MAX_FAILURES=2
```

## Support

### Getting Help
1. Check the log files: `server_monitor.log` or `server_monitor_console.log`
2. Run the demo: `python3 demo_usage.py`
3. Test basic functionality: `python3 -c "import subprocess; print(subprocess.run(['ping', '-c', '1', '8.8.8.8']))"`
4. Verify email configuration: Use the "Test Email" feature

### Common Command Line Tests
```bash
# Test ping
ping -c 1 8.8.8.8

# Test Python modules
python3 -c "import threading, subprocess, smtplib; print('✅ All modules available')"

# Test email sending
python3 -c "
import smtplib
from email.mime.text import MimeText
# Add your SMTP test code here
"
```

---

**Choose the version that best fits your environment and get started monitoring your servers!** 🚀 