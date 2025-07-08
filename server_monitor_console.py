#!/usr/bin/env python3
"""
Server Availability Monitor - Console Version
A console-based application for monitoring server availability with email alerts.
No GUI dependencies required - works on any Python installation.

Features:
- Real-time ping monitoring of multiple servers
- Email notifications on server failures
- Console-based interface with colors
- Start/Stop monitoring controls
- Environment variable configuration for SMTP
- Persistent server configuration

Author: Infrastructure Team
Version: 1.0.0
"""

import os
import sys
import time
import threading
import subprocess
import platform
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from datetime import datetime
import logging
import json
import signal
from typing import Dict, List, Optional

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('server_monitor_console.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

# ANSI color codes for console output
class Colors:
    GREEN = '\033[92m'
    RED = '\033[91m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    MAGENTA = '\033[95m'
    CYAN = '\033[96m'
    WHITE = '\033[97m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'
    RESET = '\033[0m'

class ConsoleServerMonitor:
    """Console-based server monitoring application."""
    
    def __init__(self):
        self.monitoring = False
        self.monitor_thread = None
        self.servers = {}  # {ip: {'status': bool, 'last_check': datetime, 'failures': int}}
        self.check_interval = 30  # seconds
        self.max_failures = 3  # Send email after this many consecutive failures
        
        # SMTP configuration from environment variables
        self.smtp_config = self.load_smtp_config()
        
        # Setup signal handler for graceful shutdown
        signal.signal(signal.SIGINT, self.signal_handler)
        
        logger.info("Console Server Monitor initialized")
    
    def load_smtp_config(self) -> Dict[str, str]:
        """Load SMTP configuration from environment variables."""
        config = {
            'smtp_server': os.getenv('SMTP_SERVER', 'smtp.gmail.com'),
            'smtp_port': int(os.getenv('SMTP_PORT', '587')),
            'smtp_username': os.getenv('SMTP_USERNAME', ''),
            'smtp_password': os.getenv('SMTP_PASSWORD', ''),
            'smtp_from': os.getenv('SMTP_FROM', ''),
            'smtp_to': os.getenv('SMTP_TO', ''),
            'smtp_use_tls': os.getenv('SMTP_USE_TLS', 'true').lower() == 'true'
        }
        
        return config
    
    def signal_handler(self, signum, frame):
        """Handle Ctrl+C gracefully."""
        print(f"\n{Colors.YELLOW}📡 Stopping monitoring...{Colors.RESET}")
        self.monitoring = False
        if self.monitor_thread and self.monitor_thread.is_alive():
            self.monitor_thread.join(timeout=5)
        self.save_servers()
        print(f"{Colors.GREEN}✅ Monitoring stopped. Configuration saved.{Colors.RESET}")
        sys.exit(0)
    
    def print_header(self):
        """Print application header."""
        print(f"\n{Colors.CYAN}{'='*60}{Colors.RESET}")
        print(f"{Colors.BOLD}{Colors.CYAN}🖥️  Server Availability Monitor - Console Version{Colors.RESET}")
        print(f"{Colors.CYAN}{'='*60}{Colors.RESET}")
    
    def print_menu(self):
        """Print main menu options."""
        print(f"\n{Colors.BOLD}📋 Menu Options:{Colors.RESET}")
        print(f"{Colors.GREEN}1.{Colors.RESET} Add Server")
        print(f"{Colors.GREEN}2.{Colors.RESET} Remove Server")
        print(f"{Colors.GREEN}3.{Colors.RESET} List Servers")
        print(f"{Colors.GREEN}4.{Colors.RESET} Start Monitoring")
        print(f"{Colors.GREEN}5.{Colors.RESET} Stop Monitoring")
        print(f"{Colors.GREEN}6.{Colors.RESET} Test Email")
        print(f"{Colors.GREEN}7.{Colors.RESET} Settings")
        print(f"{Colors.GREEN}8.{Colors.RESET} Status Dashboard")
        print(f"{Colors.GREEN}9.{Colors.RESET} Exit")
    
    def add_server(self):
        """Add a server to the monitoring list."""
        server = input(f"\n{Colors.CYAN}Enter server IP or hostname: {Colors.RESET}").strip()
        
        if not server:
            print(f"{Colors.RED}❌ Invalid input. Please enter a server IP or hostname.{Colors.RESET}")
            return
        
        if server in self.servers:
            print(f"{Colors.YELLOW}⚠️  Server {server} is already being monitored.{Colors.RESET}")
            return
        
        # Initialize server data
        self.servers[server] = {
            'status': None,
            'last_check': None,
            'response_time': 0,
            'failures': 0,
            'last_failure_email': None
        }
        
        print(f"{Colors.GREEN}✅ Added server: {server}{Colors.RESET}")
        self.save_servers()
    
    def remove_server(self):
        """Remove a server from monitoring."""
        if not self.servers:
            print(f"{Colors.RED}❌ No servers to remove.{Colors.RESET}")
            return
        
        print(f"\n{Colors.CYAN}Current servers:{Colors.RESET}")
        for i, server in enumerate(self.servers.keys(), 1):
            print(f"{Colors.GREEN}{i}.{Colors.RESET} {server}")
        
        try:
            choice = input(f"\n{Colors.CYAN}Enter number to remove (or 'cancel'): {Colors.RESET}").strip()
            if choice.lower() == 'cancel':
                return
            
            index = int(choice) - 1
            servers_list = list(self.servers.keys())
            
            if 0 <= index < len(servers_list):
                server = servers_list[index]
                del self.servers[server]
                print(f"{Colors.GREEN}✅ Removed server: {server}{Colors.RESET}")
                self.save_servers()
            else:
                print(f"{Colors.RED}❌ Invalid selection.{Colors.RESET}")
        except ValueError:
            print(f"{Colors.RED}❌ Invalid input. Please enter a number.{Colors.RESET}")
    
    def list_servers(self):
        """Display all servers and their status."""
        if not self.servers:
            print(f"{Colors.RED}❌ No servers configured.{Colors.RESET}")
            return
        
        print(f"\n{Colors.BOLD}📊 Server Status:{Colors.RESET}")
        print(f"{Colors.CYAN}{'='*80}{Colors.RESET}")
        
        for server, data in self.servers.items():
            status = data['status']
            last_check = data['last_check']
            response_time = data['response_time']
            failures = data['failures']
            
            if status is None:
                status_text = f"{Colors.YELLOW}❓ Unknown{Colors.RESET}"
            elif status:
                status_text = f"{Colors.GREEN}✅ Online{Colors.RESET}"
            else:
                status_text = f"{Colors.RED}❌ Offline{Colors.RESET}"
            
            last_check_text = last_check.strftime("%H:%M:%S") if last_check else "Never"
            response_text = f"{response_time}ms" if response_time > 0 else "-"
            
            print(f"{Colors.BOLD}{server:<20}{Colors.RESET} {status_text:<20} "
                  f"Last: {last_check_text:<10} Time: {response_text:<10} "
                  f"Failures: {failures}")
    
    def start_monitoring(self):
        """Start the monitoring process."""
        if not self.servers:
            print(f"{Colors.RED}❌ No servers configured. Add servers first.{Colors.RESET}")
            return
        
        if self.monitoring:
            print(f"{Colors.YELLOW}⚠️  Monitoring is already running.{Colors.RESET}")
            return
        
        self.monitoring = True
        print(f"{Colors.GREEN}🚀 Starting monitoring...{Colors.RESET}")
        
        # Start monitoring thread
        self.monitor_thread = threading.Thread(target=self.monitor_loop, daemon=True)
        self.monitor_thread.start()
        
        print(f"{Colors.GREEN}✅ Monitoring started with {len(self.servers)} servers{Colors.RESET}")
        print(f"{Colors.CYAN}💡 Press Ctrl+C to stop monitoring{Colors.RESET}")
    
    def stop_monitoring(self):
        """Stop the monitoring process."""
        if not self.monitoring:
            print(f"{Colors.YELLOW}⚠️  Monitoring is not running.{Colors.RESET}")
            return
        
        self.monitoring = False
        print(f"{Colors.YELLOW}🛑 Stopping monitoring...{Colors.RESET}")
        
        if self.monitor_thread and self.monitor_thread.is_alive():
            self.monitor_thread.join(timeout=5)
        
        print(f"{Colors.GREEN}✅ Monitoring stopped.{Colors.RESET}")
    
    def monitor_loop(self):
        """Main monitoring loop running in separate thread."""
        while self.monitoring:
            print(f"\n{Colors.CYAN}🔍 Checking servers... {datetime.now().strftime('%H:%M:%S')}{Colors.RESET}")
            
            for server in list(self.servers.keys()):
                if not self.monitoring:
                    break
                
                # Perform ping check
                is_reachable, response_time = self.ping_server(server)
                
                # Update server status
                self.update_server_status(server, is_reachable, response_time)
                
                # Check for failures and send email if needed
                if not is_reachable:
                    self.handle_server_failure(server)
            
            # Display summary
            self.print_monitoring_summary()
            
            # Wait for next check interval
            for i in range(self.check_interval):
                if not self.monitoring:
                    break
                time.sleep(1)
    
    def ping_server(self, server: str) -> tuple[bool, int]:
        """Ping a server and return (is_reachable, response_time_ms)."""
        try:
            # Determine ping command based on platform
            if platform.system().lower() == "windows":
                cmd = ["ping", "-n", "1", "-w", "3000", server]
            else:
                cmd = ["ping", "-c", "1", "-W", "3", server]
            
            start_time = time.time()
            result = subprocess.run(cmd, capture_output=True, text=True, timeout=5)
            end_time = time.time()
            
            if result.returncode == 0:
                response_time = int((end_time - start_time) * 1000)
                return True, response_time
            else:
                return False, 0
                
        except (subprocess.TimeoutExpired, subprocess.SubprocessError, FileNotFoundError) as e:
            logger.warning(f"Ping failed for {server}: {e}")
            return False, 0
    
    def update_server_status(self, server: str, is_reachable: bool, response_time: int):
        """Update server status in data structures."""
        current_time = datetime.now()
        
        # Update server data
        prev_status = self.servers[server]['status']
        self.servers[server]['status'] = is_reachable
        self.servers[server]['last_check'] = current_time
        self.servers[server]['response_time'] = response_time
        
        if is_reachable:
            # Reset failure count on successful ping
            self.servers[server]['failures'] = 0
            status_text = f"{Colors.GREEN}✅ Online{Colors.RESET}"
        else:
            # Increment failure count
            self.servers[server]['failures'] += 1
            status_text = f"{Colors.RED}❌ Offline{Colors.RESET}"
        
        # Print status update
        time_info = f" ({response_time}ms)" if response_time > 0 else ""
        print(f"   {server}: {status_text}{time_info}")
        
        # Log status change
        if prev_status is not None and prev_status != is_reachable:
            status_change = "came online" if is_reachable else "went offline"
            print(f"{Colors.YELLOW}🔄 Server {server} {status_change}{Colors.RESET}")
    
    def handle_server_failure(self, server: str):
        """Handle server failure and send email if needed."""
        server_data = self.servers[server]
        
        # Send email after max_failures consecutive failures
        if (server_data['failures'] >= self.max_failures and 
            self.is_smtp_configured() and
            server_data['last_failure_email'] != server_data['failures']):
            
            self.send_failure_email(server, server_data['failures'])
            server_data['last_failure_email'] = server_data['failures']
    
    def is_smtp_configured(self) -> bool:
        """Check if SMTP is properly configured."""
        required_fields = ['smtp_username', 'smtp_password', 'smtp_from', 'smtp_to']
        return all(self.smtp_config.get(field) for field in required_fields)
    
    def send_failure_email(self, server: str, failure_count: int):
        """Send email notification for server failure."""
        try:
            # Create message
            msg = MimeMultipart()
            msg['From'] = self.smtp_config['smtp_from']
            msg['To'] = self.smtp_config['smtp_to']
            msg['Subject'] = f"Server Alert: {server} is unreachable"
            
            # Email body
            body = f"""
Server Monitoring Alert

Server: {server}
Status: UNREACHABLE
Consecutive Failures: {failure_count}
Time: {datetime.now().strftime("%Y-%m-%d %H:%M:%S")}

Please investigate the server connectivity issue.

---
This is an automated message from Console Server Monitor.
            """.strip()
            
            msg.attach(MIMEText(body, 'plain'))
            
            # Send email
            server_smtp = smtplib.SMTP(self.smtp_config['smtp_server'], self.smtp_config['smtp_port'])
            
            if self.smtp_config['smtp_use_tls']:
                server_smtp.starttls()
            
            server_smtp.login(self.smtp_config['smtp_username'], self.smtp_config['smtp_password'])
            server_smtp.send_message(msg)
            server_smtp.quit()
            
            print(f"{Colors.GREEN}📧 Email alert sent for {server}{Colors.RESET}")
            
        except Exception as e:
            logger.error(f"Failed to send email for {server}: {e}")
            print(f"{Colors.RED}❌ Failed to send email for {server}: {str(e)}{Colors.RESET}")
    
    def test_email(self):
        """Test email configuration by sending a test message."""
        if not self.is_smtp_configured():
            print(f"{Colors.RED}❌ SMTP is not properly configured.{Colors.RESET}")
            print(f"{Colors.CYAN}💡 Configure using environment variables or run setup_env.py{Colors.RESET}")
            return
        
        try:
            msg = MimeMultipart()
            msg['From'] = self.smtp_config['smtp_from']
            msg['To'] = self.smtp_config['smtp_to']
            msg['Subject'] = "Console Server Monitor - Test Email"
            
            body = f"""
This is a test email from Console Server Monitor.

Configuration:
- SMTP Server: {self.smtp_config['smtp_server']}:{self.smtp_config['smtp_port']}
- From: {self.smtp_config['smtp_from']}
- To: {self.smtp_config['smtp_to']}
- TLS: {self.smtp_config['smtp_use_tls']}

Time: {datetime.now().strftime("%Y-%m-%d %H:%M:%S")}

If you received this email, the SMTP configuration is working correctly.
            """.strip()
            
            msg.attach(MIMEText(body, 'plain'))
            
            server = smtplib.SMTP(self.smtp_config['smtp_server'], self.smtp_config['smtp_port'])
            
            if self.smtp_config['smtp_use_tls']:
                server.starttls()
            
            server.login(self.smtp_config['smtp_username'], self.smtp_config['smtp_password'])
            server.send_message(msg)
            server.quit()
            
            print(f"{Colors.GREEN}✅ Test email sent successfully!{Colors.RESET}")
            print(f"{Colors.CYAN}📧 Check {self.smtp_config['smtp_to']} for the test message.{Colors.RESET}")
            
        except Exception as e:
            print(f"{Colors.RED}❌ Email test failed: {str(e)}{Colors.RESET}")
    
    def show_settings(self):
        """Display and modify settings."""
        print(f"\n{Colors.BOLD}⚙️  Current Settings:{Colors.RESET}")
        print(f"{Colors.CYAN}{'='*40}{Colors.RESET}")
        print(f"Check Interval: {self.check_interval} seconds")
        print(f"Max Failures: {self.max_failures}")
        print(f"SMTP Server: {self.smtp_config['smtp_server']}")
        print(f"SMTP Port: {self.smtp_config['smtp_port']}")
        print(f"SMTP Username: {self.smtp_config['smtp_username']}")
        print(f"SMTP From: {self.smtp_config['smtp_from']}")
        print(f"SMTP To: {self.smtp_config['smtp_to']}")
        print(f"SMTP TLS: {self.smtp_config['smtp_use_tls']}")
        
        print(f"\n{Colors.BOLD}Change Settings:{Colors.RESET}")
        print(f"{Colors.GREEN}1.{Colors.RESET} Check Interval")
        print(f"{Colors.GREEN}2.{Colors.RESET} Max Failures")
        print(f"{Colors.GREEN}3.{Colors.RESET} Back to Main Menu")
        
        choice = input(f"\n{Colors.CYAN}Select option: {Colors.RESET}").strip()
        
        if choice == "1":
            try:
                interval = int(input(f"Enter new check interval (seconds) [{self.check_interval}]: ").strip() or self.check_interval)
                if interval >= 5:
                    self.check_interval = interval
                    print(f"{Colors.GREEN}✅ Check interval updated to {interval} seconds{Colors.RESET}")
                    self.save_servers()
                else:
                    print(f"{Colors.RED}❌ Interval must be at least 5 seconds{Colors.RESET}")
            except ValueError:
                print(f"{Colors.RED}❌ Invalid input. Please enter a number.{Colors.RESET}")
        
        elif choice == "2":
            try:
                failures = int(input(f"Enter new max failures [{self.max_failures}]: ").strip() or self.max_failures)
                if failures >= 1:
                    self.max_failures = failures
                    print(f"{Colors.GREEN}✅ Max failures updated to {failures}{Colors.RESET}")
                    self.save_servers()
                else:
                    print(f"{Colors.RED}❌ Max failures must be at least 1{Colors.RESET}")
            except ValueError:
                print(f"{Colors.RED}❌ Invalid input. Please enter a number.{Colors.RESET}")
    
    def print_monitoring_summary(self):
        """Print a summary of current monitoring status."""
        if not self.servers:
            return
        
        online_count = sum(1 for s in self.servers.values() if s['status'] is True)
        offline_count = sum(1 for s in self.servers.values() if s['status'] is False)
        unknown_count = sum(1 for s in self.servers.values() if s['status'] is None)
        
        print(f"{Colors.BOLD}📊 Summary:{Colors.RESET} "
              f"{Colors.GREEN}Online: {online_count}{Colors.RESET} | "
              f"{Colors.RED}Offline: {offline_count}{Colors.RESET} | "
              f"{Colors.YELLOW}Unknown: {unknown_count}{Colors.RESET}")
    
    def status_dashboard(self):
        """Show real-time status dashboard."""
        print(f"\n{Colors.BOLD}📊 Real-time Status Dashboard{Colors.RESET}")
        print(f"{Colors.CYAN}Press Ctrl+C to return to main menu{Colors.RESET}")
        
        try:
            while True:
                # Clear screen (works on most terminals)
                os.system('clear' if os.name == 'posix' else 'cls')
                
                print(f"{Colors.BOLD}📊 Server Status Dashboard - {datetime.now().strftime('%H:%M:%S')}{Colors.RESET}")
                print(f"{Colors.CYAN}{'='*80}{Colors.RESET}")
                
                if not self.servers:
                    print(f"{Colors.RED}❌ No servers configured{Colors.RESET}")
                    time.sleep(2)
                    continue
                
                # Print server status
                for server, data in self.servers.items():
                    status = data['status']
                    last_check = data['last_check']
                    response_time = data['response_time']
                    failures = data['failures']
                    
                    if status is None:
                        status_text = f"{Colors.YELLOW}❓ Unknown{Colors.RESET}"
                    elif status:
                        status_text = f"{Colors.GREEN}✅ Online{Colors.RESET}"
                    else:
                        status_text = f"{Colors.RED}❌ Offline{Colors.RESET}"
                    
                    last_check_text = last_check.strftime("%H:%M:%S") if last_check else "Never"
                    response_text = f"{response_time}ms" if response_time > 0 else "-"
                    
                    print(f"{Colors.BOLD}{server:<25}{Colors.RESET} {status_text:<20} "
                          f"Last: {last_check_text:<10} Time: {response_text:<10} "
                          f"Failures: {failures}")
                
                # Print summary
                print(f"\n{Colors.CYAN}{'-'*80}{Colors.RESET}")
                self.print_monitoring_summary()
                
                monitoring_status = f"{Colors.GREEN}Running{Colors.RESET}" if self.monitoring else f"{Colors.RED}Stopped{Colors.RESET}"
                print(f"Monitoring: {monitoring_status} | Interval: {self.check_interval}s | Max Failures: {self.max_failures}")
                
                time.sleep(2)
                
        except KeyboardInterrupt:
            print(f"\n{Colors.CYAN}Returning to main menu...{Colors.RESET}")
    
    def save_servers(self):
        """Save server list to file."""
        try:
            servers_data = {
                'servers': list(self.servers.keys()),
                'check_interval': self.check_interval,
                'max_failures': self.max_failures
            }
            
            with open('servers_console.json', 'w') as f:
                json.dump(servers_data, f, indent=2)
        except Exception as e:
            logger.error(f"Failed to save servers: {e}")
    
    def load_servers(self):
        """Load server list from file."""
        try:
            if os.path.exists('servers_console.json'):
                with open('servers_console.json', 'r') as f:
                    data = json.load(f)
                
                self.check_interval = data.get('check_interval', 30)
                self.max_failures = data.get('max_failures', 3)
                
                for server in data.get('servers', []):
                    self.servers[server] = {
                        'status': None,
                        'last_check': None,
                        'response_time': 0,
                        'failures': 0,
                        'last_failure_email': None
                    }
                
                if self.servers:
                    print(f"{Colors.GREEN}✅ Loaded {len(self.servers)} servers from saved configuration{Colors.RESET}")
        except Exception as e:
            logger.error(f"Failed to load servers: {e}")
    
    def run(self):
        """Main application loop."""
        self.print_header()
        
        # Load saved servers
        self.load_servers()
        
        # Check SMTP configuration
        if not self.is_smtp_configured():
            print(f"{Colors.YELLOW}⚠️  SMTP is not configured. Email alerts will be disabled.{Colors.RESET}")
            print(f"{Colors.CYAN}💡 Run 'python setup_env.py' to configure email notifications{Colors.RESET}")
        
        while True:
            try:
                self.print_menu()
                choice = input(f"\n{Colors.CYAN}Select option (1-9): {Colors.RESET}").strip()
                
                if choice == "1":
                    self.add_server()
                elif choice == "2":
                    self.remove_server()
                elif choice == "3":
                    self.list_servers()
                elif choice == "4":
                    self.start_monitoring()
                elif choice == "5":
                    self.stop_monitoring()
                elif choice == "6":
                    self.test_email()
                elif choice == "7":
                    self.show_settings()
                elif choice == "8":
                    self.status_dashboard()
                elif choice == "9":
                    print(f"{Colors.GREEN}👋 Goodbye!{Colors.RESET}")
                    if self.monitoring:
                        self.stop_monitoring()
                    self.save_servers()
                    break
                else:
                    print(f"{Colors.RED}❌ Invalid option. Please select 1-9.{Colors.RESET}")
                    
            except KeyboardInterrupt:
                print(f"\n{Colors.YELLOW}📡 Stopping application...{Colors.RESET}")
                if self.monitoring:
                    self.stop_monitoring()
                self.save_servers()
                print(f"{Colors.GREEN}✅ Application stopped. Configuration saved.{Colors.RESET}")
                break
            except Exception as e:
                print(f"{Colors.RED}❌ Error: {str(e)}{Colors.RESET}")
                logger.error(f"Application error: {e}")

def load_env_file():
    """Load environment variables from .env file if it exists."""
    env_file = '.env'
    if os.path.exists(env_file):
        with open(env_file, 'r') as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith('#') and '=' in line:
                    key, value = line.split('=', 1)
                    os.environ[key.strip()] = value.strip()

def main():
    """Main function to run the console application."""
    # Load environment variables from .env file
    load_env_file()
    
    # Create and run application
    app = ConsoleServerMonitor()
    
    try:
        app.run()
    except KeyboardInterrupt:
        print(f"\n{Colors.GREEN}✅ Application interrupted by user{Colors.RESET}")
    except Exception as e:
        print(f"{Colors.RED}❌ Application error: {str(e)}{Colors.RESET}")
        logger.error(f"Application error: {e}")

if __name__ == "__main__":
    main() 