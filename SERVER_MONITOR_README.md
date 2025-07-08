# Server Availability Monitor

A comprehensive GUI application for monitoring server availability with email alerts and real-time status tracking.

## Features

### 🖥️ **Graphical User Interface**
- Modern tkinter-based GUI with intuitive controls
- Real-time server status display with visual indicators
- Activity logging with timestamps
- Settings configuration dialog
- Context menus for server management

### 🌐 **Server Monitoring**
- Multi-server monitoring with configurable intervals
- Cross-platform ping functionality (Windows, Linux, macOS)
- Response time measurement in milliseconds
- Consecutive failure tracking
- Automatic server status updates

### 📧 **Email Notifications**
- SMTP-based email alerts for server failures
- Configurable failure thresholds
- Test email functionality
- Support for multiple email providers (Gmail, Outlook, Yahoo, custom SMTP)
- Environment variable configuration for security

### 🔧 **Advanced Features**
- Persistent server configuration (JSON storage)
- Configurable monitoring intervals
- Start/Stop monitoring controls
- Server import/export functionality
- Comprehensive logging system

## Installation

### Prerequisites
- Python 3.7 or higher
- Standard Python libraries (tkinter, threading, subprocess, etc.)

### Quick Start
1. Download the application files:
   ```bash
   # Clone or download the files
   git clone <repository> # or download individual files
   cd server-monitor
   ```

2. Install optional dependencies (recommended):
   ```bash
   pip install -r requirements.txt
   ```

3. Configure email settings (see Configuration section)

4. Run the application:
   ```bash
   python server_monitor.py
   ```

## Configuration

### SMTP Email Setup

#### Method 1: Environment Variables
Set the following environment variables:

**Windows (Command Prompt):**
```cmd
set SMTP_SERVER=smtp.gmail.com
set SMTP_PORT=587
set SMTP_USE_TLS=true
set SMTP_USERNAME=your-email@gmail.com
set SMTP_PASSWORD=your-app-password
set SMTP_FROM=your-email@gmail.com
set SMTP_TO=admin@company.com
```

**Windows (PowerShell):**
```powershell
$env:SMTP_SERVER="smtp.gmail.com"
$env:SMTP_PORT="587"
$env:SMTP_USE_TLS="true"
$env:SMTP_USERNAME="your-email@gmail.com"
$env:SMTP_PASSWORD="your-app-password"
$env:SMTP_FROM="your-email@gmail.com"
$env:SMTP_TO="admin@company.com"
```

**Linux/macOS:**
```bash
export SMTP_SERVER=smtp.gmail.com
export SMTP_PORT=587
export SMTP_USE_TLS=true
export SMTP_USERNAME=your-email@gmail.com
export SMTP_PASSWORD=your-app-password
export SMTP_FROM=your-email@gmail.com
export SMTP_TO=admin@company.com
```

#### Method 2: .env File
1. Copy the example configuration:
   ```bash
   cp env_config.example .env
   ```

2. Edit `.env` with your actual SMTP settings:
   ```bash
   nano .env  # or your preferred editor
   ```

### Email Provider Configuration

#### Gmail Setup
1. Enable 2-factor authentication on your Google account
2. Go to Google Account settings > Security > App passwords
3. Generate an app password for "Mail"
4. Use the generated password as `SMTP_PASSWORD`

```bash
SMTP_SERVER=smtp.gmail.com
SMTP_PORT=587
SMTP_USE_TLS=true
SMTP_USERNAME=your-email@gmail.com
SMTP_PASSWORD=your-16-character-app-password
```

#### Microsoft Outlook/Hotmail
```bash
SMTP_SERVER=smtp.live.com
SMTP_PORT=587
SMTP_USE_TLS=true
SMTP_USERNAME=your-email@outlook.com
SMTP_PASSWORD=your-password
```

#### Yahoo Mail
```bash
SMTP_SERVER=smtp.mail.yahoo.com
SMTP_PORT=587
SMTP_USE_TLS=true
SMTP_USERNAME=your-email@yahoo.com
SMTP_PASSWORD=your-app-password
```

#### Custom SMTP Server
```bash
SMTP_SERVER=mail.yourcompany.com
SMTP_PORT=587
SMTP_USE_TLS=true
SMTP_USERNAME=your-username
SMTP_PASSWORD=your-password
```

## Usage

### Adding Servers
1. Launch the application
2. Enter server IP address or hostname in the input field
3. Click "Add Server" or press Enter
4. Server appears in the status table with "Unknown" status

### Starting Monitoring
1. Add one or more servers to monitor
2. Click "Start Monitoring" button
3. Application begins ping checks at configured intervals
4. Status updates appear in real-time with visual indicators

### Status Indicators
- ✅ **Green Online**: Server is reachable
- ❌ **Red Offline**: Server is unreachable
- **Response Time**: Displayed in milliseconds for reachable servers
- **Consecutive Failures**: Counter for failed ping attempts

### Managing Servers
- **Right-click** on any server in the list for context menu
- **Remove Server**: Delete server from monitoring
- **Test Ping**: Perform immediate ping test
- **Clear All**: Remove all servers (with confirmation)

### Email Alerts
- Automatic email notifications sent after consecutive failures exceed threshold
- Default threshold: 3 consecutive failures
- Configurable via Settings dialog
- Test email functionality to verify SMTP configuration

### Settings Configuration
1. Click "Settings" button
2. Adjust monitoring parameters:
   - **Check Interval**: Time between ping checks (minimum 5 seconds)
   - **Max Failures**: Consecutive failures before email alert
3. Click "Save" to apply changes

## Application Architecture

### Core Components

#### ServerMonitor Class
- Main application controller
- GUI management and event handling
- Server data storage and persistence
- Monitoring thread coordination

#### Monitoring Loop
- Separate thread for non-blocking ping operations
- Configurable check intervals
- Automatic status updates
- Failure detection and alerting

#### Email System
- SMTP client with TLS support
- Configurable email templates
- Error handling and retry logic
- Test functionality for validation

#### Data Persistence
- JSON-based server configuration storage
- Automatic save/load on application start/stop
- Settings preservation across sessions

### File Structure
```
server-monitor/
├── server_monitor.py          # Main application file
├── requirements.txt           # Python dependencies
├── env_config.example         # SMTP configuration template
├── SERVER_MONITOR_README.md   # This documentation
├── servers.json              # Server configuration (auto-generated)
├── server_monitor.log        # Application log file (auto-generated)
└── .env                      # SMTP configuration (user-created)
```

## Troubleshooting

### Common Issues

#### Email Not Working
1. **Check SMTP Configuration**:
   - Verify all environment variables are set correctly
   - Use "Test Email" button to validate configuration
   - Check spam/junk folders for test emails

2. **Gmail Authentication Issues**:
   - Enable 2-factor authentication
   - Use app-specific password, not your regular password
   - Ensure "Less secure app access" is not required

3. **Corporate Email Issues**:
   - Contact IT department for SMTP server details
   - May require VPN connection for external SMTP access
   - Check firewall rules for SMTP ports

#### Ping/Connectivity Issues
1. **Firewall Blocking**:
   - Ensure ICMP traffic is allowed
   - Check local and network firewalls
   - Some servers disable ping responses

2. **Network Connectivity**:
   - Verify network connection
   - Test manual ping from command line
   - Check DNS resolution for hostnames

3. **Permission Issues**:
   - On some systems, ping requires elevated privileges
   - Run application as administrator if needed

#### GUI Issues
1. **Display Problems**:
   - Update tkinter if using older Python versions
   - Check display scaling settings
   - Try different themes or system fonts

2. **Responsiveness**:
   - Reduce check interval if GUI becomes sluggish
   - Limit number of monitored servers for better performance

### Log Files
- Application logs: `server_monitor.log`
- Contains detailed error messages and debugging information
- Rotated automatically to prevent excessive disk usage

### Performance Optimization
- **Recommended Settings**:
  - Check interval: 30-60 seconds for most use cases
  - Maximum servers: 50-100 for optimal performance
  - Max failures: 3-5 for balanced alerting

## Advanced Usage

### Command Line Arguments
The application can be extended to support command line arguments:

```python
# Example: Custom configuration file
python server_monitor.py --config custom_servers.json

# Example: Headless mode (no GUI)
python server_monitor.py --headless --servers server1,server2,server3
```

### API Integration
Extend the application with REST API endpoints for remote monitoring:

```python
# Example: Web dashboard integration
from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/api/servers')
def get_server_status():
    return jsonify(monitor.servers)
```

### Custom Notifications
Add support for additional notification channels:

```python
# Example: Slack integration
import requests

def send_slack_notification(server, status):
    webhook_url = os.getenv('SLACK_WEBHOOK_URL')
    payload = {
        'text': f'Server {server} is {status}',
        'channel': '#alerts'
    }
    requests.post(webhook_url, json=payload)
```

## Security Considerations

### Email Security
- Use app-specific passwords instead of regular passwords
- Store SMTP credentials in environment variables, not in code
- Consider using OAuth2 for enhanced security
- Encrypt email content for sensitive environments

### Network Security
- Monitor only servers you have permission to access
- Be aware that ping monitoring may trigger security alerts
- Use VPN connections for monitoring external servers
- Implement IP whitelisting for monitored servers

### Application Security
- Run with least privilege required
- Keep Python and dependencies updated
- Validate all user inputs
- Implement proper error handling

## Contributing

### Development Setup
1. Fork the repository
2. Create a virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # Linux/macOS
   venv\Scripts\activate     # Windows
   ```
3. Install development dependencies:
   ```bash
   pip install -r requirements.txt
   ```

### Code Standards
- Follow PEP 8 style guidelines
- Add type hints for new functions
- Include comprehensive docstrings
- Write unit tests for new features

### Feature Requests
- Server monitoring via HTTP/HTTPS checks
- Database connectivity monitoring
- Service-specific health checks
- Mobile app companion
- Web-based dashboard
- Integration with monitoring systems (Nagios, Zabbix)

## License

This application is provided as-is for educational and operational use. Please ensure compliance with your organization's security policies before deploying in production environments.

## Support

For technical support or feature requests:
1. Check the troubleshooting section above
2. Review application logs for error details
3. Test configuration with minimal setup
4. Contact your system administrator for network-related issues

---

**Version**: 1.0.0  
**Last Updated**: $(date +%Y-%m-%d)  
**Python Compatibility**: 3.7+  
**Platform Support**: Windows, Linux, macOS 