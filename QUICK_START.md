# 🖥️ Server Monitor - Quick Start Guide

## What You Have
A complete Python GUI application for monitoring server availability with email alerts.

## Files Created
- `server_monitor.py` - Main application (GUI + monitoring logic)
- `setup_env.py` - Interactive SMTP configuration helper
- `demo_usage.py` - Demo script and testing suite
- `requirements.txt` - Python dependencies
- `env_config.example` - SMTP configuration template
- `SERVER_MONITOR_README.md` - Complete documentation

## Quick Start (5 minutes)

### 1. Setup Email Notifications
```bash
# Run the interactive setup
python setup_env.py
```
- Choose your email provider (Gmail, Outlook, Yahoo, etc.)
- Enter your credentials
- Test the email configuration

### 2. Run the Application
```bash
# Launch the GUI
python server_monitor.py
```

### 3. Add Servers & Start Monitoring
1. Enter server IPs in the input field (e.g., 8.8.8.8, google.com)
2. Click "Add Server"
3. Click "Start Monitoring" 
4. Watch real-time status updates with ✅/❌ indicators

## Features Delivered ✅

### 🖥️ GUI Interface
- [x] Tkinter-based modern interface
- [x] Input field for server IPs
- [x] Real-time status display
- [x] Activity logging
- [x] Settings dialog

### 🌐 Monitoring
- [x] Regular ping checks (configurable intervals)
- [x] Green ✅ for reachable servers
- [x] Red ❌ for unreachable servers
- [x] Response time measurement
- [x] Consecutive failure tracking

### 📧 Email Alerts
- [x] SMTP email notifications on failure
- [x] Environment variable configuration
- [x] Support for Gmail, Outlook, Yahoo, custom SMTP
- [x] Configurable failure thresholds
- [x] Test email functionality

### 🔧 Controls
- [x] Start/Stop monitoring buttons
- [x] Add/Remove servers
- [x] Settings configuration
- [x] Context menus
- [x] Persistent server storage

## Test Your Setup

### Option 1: Quick Demo
```bash
# Run the demo suite
python demo_usage.py
```

### Option 2: Manual Testing
1. Add `8.8.8.8` (Google DNS) - should be ✅ reachable
2. Add `127.0.0.1` (localhost) - should be ✅ reachable  
3. Add `192.168.999.999` (invalid IP) - should be ❌ unreachable
4. Click "Test Email" to verify notifications

## Configuration Examples

### Gmail Setup
```bash
SMTP_SERVER=smtp.gmail.com
SMTP_PORT=587
SMTP_USE_TLS=true
SMTP_USERNAME=your-email@gmail.com
SMTP_PASSWORD=your-app-password  # Generate in Google Account settings
SMTP_FROM=your-email@gmail.com
SMTP_TO=admin@company.com
```

### Outlook Setup
```bash
SMTP_SERVER=smtp.live.com
SMTP_PORT=587
SMTP_USE_TLS=true
SMTP_USERNAME=your-email@outlook.com
SMTP_PASSWORD=your-password
SMTP_FROM=your-email@outlook.com
SMTP_TO=admin@company.com
```

## Troubleshooting

### Email Not Working?
- Use `python setup_env.py` to reconfigure
- For Gmail: Enable 2FA and use app password
- Check spam/junk folders
- Use "Test Email" button to verify

### Servers Always Show Offline?
- Check firewall settings (ICMP/ping allowed)
- Test with known-good servers (8.8.8.8, 1.1.1.1)
- Some corporate networks block ping

### GUI Issues?
- Ensure tkinter is installed (`python -m tkinter`)
- Try running `python demo_usage.py` first

## Next Steps
1. Add your critical servers to monitor
2. Configure appropriate check intervals (30-300 seconds)
3. Set failure thresholds (3-5 failures before alert)
4. Test email notifications thoroughly
5. Consider running as a service for 24/7 monitoring

## Support
- Read `SERVER_MONITOR_README.md` for detailed documentation
- Run `python demo_usage.py` for interactive testing
- Check application logs in `server_monitor.log`

---
**Ready to monitor your servers? Run `python server_monitor.py` to get started!** 🚀 