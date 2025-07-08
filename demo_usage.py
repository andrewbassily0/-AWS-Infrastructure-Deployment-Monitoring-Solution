#!/usr/bin/env python3
"""
Server Monitor Demo Script
This script demonstrates how to use the server monitor application
and provides examples for testing and integration.
"""

import os
import sys
import time
import threading
from datetime import datetime

# Add the server monitor module to the path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

def demo_basic_usage():
    """Demo basic server monitoring functionality."""
    print("🖥️  Server Monitor - Basic Usage Demo")
    print("=" * 50)
    
    # Import tkinter and create root window
    try:
        import tkinter as tk
        from server_monitor import ServerMonitor
        
        print("✅ Successfully imported server monitor components")
        
        # Create root window
        root = tk.Tk()
        root.withdraw()  # Hide the main window for demo
        
        # Create monitor instance
        monitor = ServerMonitor(root)
        
        # Add some demo servers
        demo_servers = [
            "8.8.8.8",      # Google DNS - should be reachable
            "1.1.1.1",      # Cloudflare DNS - should be reachable  
            "127.0.0.1",    # Localhost - should be reachable
            "192.168.1.1",  # Common router IP - may or may not be reachable
        ]
        
        print("\n📡 Adding demo servers:")
        for server in demo_servers:
            monitor.servers[server] = {
                'status': None,
                'last_check': None,
                'response_time': 0,
                'failures': 0,
                'last_failure_email': None
            }
            print(f"   • {server}")
        
        # Test ping functionality
        print("\n🔍 Testing ping functionality:")
        for server in demo_servers:
            is_reachable, response_time = monitor.ping_server(server)
            status = "✅ Reachable" if is_reachable else "❌ Unreachable"
            time_info = f" ({response_time}ms)" if is_reachable else ""
            print(f"   {server}: {status}{time_info}")
        
        # Clean up
        root.destroy()
        print("\n✅ Basic functionality test completed successfully!")
        
    except ImportError as e:
        print(f"❌ Import error: {e}")
        print("💡 Make sure tkinter is installed and server_monitor.py is in the same directory")
    except Exception as e:
        print(f"❌ Error during demo: {e}")

def demo_email_configuration():
    """Demo email configuration testing."""
    print("\n📧 Email Configuration Demo")
    print("=" * 40)
    
    # Check for environment variables
    smtp_vars = [
        'SMTP_SERVER', 'SMTP_PORT', 'SMTP_USE_TLS',
        'SMTP_USERNAME', 'SMTP_PASSWORD', 'SMTP_FROM', 'SMTP_TO'
    ]
    
    print("Environment Variables Status:")
    missing_vars = []
    for var in smtp_vars:
        value = os.getenv(var)
        if value:
            display_value = value if var != 'SMTP_PASSWORD' else '*' * len(value)
            print(f"   ✅ {var}: {display_value}")
        else:
            print(f"   ❌ {var}: Not set")
            missing_vars.append(var)
    
    if missing_vars:
        print(f"\n⚠️  Missing environment variables: {', '.join(missing_vars)}")
        print("💡 Run 'python setup_env.py' to configure email settings")
    else:
        print("\n✅ All SMTP environment variables are configured!")
        
        # Test email configuration if all variables are set
        test_email = input("\nWould you like to test email configuration? (y/n) [n]: ").strip().lower()
        if test_email == 'y':
            test_smtp_connection()

def test_smtp_connection():
    """Test SMTP connection with current configuration."""
    try:
        import smtplib
        from email.mime.text import MIMEText
        from email.mime.multipart import MIMEMultipart
        
        print("\n🧪 Testing SMTP connection...")
        
        # Get configuration
        config = {
            'server': os.getenv('SMTP_SERVER'),
            'port': int(os.getenv('SMTP_PORT', '587')),
            'username': os.getenv('SMTP_USERNAME'),
            'password': os.getenv('SMTP_PASSWORD'),
            'from_email': os.getenv('SMTP_FROM'),
            'to_email': os.getenv('SMTP_TO'),
            'use_tls': os.getenv('SMTP_USE_TLS', 'true').lower() == 'true'
        }
        
        # Create test message
        msg = MimeMultipart()
        msg['From'] = config['from_email']
        msg['To'] = config['to_email']
        msg['Subject'] = "Server Monitor - Demo Test Email"
        
        body = f"""
This is a test email from the Server Monitor demo script.

Configuration Test Results:
- SMTP Server: {config['server']}:{config['port']}
- From: {config['from_email']}
- To: {config['to_email']}
- TLS: {config['use_tls']}
- Test Time: {datetime.now().strftime("%Y-%m-%d %H:%M:%S")}

If you received this email, your SMTP configuration is working correctly!
                 """.strip()
         
         msg.attach(MIMEText(body, 'plain'))
        
        # Send test email
        server = smtplib.SMTP(config['server'], config['port'])
        
        if config['use_tls']:
            server.starttls()
        
        server.login(config['username'], config['password'])
        server.send_message(msg)
        server.quit()
        
        print("✅ Test email sent successfully!")
        print(f"📧 Check {config['to_email']} for the test message.")
        
    except Exception as e:
        print(f"❌ SMTP test failed: {e}")
        print("💡 Common issues:")
        print("   - Check username/password")
        print("   - Verify app password for Gmail/Yahoo")
        print("   - Check firewall/network connectivity")
        print("   - Confirm SMTP server settings")

def demo_monitoring_simulation():
    """Simulate monitoring with fake servers to show GUI behavior."""
    print("\n🎯 Monitoring Simulation Demo")
    print("=" * 40)
    
    try:
        import tkinter as tk
        from server_monitor import ServerMonitor
        
        # Create and show the GUI
        root = tk.Tk()
        monitor = ServerMonitor(root)
        
        # Add demo servers automatically
        demo_servers = [
            "8.8.8.8",      # Google DNS
            "1.1.1.1",      # Cloudflare DNS
            "127.0.0.1",    # Localhost
            "httpbin.org",  # HTTP testing service
        ]
        
        print("Adding demo servers to monitor:")
        for server in demo_servers:
            monitor.servers[server] = {
                'status': None,
                'last_check': None,
                'response_time': 0,
                'failures': 0,
                'last_failure_email': None
            }
            
            # Add to GUI
            monitor.tree.insert('', tk.END, iid=server, values=(
                server, 'Unknown', 'Never', '-', '0'
            ))
            print(f"   • {server}")
        
        monitor.log_message("Demo servers added - ready for monitoring")
        monitor.log_message("Click 'Start Monitoring' to begin server checks")
        monitor.log_message("Use 'Test Email' to verify email configuration")
        
        print("\n🎉 GUI launched with demo servers!")
        print("💡 Instructions:")
        print("   1. Click 'Start Monitoring' to begin")
        print("   2. Watch the status indicators update")
        print("   3. Try the 'Test Email' button to verify notifications")
        print("   4. Use 'Settings' to adjust check intervals")
        print("   5. Right-click on servers for additional options")
        print("   6. Close the window to exit")
        
        # Start the GUI event loop
        root.mainloop()
        
    except ImportError as e:
        print(f"❌ Import error: {e}")
    except Exception as e:
        print(f"❌ Error during simulation: {e}")

def demo_command_line_monitoring():
    """Demo command-line monitoring without GUI."""
    print("\n⚡ Command-Line Monitoring Demo")
    print("=" * 40)
    
    try:
        import tkinter as tk
        from server_monitor import ServerMonitor
        
        # Create hidden root window for backend functionality
        root = tk.Tk()
        root.withdraw()
        
        monitor = ServerMonitor(root)
        
        # Test servers
        test_servers = ["8.8.8.8", "1.1.1.1", "127.0.0.1"]
        
        print("Testing servers:")
        for server in test_servers:
            is_reachable, response_time = monitor.ping_server(server)
            status = "✅ Online" if is_reachable else "❌ Offline"
            time_info = f" ({response_time}ms)" if is_reachable else ""
            print(f"   {server}: {status}{time_info}")
        
        # Simulate monitoring loop
        print("\n🔄 Simulating monitoring loop (10 seconds)...")
        for i in range(3):
            print(f"   Check {i+1}/3:")
            for server in test_servers:
                is_reachable, response_time = monitor.ping_server(server)
                status = "UP" if is_reachable else "DOWN"
                print(f"     {server}: {status}")
            time.sleep(3)
        
        print("✅ Command-line monitoring demo completed!")
        root.destroy()
        
    except Exception as e:
        print(f"❌ Error during command-line demo: {e}")

def show_system_info():
    """Display system information relevant to server monitoring."""
    print("\n🔧 System Information")
    print("=" * 30)
    
    import platform
    import subprocess
    
    print(f"Python Version: {sys.version}")
    print(f"Platform: {platform.system()} {platform.release()}")
    print(f"Architecture: {platform.machine()}")
    
    # Check for ping command
    try:
        if platform.system().lower() == "windows":
            result = subprocess.run(["ping", "-n", "1", "127.0.0.1"], 
                                  capture_output=True, text=True, timeout=3)
        else:
            result = subprocess.run(["ping", "-c", "1", "127.0.0.1"], 
                                  capture_output=True, text=True, timeout=3)
        
        if result.returncode == 0:
            print("✅ Ping command available")
        else:
            print("⚠️  Ping command returned non-zero exit code")
    except Exception as e:
        print(f"❌ Ping command test failed: {e}")
    
    # Check tkinter availability
    try:
        import tkinter
        print("✅ Tkinter GUI framework available")
    except ImportError:
        print("❌ Tkinter not available - GUI features disabled")
    
    # Check email libraries
    try:
        import smtplib
        from email.mime.text import MimeText
        print("✅ Email libraries available")
    except ImportError:
        print("❌ Email libraries not available - notifications disabled")

def main():
    """Main demo function."""
    print("🖥️  Server Availability Monitor - Demo & Test Suite")
    print("=" * 60)
    
    # Show system info first
    show_system_info()
    
    # Interactive demo menu
    while True:
        print("\n📋 Demo Options:")
        print("1. Basic Functionality Test")
        print("2. Email Configuration Test")
        print("3. GUI Monitoring Simulation")
        print("4. Command-Line Monitoring Demo")
        print("5. Exit")
        
        choice = input("\nSelect demo option (1-5): ").strip()
        
        if choice == "1":
            demo_basic_usage()
        elif choice == "2":
            demo_email_configuration()
        elif choice == "3":
            demo_monitoring_simulation()
        elif choice == "4":
            demo_command_line_monitoring()
        elif choice == "5":
            print("\n👋 Goodbye!")
            break
        else:
            print("❌ Invalid option. Please select 1-5.")

if __name__ == "__main__":
    main() 