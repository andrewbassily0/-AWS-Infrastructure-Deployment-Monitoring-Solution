#!/usr/bin/env python3
"""
Server Availability Monitor
A GUI application for monitoring server availability with email alerts.

Features:
- Real-time ping monitoring of multiple servers
- Visual status indicators (Green ✅ / Red ❌)
- Email notifications on server failures
- Start/Stop monitoring controls
- Environment variable configuration for SMTP

Author: Infrastructure Team
Version: 1.0.0
"""

import tkinter as tk
from tkinter import ttk, scrolledtext, messagebox
import threading
import time
import subprocess
import platform
import os
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from datetime import datetime
import logging
from typing import Dict, List, Optional
import json

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('server_monitor.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)


class ServerMonitor:
    """Main class for server monitoring application."""
    
    def __init__(self, root):
        self.root = root
        self.root.title("Server Availability Monitor")
        self.root.geometry("800x600")
        self.root.resizable(True, True)
        
        # Monitoring state
        self.monitoring = False
        self.monitor_thread = None
        self.servers = {}  # {ip: {'status': bool, 'last_check': datetime, 'failures': int}}
        self.check_interval = 30  # seconds
        self.max_failures = 3  # Send email after this many consecutive failures
        
        # SMTP configuration from environment variables
        self.smtp_config = self.load_smtp_config()
        
        # Setup GUI
        self.setup_gui()
        
        # Load saved servers if exists
        self.load_servers()
        
        logger.info("Server Monitor initialized")
    
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
        
        # Validate required SMTP settings
        required_fields = ['smtp_username', 'smtp_password', 'smtp_from', 'smtp_to']
        missing_fields = [field for field in required_fields if not config[field]]
        
        if missing_fields:
            logger.warning(f"Missing SMTP configuration: {', '.join(missing_fields)}")
            messagebox.showwarning(
                "SMTP Configuration",
                f"Missing SMTP environment variables: {', '.join(missing_fields)}\n"
                "Email alerts will be disabled."
            )
        
        return config
    
    def setup_gui(self):
        """Setup the GUI components."""
        # Create main frame
        main_frame = ttk.Frame(self.root, padding="10")
        main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # Configure grid weights
        self.root.columnconfigure(0, weight=1)
        self.root.rowconfigure(0, weight=1)
        main_frame.columnconfigure(1, weight=1)
        main_frame.rowconfigure(3, weight=1)
        
        # Title
        title_label = ttk.Label(main_frame, text="Server Availability Monitor", 
                               font=('Arial', 16, 'bold'))
        title_label.grid(row=0, column=0, columnspan=3, pady=(0, 20))
        
        # Server input section
        input_frame = ttk.LabelFrame(main_frame, text="Add Server", padding="10")
        input_frame.grid(row=1, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=(0, 10))
        input_frame.columnconfigure(1, weight=1)
        
        ttk.Label(input_frame, text="Server IP/Hostname:").grid(row=0, column=0, sticky=tk.W, padx=(0, 10))
        
        self.server_entry = ttk.Entry(input_frame, width=30)
        self.server_entry.grid(row=0, column=1, sticky=(tk.W, tk.E), padx=(0, 10))
        self.server_entry.bind('<Return>', lambda e: self.add_server())
        
        ttk.Button(input_frame, text="Add Server", command=self.add_server).grid(row=0, column=2)
        
        # Control buttons
        control_frame = ttk.Frame(main_frame)
        control_frame.grid(row=2, column=0, columnspan=3, pady=(0, 10))
        
        self.start_button = ttk.Button(control_frame, text="Start Monitoring", 
                                      command=self.start_monitoring, style="Success.TButton")
        self.start_button.grid(row=0, column=0, padx=(0, 10))
        
        self.stop_button = ttk.Button(control_frame, text="Stop Monitoring", 
                                     command=self.stop_monitoring, state=tk.DISABLED, 
                                     style="Danger.TButton")
        self.stop_button.grid(row=0, column=1, padx=(0, 10))
        
        ttk.Button(control_frame, text="Clear All", command=self.clear_all_servers).grid(row=0, column=2, padx=(0, 10))
        ttk.Button(control_frame, text="Test Email", command=self.test_email).grid(row=0, column=3, padx=(0, 10))
        
        # Settings button
        ttk.Button(control_frame, text="Settings", command=self.show_settings).grid(row=0, column=4)
        
        # Server status section
        status_frame = ttk.LabelFrame(main_frame, text="Server Status", padding="10")
        status_frame.grid(row=3, column=0, columnspan=3, sticky=(tk.W, tk.E, tk.N, tk.S), pady=(0, 10))
        status_frame.columnconfigure(0, weight=1)
        status_frame.rowconfigure(0, weight=1)
        
        # Create treeview for server status
        columns = ('Server', 'Status', 'Last Check', 'Response Time', 'Failures')
        self.tree = ttk.Treeview(status_frame, columns=columns, show='headings', height=10)
        
        # Define column widths and headings
        self.tree.heading('Server', text='Server IP/Hostname')
        self.tree.heading('Status', text='Status')
        self.tree.heading('Last Check', text='Last Check')
        self.tree.heading('Response Time', text='Response Time (ms)')
        self.tree.heading('Failures', text='Consecutive Failures')
        
        self.tree.column('Server', width=200)
        self.tree.column('Status', width=100, anchor=tk.CENTER)
        self.tree.column('Last Check', width=150)
        self.tree.column('Response Time', width=120, anchor=tk.CENTER)
        self.tree.column('Failures', width=120, anchor=tk.CENTER)
        
        # Add scrollbar
        scrollbar = ttk.Scrollbar(status_frame, orient=tk.VERTICAL, command=self.tree.yview)
        self.tree.configure(yscrollcommand=scrollbar.set)
        
        self.tree.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        scrollbar.grid(row=0, column=1, sticky=(tk.N, tk.S))
        
        # Context menu for tree
        self.tree.bind("<Button-3>", self.show_context_menu)  # Right click
        
        # Log section
        log_frame = ttk.LabelFrame(main_frame, text="Activity Log", padding="10")
        log_frame.grid(row=4, column=0, columnspan=3, sticky=(tk.W, tk.E, tk.N, tk.S))
        log_frame.columnconfigure(0, weight=1)
        log_frame.rowconfigure(0, weight=1)
        
        self.log_text = scrolledtext.ScrolledText(log_frame, height=8, state=tk.DISABLED)
        self.log_text.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # Status bar
        self.status_var = tk.StringVar()
        self.status_var.set("Ready")
        status_bar = ttk.Label(main_frame, textvariable=self.status_var, relief=tk.SUNKEN)
        status_bar.grid(row=5, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=(10, 0))
        
        # Setup custom styles
        self.setup_styles()
        
        # Handle window closing
        self.root.protocol("WM_DELETE_WINDOW", self.on_closing)
    
    def setup_styles(self):
        """Setup custom styles for buttons."""
        style = ttk.Style()
        
        # Success button style (green)
        style.configure("Success.TButton", foreground="white")
        try:
            style.map("Success.TButton",
                     background=[('active', '#45a049'), ('!active', '#4CAF50')])
        except:
            pass  # Style might not be available on all platforms
        
        # Danger button style (red)
        style.configure("Danger.TButton", foreground="white")
        try:
            style.map("Danger.TButton",
                     background=[('active', '#d32f2f'), ('!active', '#f44336')])
        except:
            pass
    
    def add_server(self):
        """Add a server to the monitoring list."""
        server = self.server_entry.get().strip()
        if not server:
            messagebox.showwarning("Invalid Input", "Please enter a server IP or hostname.")
            return
        
        if server in self.servers:
            messagebox.showwarning("Duplicate Server", f"Server {server} is already being monitored.")
            return
        
        # Initialize server data
        self.servers[server] = {
            'status': None,
            'last_check': None,
            'response_time': 0,
            'failures': 0,
            'last_failure_email': None
        }
        
        # Add to treeview
        self.tree.insert('', tk.END, iid=server, values=(
            server, 'Unknown', 'Never', '-', '0'
        ))
        
        self.server_entry.delete(0, tk.END)
        self.log_message(f"Added server: {server}")
        self.save_servers()
    
    def remove_server(self, server):
        """Remove a server from monitoring."""
        if server in self.servers:
            del self.servers[server]
            self.tree.delete(server)
            self.log_message(f"Removed server: {server}")
            self.save_servers()
    
    def clear_all_servers(self):
        """Clear all servers from monitoring."""
        if messagebox.askyesno("Confirm", "Are you sure you want to remove all servers?"):
            self.servers.clear()
            self.tree.delete(*self.tree.get_children())
            self.log_message("All servers removed")
            self.save_servers()
    
    def start_monitoring(self):
        """Start the monitoring process."""
        if not self.servers:
            messagebox.showwarning("No Servers", "Please add at least one server to monitor.")
            return
        
        self.monitoring = True
        self.start_button.config(state=tk.DISABLED)
        self.stop_button.config(state=tk.NORMAL)
        self.status_var.set("Monitoring...")
        
        # Start monitoring thread
        self.monitor_thread = threading.Thread(target=self.monitor_loop, daemon=True)
        self.monitor_thread.start()
        
        self.log_message("Monitoring started")
    
    def stop_monitoring(self):
        """Stop the monitoring process."""
        self.monitoring = False
        self.start_button.config(state=tk.NORMAL)
        self.stop_button.config(state=tk.DISABLED)
        self.status_var.set("Ready")
        
        self.log_message("Monitoring stopped")
    
    def monitor_loop(self):
        """Main monitoring loop running in separate thread."""
        while self.monitoring:
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
            
            # Wait for next check interval
            for _ in range(self.check_interval):
                if not self.monitoring:
                    break
                time.sleep(1)
    
    def ping_server(self, server: str) -> tuple[bool, int]:
        """
        Ping a server and return (is_reachable, response_time_ms).
        
        Args:
            server: IP address or hostname to ping
            
        Returns:
            Tuple of (is_reachable: bool, response_time: int)
        """
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
        """Update server status in GUI and data structures."""
        current_time = datetime.now()
        
        # Update server data
        prev_status = self.servers[server]['status']
        self.servers[server]['status'] = is_reachable
        self.servers[server]['last_check'] = current_time
        self.servers[server]['response_time'] = response_time
        
        if is_reachable:
            # Reset failure count on successful ping
            self.servers[server]['failures'] = 0
            status_text = "✅ Online"
            status_color = "green"
        else:
            # Increment failure count
            self.servers[server]['failures'] += 1
            status_text = "❌ Offline"
            status_color = "red"
        
        # Update treeview in main thread
        self.root.after(0, self._update_treeview_item, server, status_text, 
                       current_time.strftime("%H:%M:%S"), response_time, 
                       self.servers[server]['failures'], status_color)
        
        # Log status change
        if prev_status is not None and prev_status != is_reachable:
            status_change = "came online" if is_reachable else "went offline"
            self.root.after(0, self.log_message, f"Server {server} {status_change}")
    
    def _update_treeview_item(self, server: str, status: str, last_check: str, 
                             response_time: int, failures: int, color: str):
        """Update treeview item in main thread."""
        try:
            response_text = f"{response_time}" if response_time > 0 else "-"
            self.tree.item(server, values=(
                server, status, last_check, response_text, failures
            ))
            
            # Set row color based on status
            if color == "green":
                self.tree.item(server, tags=('online',))
            else:
                self.tree.item(server, tags=('offline',))
        except tk.TclError:
            # Item might have been deleted
            pass
    
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
This is an automated message from Server Availability Monitor.
            """.strip()
            
            msg.attach(MIMEText(body, 'plain'))
            
            # Send email
            server_smtp = smtplib.SMTP(self.smtp_config['smtp_server'], self.smtp_config['smtp_port'])
            
            if self.smtp_config['smtp_use_tls']:
                server_smtp.starttls()
            
            server_smtp.login(self.smtp_config['smtp_username'], self.smtp_config['smtp_password'])
            server_smtp.send_message(msg)
            server_smtp.quit()
            
            self.root.after(0, self.log_message, f"Email alert sent for {server}")
            
        except Exception as e:
            logger.error(f"Failed to send email for {server}: {e}")
            self.root.after(0, self.log_message, f"Failed to send email for {server}: {str(e)}")
    
    def test_email(self):
        """Test email configuration by sending a test message."""
        if not self.is_smtp_configured():
            messagebox.showerror("SMTP Error", "SMTP is not properly configured. Please check your environment variables.")
            return
        
        def send_test():
            try:
                msg = MimeMultipart()
                msg['From'] = self.smtp_config['smtp_from']
                msg['To'] = self.smtp_config['smtp_to']
                msg['Subject'] = "Server Monitor - Test Email"
                
                body = f"""
This is a test email from Server Availability Monitor.

Configuration:
- SMTP Server: {self.smtp_config['smtp_server']}:{self.smtp_config['smtp_port']}
- From: {self.smtp_config['smtp_from']}
- To: {self.smtp_config['smtp_to']}
- TLS: {self.smtp_config['smtp_use_tls']}

Time: {datetime.now().strftime("%Y-%m-%d %H:%M:%S")}

If you received this email, the SMTP configuration is working correctly.
                """.strip()
                
                msg.attach(MIMEText(body, 'plain'))
                
                server_smtp = smtplib.SMTP(self.smtp_config['smtp_server'], self.smtp_config['smtp_port'])
                
                if self.smtp_config['smtp_use_tls']:
                    server_smtp.starttls()
                
                server_smtp.login(self.smtp_config['smtp_username'], self.smtp_config['smtp_password'])
                server_smtp.send_message(msg)
                server_smtp.quit()
                
                self.root.after(0, lambda: messagebox.showinfo("Email Test", "Test email sent successfully!"))
                self.root.after(0, self.log_message, "Test email sent successfully")
                
            except Exception as e:
                self.root.after(0, lambda: messagebox.showerror("Email Test Failed", f"Failed to send test email:\n{str(e)}"))
                self.root.after(0, self.log_message, f"Test email failed: {str(e)}")
        
        # Send in separate thread to avoid blocking GUI
        threading.Thread(target=send_test, daemon=True).start()
    
    def show_settings(self):
        """Show settings dialog."""
        SettingsDialog(self.root, self)
    
    def show_context_menu(self, event):
        """Show context menu for server list."""
        item = self.tree.identify_row(event.y)
        if item:
            self.tree.selection_set(item)
            
            context_menu = tk.Menu(self.root, tearoff=0)
            context_menu.add_command(label="Remove Server", 
                                   command=lambda: self.remove_server(item))
            context_menu.add_separator()
            context_menu.add_command(label="Test Ping", 
                                   command=lambda: self.test_ping(item))
            
            try:
                context_menu.tk_popup(event.x_root, event.y_root)
            finally:
                context_menu.grab_release()
    
    def test_ping(self, server: str):
        """Test ping for a specific server."""
        def ping_test():
            is_reachable, response_time = self.ping_server(server)
            status = "Reachable" if is_reachable else "Unreachable"
            time_text = f" ({response_time}ms)" if is_reachable else ""
            
            self.root.after(0, lambda: messagebox.showinfo(
                "Ping Test", 
                f"Server: {server}\nStatus: {status}{time_text}"
            ))
        
        threading.Thread(target=ping_test, daemon=True).start()
    
    def log_message(self, message: str):
        """Add message to activity log."""
        timestamp = datetime.now().strftime("%H:%M:%S")
        log_entry = f"[{timestamp}] {message}\n"
        
        self.log_text.config(state=tk.NORMAL)
        self.log_text.insert(tk.END, log_entry)
        self.log_text.see(tk.END)
        self.log_text.config(state=tk.DISABLED)
        
        logger.info(message)
    
    def save_servers(self):
        """Save server list to file."""
        try:
            servers_data = {
                'servers': list(self.servers.keys()),
                'check_interval': self.check_interval,
                'max_failures': self.max_failures
            }
            
            with open('servers.json', 'w') as f:
                json.dump(servers_data, f, indent=2)
        except Exception as e:
            logger.error(f"Failed to save servers: {e}")
    
    def load_servers(self):
        """Load server list from file."""
        try:
            if os.path.exists('servers.json'):
                with open('servers.json', 'r') as f:
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
                    
                    self.tree.insert('', tk.END, iid=server, values=(
                        server, 'Unknown', 'Never', '-', '0'
                    ))
                
                if self.servers:
                    self.log_message(f"Loaded {len(self.servers)} servers from saved configuration")
        except Exception as e:
            logger.error(f"Failed to load servers: {e}")
    
    def on_closing(self):
        """Handle application closing."""
        if self.monitoring:
            self.stop_monitoring()
        
        self.save_servers()
        self.root.destroy()


class SettingsDialog:
    """Settings dialog for configuring monitoring parameters."""
    
    def __init__(self, parent, monitor):
        self.monitor = monitor
        
        # Create dialog window
        self.dialog = tk.Toplevel(parent)
        self.dialog.title("Settings")
        self.dialog.geometry("400x300")
        self.dialog.resizable(False, False)
        self.dialog.transient(parent)
        self.dialog.grab_set()
        
        # Center the dialog
        self.dialog.geometry("+%d+%d" % (
            parent.winfo_rootx() + 50,
            parent.winfo_rooty() + 50
        ))
        
        self.setup_dialog()
    
    def setup_dialog(self):
        """Setup the settings dialog."""
        main_frame = ttk.Frame(self.dialog, padding="20")
        main_frame.pack(fill=tk.BOTH, expand=True)
        
        # Monitoring settings
        ttk.Label(main_frame, text="Monitoring Settings", font=('Arial', 12, 'bold')).pack(anchor=tk.W, pady=(0, 10))
        
        # Check interval
        interval_frame = ttk.Frame(main_frame)
        interval_frame.pack(fill=tk.X, pady=5)
        ttk.Label(interval_frame, text="Check Interval (seconds):").pack(side=tk.LEFT)
        self.interval_var = tk.StringVar(value=str(self.monitor.check_interval))
        ttk.Entry(interval_frame, textvariable=self.interval_var, width=10).pack(side=tk.RIGHT)
        
        # Max failures
        failures_frame = ttk.Frame(main_frame)
        failures_frame.pack(fill=tk.X, pady=5)
        ttk.Label(failures_frame, text="Max Failures for Email Alert:").pack(side=tk.LEFT)
        self.failures_var = tk.StringVar(value=str(self.monitor.max_failures))
        ttk.Entry(failures_frame, textvariable=self.failures_var, width=10).pack(side=tk.RIGHT)
        
        # SMTP settings
        ttk.Separator(main_frame, orient=tk.HORIZONTAL).pack(fill=tk.X, pady=20)
        ttk.Label(main_frame, text="SMTP Configuration", font=('Arial', 12, 'bold')).pack(anchor=tk.W, pady=(0, 10))
        
        smtp_info = ttk.Label(main_frame, text="SMTP settings are configured via environment variables:", 
                             font=('Arial', 9))
        smtp_info.pack(anchor=tk.W)
        
        smtp_vars = [
            "SMTP_SERVER", "SMTP_PORT", "SMTP_USERNAME", "SMTP_PASSWORD",
            "SMTP_FROM", "SMTP_TO", "SMTP_USE_TLS"
        ]
        
        for var in smtp_vars:
            ttk.Label(main_frame, text=f"• {var}", font=('Arial', 8)).pack(anchor=tk.W, padx=20)
        
        # Buttons
        button_frame = ttk.Frame(main_frame)
        button_frame.pack(side=tk.BOTTOM, fill=tk.X, pady=(20, 0))
        
        ttk.Button(button_frame, text="Cancel", command=self.dialog.destroy).pack(side=tk.RIGHT, padx=(10, 0))
        ttk.Button(button_frame, text="Save", command=self.save_settings).pack(side=tk.RIGHT)
    
    def save_settings(self):
        """Save settings and close dialog."""
        try:
            # Validate and save interval
            interval = int(self.interval_var.get())
            if interval < 5:
                messagebox.showerror("Invalid Value", "Check interval must be at least 5 seconds.")
                return
            
            # Validate and save max failures
            max_failures = int(self.failures_var.get())
            if max_failures < 1:
                messagebox.showerror("Invalid Value", "Max failures must be at least 1.")
                return
            
            # Update monitor settings
            self.monitor.check_interval = interval
            self.monitor.max_failures = max_failures
            self.monitor.save_servers()
            
            messagebox.showinfo("Settings", "Settings saved successfully!")
            self.dialog.destroy()
            
        except ValueError:
            messagebox.showerror("Invalid Value", "Please enter valid numeric values.")


def create_env_example():
    """Create example environment configuration file."""
    env_content = """# Server Monitor SMTP Configuration
# Copy this file to .env and update with your actual values

# SMTP Server Settings
SMTP_SERVER=smtp.gmail.com
SMTP_PORT=587
SMTP_USE_TLS=true

# SMTP Authentication
SMTP_USERNAME=your-email@gmail.com
SMTP_PASSWORD=your-app-password

# Email Addresses
SMTP_FROM=your-email@gmail.com
SMTP_TO=admin@company.com

# Gmail App Password Instructions:
# 1. Enable 2-factor authentication on your Google account
# 2. Go to Google Account settings > Security > App passwords
# 3. Generate an app password for "Mail"
# 4. Use the generated password as SMTP_PASSWORD

# For other email providers, adjust SMTP_SERVER and SMTP_PORT accordingly:
# - Outlook: smtp.live.com:587
# - Yahoo: smtp.mail.yahoo.com:587
# - Custom SMTP: your-smtp-server.com:587
"""
    
    with open('.env.example', 'w') as f:
        f.write(env_content)


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
    """Main function to run the application."""
    # Create example environment file
    create_env_example()
    
    # Load environment variables from .env file
    load_env_file()
    
    # Configure treeview tag colors
    root = tk.Tk()
    style = ttk.Style(root)
    
    # Configure tags for online/offline status
    try:
        style.configure("Treeview", rowheight=25)
    except:
        pass
    
    # Create and run application
    app = ServerMonitor(root)
    
    # Configure treeview tags after creation
    app.tree.tag_configure('online', background='#e8f5e8')
    app.tree.tag_configure('offline', background='#fde8e8')
    
    try:
        root.mainloop()
    except KeyboardInterrupt:
        logger.info("Application interrupted by user")
    except Exception as e:
        logger.error(f"Application error: {e}")
        messagebox.showerror("Application Error", f"An unexpected error occurred:\n{str(e)}")


if __name__ == "__main__":
    main() 