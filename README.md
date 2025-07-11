<h1 class="code-line" data-line-start=0 data-line-end=1 ><a id="_AWS_Infrastructure_Deployment__Monitoring_Solution_0"></a>🏗️ AWS Infrastructure Deployment &amp; Monitoring Solution</h1>
<p class="has-line-data" data-line-start="2" data-line-end="6"><a href="https://www.terraform.io/"><img src="https://img.shields.io/badge/Terraform-v1.5+-623CE4?style=for-the-badge&amp;logo=terraform&amp;logoColor=white" alt="Terraform"></a><br>
<a href="https://aws.amazon.com/"><img src="https://img.shields.io/badge/AWS-Cloud-FF9900?style=for-the-badge&amp;logo=amazon-aws&amp;logoColor=white" alt="AWS"></a><br>
<a href="https://www.python.org/"><img src="https://img.shields.io/badge/Python-3.7+-3776AB?style=for-the-badge&amp;logo=python&amp;logoColor=white" alt="Python"></a><br>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge" alt="License"></a></p>
<p class="has-line-data" data-line-start="7" data-line-end="8">A comprehensive, production-ready AWS infrastructure solution combining Infrastructure as Code (Terraform) with automated server monitoring. This project delivers a complete 3-tier architecture with high availability, security, and compliance features.</p>
<h2 class="code-line" data-line-start=9 data-line-end=10 ><a id="_Table_of_Contents_9"></a>📋 Table of Contents</h2>
<ul>
<li class="has-line-data" data-line-start="11" data-line-end="12"><a href="#-project-overview">🎯 Project Overview</a></li>
<li class="has-line-data" data-line-start="12" data-line-end="13"><a href="#-architecture-summary">🏛️ Architecture Summary</a></li>
<li class="has-line-data" data-line-start="13" data-line-end="14"><a href="#-terraform-project-structure">📁 Terraform Project Structure</a></li>
<li class="has-line-data" data-line-start="14" data-line-end="15"><a href="#-resource-list">🛠️ Resource List</a></li>
<li class="has-line-data" data-line-start="15" data-line-end="16"><a href="#-security--compliance">🔐 Security &amp; Compliance</a></li>
<li class="has-line-data" data-line-start="16" data-line-end="17"><a href="#-backup--disaster-recovery">🔄 Backup &amp; Disaster Recovery</a></li>
<li class="has-line-data" data-line-start="17" data-line-end="18"><a href="#-automation-script-usage">🤖 Automation Script Usage</a></li>
<li class="has-line-data" data-line-start="18" data-line-end="19"><a href="#-monitoring-and-alerts">📊 Monitoring and Alerts</a></li>
<li class="has-line-data" data-line-start="19" data-line-end="20"><a href="#-cost-estimation-guidance">💰 Cost Estimation Guidance</a></li>
<li class="has-line-data" data-line-start="20" data-line-end="21"><a href="#-quick-start">🚀 Quick Start</a></li>
<li class="has-line-data" data-line-start="21" data-line-end="23"><a href="#-documentation">📚 Documentation</a></li>
</ul>
<h2 class="code-line" data-line-start=23 data-line-end=24 ><a id="_Project_Overview_23"></a>🎯 Project Overview</h2>
<p class="has-line-data" data-line-start="25" data-line-end="26">This solution provides a complete AWS infrastructure deployment with automated monitoring capabilities, designed for production workloads requiring high availability, security, and compliance.</p>
<h3 class="code-line" data-line-start=27 data-line-end=28 ><a id="Key_Features_27"></a><strong>Key Features</strong></h3>
<ul>
<li class="has-line-data" data-line-start="28" data-line-end="29"><strong>Infrastructure as Code</strong>: Complete Terraform configuration for AWS resources</li>
<li class="has-line-data" data-line-start="29" data-line-end="30"><strong>High Availability</strong>: Multi-AZ deployment across eu-central-1a/1b</li>
<li class="has-line-data" data-line-start="30" data-line-end="31"><strong>Security</strong>: Defense-in-depth architecture with private subnets and security groups</li>
<li class="has-line-data" data-line-start="31" data-line-end="32"><strong>Monitoring</strong>: Automated server monitoring with GUI and console interfaces</li>
<li class="has-line-data" data-line-start="32" data-line-end="33"><strong>Compliance</strong>: ISO27001-aligned security controls and monitoring</li>
<li class="has-line-data" data-line-start="33" data-line-end="34"><strong>Backup</strong>: Automated backup strategy with multi-tier retention policies</li>
<li class="has-line-data" data-line-start="34" data-line-end="35"><strong>Scalability</strong>: Auto Scaling Groups with load balancing</li>
<li class="has-line-data" data-line-start="35" data-line-end="37"><strong>Cost Optimization</strong>: Resource optimization and cost monitoring</li>
</ul>
<h3 class="code-line" data-line-start=37 data-line-end=38 ><a id="Use_Cases_37"></a><strong>Use Cases</strong></h3>
<ul>
<li class="has-line-data" data-line-start="38" data-line-end="39"><strong>Production Web Applications</strong>: Scalable 3-tier architecture</li>
<li class="has-line-data" data-line-start="39" data-line-end="40"><strong>Enterprise Infrastructure</strong>: Compliance-ready cloud deployment</li>
<li class="has-line-data" data-line-start="40" data-line-end="41"><strong>Development Environments</strong>: Configurable resource sizing</li>
<li class="has-line-data" data-line-start="41" data-line-end="42"><strong>Disaster Recovery</strong>: Multi-region backup capabilities</li>
<li class="has-line-data" data-line-start="42" data-line-end="44"><strong>Infrastructure Monitoring</strong>: Real-time health checks and alerting</li>
</ul>
<h2 class="code-line" data-line-start=44 data-line-end=45 ><a id="_Architecture_Summary_44"></a>🏛️ Architecture Summary</h2>
<h3 class="code-line" data-line-start=46 data-line-end=47 ><a id="Network_and_Infrastructure_Architecture_46"></a><strong>Network and Infrastructure Architecture</strong></h3>
<pre><code class="has-line-data" data-line-start="48" data-line-end="74">┌─────────────────────────────────────────────────────────────────┐
│                        AWS VPC (10.0.0.0/16)                   │
│                                                                 │
│  ┌─────────────────────┐         ┌─────────────────────┐      │
│  │   Availability Zone │         │   Availability Zone │      │
│  │    eu-central-1a    │         │    eu-central-1b    │      │
│  │                     │         │                     │      │
│  │  ┌─────────────┐    │         │  ┌─────────────┐    │      │
│  │  │ Public      │    │         │  │ Public      │    │      │
│  │  │ 10.0.1.0/24 │    │         │  │ 10.0.2.0/24 │    │      │
│  │  │             │    │         │  │             │    │      │
│  │  │ Web Servers │    │         │  │ Web Servers │    │      │
│  │  │     ALB     │    │         │  │     ALB     │    │      │
│  │  │   NAT GW    │    │         │  │   NAT GW    │    │      │
│  │  └─────────────┘    │         │  └─────────────┘    │      │
│  │                     │         │                     │      │
│  │  ┌─────────────┐    │         │  ┌─────────────┐    │      │
│  │  │ Private     │    │         │  │ Private     │    │      │
│  │  │ 10.0.11.0/24│    │         │  │ 10.0.12.0/24│    │      │
│  │  │             │    │         │  │             │    │      │
│  │  │ App Servers │    │         │  │ App Servers │    │      │
│  │  │     RDS     │    │         │  │     RDS     │    │      │
│  │  └─────────────┘    │         │  └─────────────┘    │      │
│  └─────────────────────┘         └─────────────────────┘      │
└─────────────────────────────────────────────────────────────────┘
</code></pre>
<h3 class="code-line" data-line-start=75 data-line-end=76 ><a id="Security_Architecture_75"></a><strong>Security Architecture</strong></h3>
<pre><code class="has-line-data" data-line-start="77" data-line-end="93">┌─────────────────────────────────────────────────────────────┐
│                     Defense in Depth                        │
│                                                             │
│  Internet Gateway                                           │
│         │                                                   │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    │
│  │   Web SG    │    │   App SG    │    │   DB SG     │    │
│  │ HTTP/HTTPS  │───▶│ Port 8080   │───▶│ MySQL 3306  │    │
│  │ SSH (22)    │    │ MySQL 3306  │    │ from App SG │    │
│  │ ICMP        │    │ from Web SG │    │ only        │    │
│  │ from 0.0.0.0│    │ only        │    │             │    │
│  └─────────────┘    └─────────────┘    └─────────────┘    │
│                                                             │
│  Public Subnet  →   Private Subnet  →   Private Subnet    │
└─────────────────────────────────────────────────────────────┘
</code></pre>
<h3 class="code-line" data-line-start=94 data-line-end=95 ><a id="Data_Flow_94"></a><strong>Data Flow</strong></h3>
<ol>
<li class="has-line-data" data-line-start="95" data-line-end="96"><strong>User Request</strong> → Application Load Balancer</li>
<li class="has-line-data" data-line-start="96" data-line-end="97"><strong>ALB</strong> → Web Servers (Public Subnets)</li>
<li class="has-line-data" data-line-start="97" data-line-end="98"><strong>Web Servers</strong> → Application Servers (Private Subnets)</li>
<li class="has-line-data" data-line-start="98" data-line-end="99"><strong>App Servers</strong> → RDS Database (Private Subnets)</li>
<li class="has-line-data" data-line-start="99" data-line-end="101"><strong>Monitoring</strong> → CloudWatch → SNS → Email Alerts</li>
</ol>
<h3 class="code-line" data-line-start=101 data-line-end=102 ><a id="Monitoring_Architecture_101"></a><strong>Monitoring Architecture</strong></h3>
<pre><code class="has-line-data" data-line-start="103" data-line-end="119">┌─────────────────────────────────────────────────────────────┐
│                    Monitoring &amp; Alerting                    │
│                                                             │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    │
│  │ Server      │    │ CloudWatch  │    │ SNS Topic   │    │
│  │ Monitor     │───▶│ Metrics     │───▶│ Email       │    │
│  │ (GUI/CLI)   │    │ &amp; Alarms    │    │ Alerts      │    │
│  └─────────────┘    └─────────────┘    └─────────────┘    │
│                                                             │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    │
│  │ VPC Flow    │    │ CloudTrail  │    │ AWS Backup  │    │
│  │ Logs        │───▶│ API Logs    │───▶│ Recovery    │    │
│  │             │    │             │    │ Monitoring  │    │
│  └─────────────┘    └─────────────┘    └─────────────┘    │
└─────────────────────────────────────────────────────────────┘
</code></pre>
<h2 class="code-line" data-line-start=120 data-line-end=121 ><a id="_Terraform_Project_Structure_120"></a>📁 Terraform Project Structure</h2>
<pre><code class="has-line-data" data-line-start="123" data-line-end="156">aws-infrastructure/
├── 🏗️ Infrastructure (Terraform)
│   ├── main.tf                 # Main infrastructure configuration
│   ├── variables.tf            # Input variables and configuration
│   ├── outputs.tf              # Output values and endpoints
│   ├── terraform.tfvars.example # Example configuration
│   └── user_data/              # EC2 initialization scripts
│       ├── web_server_ubuntu.sh
│       ├── web_server_amazon_linux.sh
│       ├── app_server_ubuntu.sh
│       └── app_server_amazon_linux.sh
│
├── 🖥️ Monitoring &amp; Automation
│   ├── server_monitor.py       # GUI monitoring application
│   ├── server_monitor_console.py # Console monitoring application
│   ├── setup_env.py           # SMTP configuration helper
│   ├── demo_usage.py          # Demo and testing suite
│   └── env_config.example     # Environment configuration template
│
├── 📚 Documentation
│   ├── README.md              # This file
│   ├── INSTALLATION.md        # Installation instructions
│   ├── QUICK_START.md         # 5-minute setup guide
│   └── SERVER_MONITOR_README.md # Monitoring documentation
│
├── 📋 Configuration
│   ├── requirements.txt       # Python dependencies
│   └── files/                 # Reference documents
│
└── 🔧 Utilities
    ├── .gitignore
    └── terraform.tfstate.backup
</code></pre>
<h3 class="code-line" data-line-start=157 data-line-end=158 ><a id="Key_Terraform_Files_157"></a><strong>Key Terraform Files</strong></h3>
<h4 class="code-line" data-line-start=159 data-line-end=160 ><a id="maintf__Core_Infrastructure_159"></a><strong><a href="http://main.tf">main.tf</a></strong> - Core Infrastructure</h4>
<ul>
<li class="has-line-data" data-line-start="160" data-line-end="161">VPC and networking components</li>
<li class="has-line-data" data-line-start="161" data-line-end="162">Security groups and IAM roles</li>
<li class="has-line-data" data-line-start="162" data-line-end="163">EC2 instances and Auto Scaling Groups</li>
<li class="has-line-data" data-line-start="163" data-line-end="164">RDS database and S3 storage</li>
<li class="has-line-data" data-line-start="164" data-line-end="165">Application Load Balancer</li>
<li class="has-line-data" data-line-start="165" data-line-end="167">CloudWatch monitoring and AWS Backup</li>
</ul>
<h4 class="code-line" data-line-start=167 data-line-end=168 ><a id="variablestf__Configuration_Parameters_167"></a><strong><a href="http://variables.tf">variables.tf</a></strong> - Configuration Parameters</h4>
<ul>
<li class="has-line-data" data-line-start="168" data-line-end="169">Environment-specific variables</li>
<li class="has-line-data" data-line-start="169" data-line-end="170">Resource sizing and naming</li>
<li class="has-line-data" data-line-start="170" data-line-end="171">Security and compliance settings</li>
<li class="has-line-data" data-line-start="171" data-line-end="173">Cost optimization parameters</li>
</ul>
<h4 class="code-line" data-line-start=173 data-line-end=174 ><a id="outputstf__Infrastructure_Endpoints_173"></a><strong><a href="http://outputs.tf">outputs.tf</a></strong> - Infrastructure Endpoints</h4>
<ul>
<li class="has-line-data" data-line-start="174" data-line-end="175">Load balancer DNS names</li>
<li class="has-line-data" data-line-start="175" data-line-end="176">Database connection strings</li>
<li class="has-line-data" data-line-start="176" data-line-end="177">Monitoring endpoints</li>
<li class="has-line-data" data-line-start="177" data-line-end="179">Security group IDs</li>
</ul>
<h2 class="code-line" data-line-start=179 data-line-end=180 ><a id="_Resource_List_179"></a>🛠️ Resource List</h2>
<h3 class="code-line" data-line-start=181 data-line-end=182 ><a id="VPC__Networking_181"></a><strong>VPC &amp; Networking</strong></h3>
<table class="table table-striped table-bordered">
<thead>
<tr>
<th>Resource</th>
<th>Type</th>
<th>Purpose</th>
<th>High Availability</th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>VPC</strong></td>
<td>AWS::EC2::VPC</td>
<td>Network isolation (10.0.0.0/16)</td>
<td>Single region</td>
</tr>
<tr>
<td><strong>Internet Gateway</strong></td>
<td>AWS::EC2::InternetGateway</td>
<td>Internet access</td>
<td>Managed by AWS</td>
</tr>
<tr>
<td><strong>NAT Gateways</strong></td>
<td>AWS::EC2::NatGateway</td>
<td>Private subnet internet</td>
<td>Multi-AZ (2)</td>
</tr>
<tr>
<td><strong>Public Subnets</strong></td>
<td>AWS::EC2::Subnet</td>
<td>Web tier (10.0.1.0/24, 10.0.2.0/24)</td>
<td>Multi-AZ</td>
</tr>
<tr>
<td><strong>Private Subnets</strong></td>
<td>AWS::EC2::Subnet</td>
<td>App/DB tier (10.0.11.0/24, 10.0.12.0/24)</td>
<td>Multi-AZ</td>
</tr>
<tr>
<td><strong>Route Tables</strong></td>
<td>AWS::EC2::RouteTable</td>
<td>Traffic routing</td>
<td>Multi-AZ</td>
</tr>
</tbody>
</table>
<h3 class="code-line" data-line-start=191 data-line-end=192 ><a id="EC2_Compute_Resources_191"></a><strong>EC2 Compute Resources</strong></h3>
<table class="table table-striped table-bordered">
<thead>
<tr>
<th>Resource</th>
<th>Type</th>
<th>Configuration</th>
<th>Auto Scaling</th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>Web Servers</strong></td>
<td>EC2 Instances</td>
<td>Ubuntu 22.04/Amazon Linux 2</td>
<td>ASG: 2-5 instances</td>
</tr>
<tr>
<td><strong>App Servers</strong></td>
<td>EC2 Instances</td>
<td>Ubuntu 22.04/Amazon Linux 2</td>
<td>Static: 2 instances</td>
</tr>
<tr>
<td><strong>Application Load Balancer</strong></td>
<td>AWS::ELBv2::LoadBalancer</td>
<td>Multi-AZ with health checks</td>
<td>Managed by AWS</td>
</tr>
<tr>
<td><strong>Target Groups</strong></td>
<td>AWS::ELBv2::TargetGroup</td>
<td>HTTP/HTTPS routing</td>
<td>Auto-managed</td>
</tr>
<tr>
<td><strong>Launch Templates</strong></td>
<td>AWS::EC2::LaunchTemplate</td>
<td>Instance configuration</td>
<td>Version control</td>
</tr>
</tbody>
</table>
<h3 class="code-line" data-line-start=200 data-line-end=201 ><a id="Database__Storage_200"></a><strong>Database &amp; Storage</strong></h3>
<table class="table table-striped table-bordered">
<thead>
<tr>
<th>Resource</th>
<th>Type</th>
<th>Configuration</th>
<th>Backup Strategy</th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>RDS MySQL</strong></td>
<td>AWS::RDS::DBInstance</td>
<td>Multi-AZ, encrypted</td>
<td>Automated + AWS Backup</td>
</tr>
<tr>
<td><strong>S3 Backup Bucket</strong></td>
<td>AWS::S3::Bucket</td>
<td>Versioned, encrypted</td>
<td>Lifecycle policies</td>
</tr>
<tr>
<td><strong>EBS Volumes</strong></td>
<td>AWS::EC2::Volume</td>
<td>gp3, encrypted</td>
<td>Snapshot backups</td>
</tr>
<tr>
<td><strong>DB Subnet Group</strong></td>
<td>AWS::RDS::DBSubnetGroup</td>
<td>Multi-AZ placement</td>
<td>Automatic</td>
</tr>
</tbody>
</table>
<h3 class="code-line" data-line-start=208 data-line-end=209 ><a id="Security_Components_208"></a><strong>Security Components</strong></h3>
<table class="table table-striped table-bordered">
<thead>
<tr>
<th>Resource</th>
<th>Type</th>
<th>Purpose</th>
<th>Compliance</th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>Security Groups</strong></td>
<td>AWS::EC2::SecurityGroup</td>
<td>Network access control</td>
<td>ISO27001 aligned</td>
</tr>
<tr>
<td><strong>IAM Roles</strong></td>
<td>AWS::IAM::Role</td>
<td>Least privilege access</td>
<td>Principle of least privilege</td>
</tr>
<tr>
<td><strong>KMS Keys</strong></td>
<td>AWS::KMS::Key</td>
<td>Encryption at rest</td>
<td>Customer-managed</td>
</tr>
<tr>
<td><strong>VPC Flow Logs</strong></td>
<td>AWS::EC2::FlowLogs</td>
<td>Network monitoring</td>
<td>Audit trail</td>
</tr>
<tr>
<td><strong>Secrets Manager</strong></td>
<td>AWS::SecretsManager::Secret</td>
<td>Credential storage</td>
<td>Encrypted</td>
</tr>
</tbody>
</table>
<h3 class="code-line" data-line-start=217 data-line-end=218 ><a id="Monitoring__Alerting_217"></a><strong>Monitoring &amp; Alerting</strong></h3>
<table class="table table-striped table-bordered">
<thead>
<tr>
<th>Resource</th>
<th>Type</th>
<th>Purpose</th>
<th>Integration</th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>CloudWatch Alarms</strong></td>
<td>AWS::CloudWatch::Alarm</td>
<td>Threshold monitoring</td>
<td>SNS notifications</td>
</tr>
<tr>
<td><strong>CloudWatch Dashboard</strong></td>
<td>AWS::CloudWatch::Dashboard</td>
<td>Visual monitoring</td>
<td>Custom metrics</td>
</tr>
<tr>
<td><strong>SNS Topic</strong></td>
<td>AWS::SNS::Topic</td>
<td>Alert notifications</td>
<td>Email/SMS</td>
</tr>
<tr>
<td><strong>CloudTrail</strong></td>
<td>AWS::CloudTrail</td>
<td>API monitoring</td>
<td>Security events</td>
</tr>
<tr>
<td><strong>EventBridge Rules</strong></td>
<td>AWS::Events::Rule</td>
<td>Event-driven automation</td>
<td>Lambda triggers</td>
</tr>
</tbody>
</table>
<h3 class="code-line" data-line-start=226 data-line-end=227 ><a id="Backup__Recovery_226"></a><strong>Backup &amp; Recovery</strong></h3>
<table class="table table-striped table-bordered">
<thead>
<tr>
<th>Resource</th>
<th>Type</th>
<th>Retention</th>
<th>Recovery Time</th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>AWS Backup Vault</strong></td>
<td>AWS::Backup::BackupVault</td>
<td>Multi-tier retention</td>
<td>&lt; 30 minutes</td>
</tr>
<tr>
<td><strong>Backup Plans</strong></td>
<td>AWS::Backup::BackupPlan</td>
<td>Daily/Weekly/Monthly</td>
<td>Point-in-time recovery</td>
</tr>
<tr>
<td><strong>Cross-Region Replication</strong></td>
<td>AWS::S3::Bucket</td>
<td>90-day retention</td>
<td>&lt; 1 hour</td>
</tr>
<tr>
<td><strong>RDS Snapshots</strong></td>
<td>AWS::RDS::DBSnapshot</td>
<td>Automated + manual</td>
<td>&lt; 15 minutes</td>
</tr>
</tbody>
</table>
<h2 class="code-line" data-line-start=234 data-line-end=235 ><a id="_Security__Compliance_234"></a>🔐 Security &amp; Compliance</h2>
<h3 class="code-line" data-line-start=236 data-line-end=237 ><a id="ISO27001_Alignment_236"></a><strong>ISO27001 Alignment</strong></h3>
<p class="has-line-data" data-line-start="237" data-line-end="238">This infrastructure implements controls aligned with ISO27001 standards:</p>
<h4 class="code-line" data-line-start=239 data-line-end=240 ><a id="A9__Access_Control_239"></a><strong>A.9 - Access Control</strong></h4>
<ul>
<li class="has-line-data" data-line-start="240" data-line-end="241">✅ <strong>IAM Roles</strong>: Least privilege access for all resources</li>
<li class="has-line-data" data-line-start="241" data-line-end="242">✅ <strong>MFA Requirements</strong>: Multi-factor authentication for AWS accounts</li>
<li class="has-line-data" data-line-start="242" data-line-end="243">✅ <strong>Access Logging</strong>: CloudTrail for all API calls</li>
<li class="has-line-data" data-line-start="243" data-line-end="245">✅ <strong>Role-Based Access</strong>: Separate roles for web/app servers</li>
</ul>
<h4 class="code-line" data-line-start=245 data-line-end=246 ><a id="A10__Cryptography_245"></a><strong>A.10 - Cryptography</strong></h4>
<ul>
<li class="has-line-data" data-line-start="246" data-line-end="247">✅ <strong>Encryption at Rest</strong>: KMS encryption for RDS, S3, EBS</li>
<li class="has-line-data" data-line-start="247" data-line-end="248">✅ <strong>Encryption in Transit</strong>: TLS 1.2+ for all communications</li>
<li class="has-line-data" data-line-start="248" data-line-end="249">✅ <strong>Key Management</strong>: Customer-managed KMS keys with rotation</li>
<li class="has-line-data" data-line-start="249" data-line-end="251">✅ <strong>Certificate Management</strong>: ACM for SSL/TLS certificates</li>
</ul>
<h4 class="code-line" data-line-start=251 data-line-end=252 ><a id="A12__Operations_Security_251"></a><strong>A.12 - Operations Security</strong></h4>
<ul>
<li class="has-line-data" data-line-start="252" data-line-end="253">✅ <strong>Network Segmentation</strong>: Private subnets for sensitive resources</li>
<li class="has-line-data" data-line-start="253" data-line-end="254">✅ <strong>Monitoring</strong>: CloudWatch, VPC Flow Logs, CloudTrail</li>
<li class="has-line-data" data-line-start="254" data-line-end="255">✅ <strong>Patch Management</strong>: Automated security updates</li>
<li class="has-line-data" data-line-start="255" data-line-end="257">✅ <strong>Backup</strong>: Automated backup with encryption</li>
</ul>
<h4 class="code-line" data-line-start=257 data-line-end=258 ><a id="A13__Communications_Security_257"></a><strong>A.13 - Communications Security</strong></h4>
<ul>
<li class="has-line-data" data-line-start="258" data-line-end="259">✅ <strong>Network Controls</strong>: Security groups with minimal access</li>
<li class="has-line-data" data-line-start="259" data-line-end="260">✅ <strong>VPC Isolation</strong>: Private network with controlled access</li>
<li class="has-line-data" data-line-start="260" data-line-end="261">✅ <strong>NAT Gateway</strong>: Outbound internet access without inbound exposure</li>
<li class="has-line-data" data-line-start="261" data-line-end="263">✅ <strong>Load Balancer</strong>: SSL termination with security headers</li>
</ul>
<h4 class="code-line" data-line-start=263 data-line-end=264 ><a id="A17__Information_Security_Continuity_263"></a><strong>A.17 - Information Security Continuity</strong></h4>
<ul>
<li class="has-line-data" data-line-start="264" data-line-end="265">✅ <strong>Multi-AZ Deployment</strong>: High availability across zones</li>
<li class="has-line-data" data-line-start="265" data-line-end="266">✅ <strong>Automated Backup</strong>: Daily backups with long-term retention</li>
<li class="has-line-data" data-line-start="266" data-line-end="267">✅ <strong>Disaster Recovery</strong>: Cross-region replication</li>
<li class="has-line-data" data-line-start="267" data-line-end="269">✅ <strong>Monitoring</strong>: 24/7 automated health checks</li>
</ul>
<h3 class="code-line" data-line-start=269 data-line-end=270 ><a id="Security_Best_Practices_Implemented_269"></a><strong>Security Best Practices Implemented</strong></h3>
<pre><code class="has-line-data" data-line-start="271" data-line-end="295" class="language-yaml">Network Security:
  - Private subnets for application and database tiers
  - Security groups with least privilege rules
  - VPC Flow Logs for network monitoring
  - NAT Gateways for secure outbound access

Data Protection:
  - KMS encryption for all data at rest
  - TLS 1.2+ for data in transit
  - Automated backup with encryption
  - Secure key management with rotation

Access Control:
  - IAM roles with minimal permissions
  - No direct database access from internet
  - Bastion host for secure SSH access
  - MFA requirements for administrative access

Monitoring &amp; Compliance:
  - CloudTrail for API audit logging
  - CloudWatch for performance monitoring
  - SNS for real-time alerting
  - Security event correlation
</code></pre>
<h2 class="code-line" data-line-start=296 data-line-end=297 ><a id="_Backup__Disaster_Recovery_Strategy_296"></a>🔄 Backup &amp; Disaster Recovery Strategy</h2>
<h3 class="code-line" data-line-start=298 data-line-end=299 ><a id="MultiTier_Backup_Strategy_298"></a><strong>Multi-Tier Backup Strategy</strong></h3>
<pre><code class="has-line-data" data-line-start="300" data-line-end="321" class="language-yaml">Tier 1 - Daily Backups:
  Frequency: Every 24 hours at 23:00 UTC (2:00 AM Bahrain time)
  Retention: 30 days
  Storage: AWS Backup Vault (encrypted)
  Recovery Time: &lt; 30 minutes
  Recovery Point: 24 hours

Tier 2 - Weekly Backups:
  Frequency: Every Sunday at 23:00 UTC
  Retention: 12 months
  Storage: Cold storage transition after 30 days
  Recovery Time: &lt; 2 hours
  Recovery Point: 1 week

Tier 3 - Monthly Backups:
  Frequency: First Sunday of every month
  Retention: 7 years
  Storage: Glacier Deep Archive after 90 days
  Recovery Time: &lt; 12 hours
  Recovery Point: 1 month
</code></pre>
<h3 class="code-line" data-line-start=322 data-line-end=323 ><a id="Backup_Coverage_322"></a><strong>Backup Coverage</strong></h3>
<table class="table table-striped table-bordered">
<thead>
<tr>
<th>Resource</th>
<th>Backup Method</th>
<th>Schedule</th>
<th>Retention</th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>RDS Database</strong></td>
<td>AWS Backup + Automated Snapshots</td>
<td>Daily</td>
<td>30 days</td>
</tr>
<tr>
<td><strong>EBS Volumes</strong></td>
<td>AWS Backup Snapshots</td>
<td>Daily</td>
<td>30 days</td>
</tr>
<tr>
<td><strong>S3 Bucket</strong></td>
<td>Cross-Region Replication</td>
<td>Real-time</td>
<td>90 days</td>
</tr>
<tr>
<td><strong>Application Code</strong></td>
<td>S3 Backup</td>
<td>Weekly</td>
<td>1 year</td>
</tr>
<tr>
<td><strong>Configuration</strong></td>
<td>Version Control + S3</td>
<td>On change</td>
<td>Indefinite</td>
</tr>
</tbody>
</table>
<h3 class="code-line" data-line-start=331 data-line-end=332 ><a id="Disaster_Recovery_Procedures_331"></a><strong>Disaster Recovery Procedures</strong></h3>
<pre><code class="has-line-data" data-line-start="333" data-line-end="351" class="language-yaml">RTO (Recovery Time Objective): 2 hours
RPO (Recovery Point Objective): 1 hour

Recovery Steps:
1. Assess impact and determine recovery scope
2. Activate backup infrastructure in secondary region
3. Restore RDS database from latest backup
4. Launch EC2 instances from AMI snapshots
5. Update DNS records to point to recovery environment
6. Validate application functionality
7. Communicate status to stakeholders

Automated Recovery Features:
- Multi-AZ RDS for automatic failover
- Auto Scaling Groups for instance replacement
- Application Load Balancer health checks
- Route 53 health checks for DNS failover
</code></pre>
<h3 class="code-line" data-line-start=352 data-line-end=353 ><a id="Business_Continuity_352"></a><strong>Business Continuity</strong></h3>
<ul>
<li class="has-line-data" data-line-start="353" data-line-end="354"><strong>High Availability</strong>: Multi-AZ deployment ensures 99.9% uptime</li>
<li class="has-line-data" data-line-start="354" data-line-end="355"><strong>Automatic Failover</strong>: RDS and ALB provide automatic failover</li>
<li class="has-line-data" data-line-start="355" data-line-end="356"><strong>Scalability</strong>: Auto Scaling handles traffic spikes</li>
<li class="has-line-data" data-line-start="356" data-line-end="358"><strong>Monitoring</strong>: 24/7 automated monitoring with alerts</li>
</ul>
<h2 class="code-line" data-line-start=358 data-line-end=359 ><a id="_Automation_Script_Usage_358"></a>🤖 Automation Script Usage</h2>
<h3 class="code-line" data-line-start=360 data-line-end=361 ><a id="Server_Monitoring_Solution_360"></a><strong>Server Monitoring Solution</strong></h3>
<p class="has-line-data" data-line-start="361" data-line-end="362">This project includes comprehensive server monitoring with two interfaces:</p>
<h4 class="code-line" data-line-start=363 data-line-end=364 ><a id="GUI_Application_server_monitorpy_363"></a><strong>GUI Application</strong> (<code>server_monitor.py</code>)</h4>
<pre><code class="has-line-data" data-line-start="365" data-line-end="374" class="language-bash"><span class="hljs-comment"># Prerequisites</span>
sudo apt-get install python3-tk  <span class="hljs-comment"># Linux only</span>

<span class="hljs-comment"># Configure email notifications</span>
python3 setup_env.py

<span class="hljs-comment"># Run GUI application</span>
python3 server_monitor.py
</code></pre>
<p class="has-line-data" data-line-start="375" data-line-end="376"><strong>Features:</strong></p>
<ul>
<li class="has-line-data" data-line-start="376" data-line-end="377"><strong>Modern Interface</strong>: tkinter-based GUI with real-time updates</li>
<li class="has-line-data" data-line-start="377" data-line-end="378"><strong>Visual Indicators</strong>: Green ✅ for online, Red ❌ for offline servers</li>
<li class="has-line-data" data-line-start="378" data-line-end="379"><strong>Configuration</strong>: Point-and-click server management</li>
<li class="has-line-data" data-line-start="379" data-line-end="380"><strong>Notifications</strong>: Email alerts with SMTP integration</li>
<li class="has-line-data" data-line-start="380" data-line-end="382"><strong>Dashboard</strong>: Real-time status updates with response times</li>
</ul>
<h4 class="code-line" data-line-start=382 data-line-end=383 ><a id="Console_Application_server_monitor_consolepy_382"></a><strong>Console Application</strong> (<code>server_monitor_console.py</code>)</h4>
<pre><code class="has-line-data" data-line-start="384" data-line-end="387" class="language-bash"><span class="hljs-comment"># No additional dependencies required</span>
python3 server_monitor_console.py
</code></pre>
<p class="has-line-data" data-line-start="388" data-line-end="389"><strong>Features:</strong></p>
<ul>
<li class="has-line-data" data-line-start="389" data-line-end="390"><strong>Headless Operation</strong>: Perfect for servers without GUI</li>
<li class="has-line-data" data-line-start="390" data-line-end="391"><strong>SSH Compatible</strong>: Works over SSH connections</li>
<li class="has-line-data" data-line-start="391" data-line-end="392"><strong>Colored Output</strong>: Terminal-based visual indicators</li>
<li class="has-line-data" data-line-start="392" data-line-end="393"><strong>Menu Driven</strong>: Easy navigation and configuration</li>
<li class="has-line-data" data-line-start="393" data-line-end="395"><strong>Background Mode</strong>: Can run as a system service</li>
</ul>
<h3 class="code-line" data-line-start=395 data-line-end=396 ><a id="Configuration__Setup_395"></a><strong>Configuration &amp; Setup</strong></h3>
<h4 class="code-line" data-line-start=397 data-line-end=398 ><a id="Email_Configuration_397"></a><strong>Email Configuration</strong></h4>
<pre><code class="has-line-data" data-line-start="399" data-line-end="411" class="language-bash"><span class="hljs-comment"># Interactive setup wizard</span>
python3 setup_env.py

<span class="hljs-comment"># Manual environment variables</span>
<span class="hljs-built_in">export</span> SMTP_SERVER=smtp.gmail.com
<span class="hljs-built_in">export</span> SMTP_PORT=<span class="hljs-number">587</span>
<span class="hljs-built_in">export</span> SMTP_USERNAME=your-email@gmail.com
<span class="hljs-built_in">export</span> SMTP_PASSWORD=your-app-password
<span class="hljs-built_in">export</span> SMTP_FROM=your-email@gmail.com
<span class="hljs-built_in">export</span> SMTP_TO=admin@company.com
<span class="hljs-built_in">export</span> SMTP_USE_TLS=<span class="hljs-literal">true</span>
</code></pre>
<h4 class="code-line" data-line-start=412 data-line-end=413 ><a id="Supported_Email_Providers_412"></a><strong>Supported Email Providers</strong></h4>
<table class="table table-striped table-bordered">
<thead>
<tr>
<th>Provider</th>
<th>SMTP Server</th>
<th>Port</th>
<th>Security</th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>Gmail</strong></td>
<td><a href="http://smtp.gmail.com">smtp.gmail.com</a></td>
<td>587</td>
<td>TLS + App Password</td>
</tr>
<tr>
<td><strong>Outlook</strong></td>
<td><a href="http://smtp.live.com">smtp.live.com</a></td>
<td>587</td>
<td>TLS + Standard Auth</td>
</tr>
<tr>
<td><strong>Yahoo</strong></td>
<td><a href="http://smtp.mail.yahoo.com">smtp.mail.yahoo.com</a></td>
<td>587</td>
<td>TLS + App Password</td>
</tr>
<tr>
<td><strong>Custom</strong></td>
<td>Your SMTP server</td>
<td>587/465</td>
<td>TLS/SSL</td>
</tr>
</tbody>
</table>
<h3 class="code-line" data-line-start=420 data-line-end=421 ><a id="Automation_Features_420"></a><strong>Automation Features</strong></h3>
<pre><code class="has-line-data" data-line-start="422" data-line-end="446" class="language-yaml">Real-time Monitoring:
  - ICMP ping checks with configurable intervals
  - Response time measurement in milliseconds
  - Consecutive failure tracking
  - Multi-server monitoring support

Email Notifications:
  - SMTP integration with major providers
  - Configurable failure thresholds
  - Test email functionality
  - Secure credential management

Configuration Management:
  - Persistent server configuration
  - Environment variable support
  - Interactive setup wizard
  - Export/import capabilities

System Integration:
  - Service installation scripts
  - Log rotation and management
  - Performance optimization
  - Cross-platform compatibility
</code></pre>
<h3 class="code-line" data-line-start=447 data-line-end=448 ><a id="Usage_Examples_447"></a><strong>Usage Examples</strong></h3>
<h4 class="code-line" data-line-start=449 data-line-end=450 ><a id="Basic_Usage_449"></a><strong>Basic Usage</strong></h4>
<pre><code class="has-line-data" data-line-start="451" data-line-end="460" class="language-bash"><span class="hljs-comment"># Quick demo</span>
python3 demo_usage.py

<span class="hljs-comment"># Add servers to monitor</span>
python3 server_monitor_console.py
<span class="hljs-comment"># Select option 1 to add server</span>
<span class="hljs-comment"># Enter IP: 8.8.8.8</span>
<span class="hljs-comment"># Select option 4 to start monitoring</span>
</code></pre>
<h4 class="code-line" data-line-start=461 data-line-end=462 ><a id="Production_Deployment_461"></a><strong>Production Deployment</strong></h4>
<pre><code class="has-line-data" data-line-start="463" data-line-end="473" class="language-bash"><span class="hljs-comment"># Install as system service</span>
sudo systemctl <span class="hljs-built_in">enable</span> server-monitor
sudo systemctl start server-monitor

<span class="hljs-comment"># Monitor service status</span>
sudo systemctl status server-monitor

<span class="hljs-comment"># View logs</span>
sudo journalctl -u server-monitor <span class="hljs-operator">-f</span>
</code></pre>
<h2 class="code-line" data-line-start=474 data-line-end=475 ><a id="_Monitoring_and_Alerts_474"></a>📊 Monitoring and Alerts</h2>
<h3 class="code-line" data-line-start=476 data-line-end=477 ><a id="CloudWatch_Integration_476"></a><strong>CloudWatch Integration</strong></h3>
<pre><code class="has-line-data" data-line-start="478" data-line-end="500" class="language-yaml">Metrics Monitored:
  - EC2 CPU utilization and memory usage
  - RDS performance and connection counts
  - Application Load Balancer response times
  - Auto Scaling Group health and capacity
  - S3 bucket storage and requests
  - VPC Flow Logs analysis

Alarms Configured:
  - EC2 CPU &gt; 70% (triggers scaling)
  - RDS CPU &gt; 80% (performance alert)
  - ALB latency &gt; 1000ms (performance alert)
  - Failed health checks (availability alert)
  - Disk space &gt; 85% (storage alert)
  - Memory usage &gt; 80% (memory alert)

Dashboards Available:
  - Infrastructure overview
  - Application performance
  - Security events
  - Cost optimization
</code></pre>
<h3 class="code-line" data-line-start=501 data-line-end=502 ><a id="Alert_Configuration_501"></a><strong>Alert Configuration</strong></h3>
<pre><code class="has-line-data" data-line-start="503" data-line-end="522" class="language-yaml">Critical Alerts (Immediate):
  - Server unreachable (3 consecutive failures)
  - Database connection failures
  - Application Load Balancer failures
  - Security group changes
  - Root login attempts

Warning Alerts (15-minute delay):
  - High CPU usage (&gt;70%)
  - High memory usage (&gt;80%)
  - High disk usage (&gt;85%)
  - Slow response times (&gt;1000ms)

Informational Alerts (Daily):
  - Backup completion status
  - Cost optimization recommendations
  - Security audit summaries
  - Performance reports
</code></pre>
<h3 class="code-line" data-line-start=523 data-line-end=524 ><a id="Monitoring_Architecture_523"></a><strong>Monitoring Architecture</strong></h3>
<pre><code class="has-line-data" data-line-start="525" data-line-end="543" class="language-yaml">Server-Level Monitoring:
  - Custom Python monitoring applications
  - Real-time ping checks
  - Email notifications
  - GUI and console interfaces

AWS-Level Monitoring:
  - CloudWatch metrics and alarms
  - CloudTrail API logging
  - VPC Flow Logs
  - Config compliance monitoring

Application-Level Monitoring:
  - Health check endpoints
  - Application performance metrics
  - Error rate tracking
  - User experience monitoring
</code></pre>
<h3 class="code-line" data-line-start=544 data-line-end=545 ><a id="Security_Monitoring_544"></a><strong>Security Monitoring</strong></h3>
<pre><code class="has-line-data" data-line-start="546" data-line-end="564" class="language-yaml">Network Security:
  - VPC Flow Logs analysis
  - Security group change detection
  - Unusual traffic pattern alerts
  - DDoS attack detection

Access Security:
  - CloudTrail API monitoring
  - Failed login attempt tracking
  - Privilege escalation detection
  - Unusual access pattern alerts

Data Security:
  - Encryption status monitoring
  - Backup integrity checks
  - Data access auditing
  - Compliance reporting
</code></pre>
<h2 class="code-line" data-line-start=565 data-line-end=566 ><a id="_Cost_Estimation_Guidance_565"></a>💰 Cost Estimation Guidance</h2>
<h3 class="code-line" data-line-start=567 data-line-end=568 ><a id="Monthly_Cost_Breakdown_eucentral1_567"></a><strong>Monthly Cost Breakdown (eu-central-1)</strong></h3>
<pre><code class="has-line-data" data-line-start="569" data-line-end="591" class="language-yaml">Compute Resources:
  EC2 Instances (4x t3.medium): $85-120/month
  Application Load Balancer: $25-35/month
  NAT Gateways (2x): $60-80/month
  EBS Storage (200GB): $25-35/month
  Subtotal: $195-270/month

Database &amp; Storage:
  RDS MySQL (Multi-AZ): $70-100/month
  S3 Backup Storage (100GB): $5-10/month
  EBS Snapshots: $15-25/month
  Subtotal: $90-135/month

Monitoring &amp; Backup:
  CloudWatch Metrics: $15-25/month
  AWS Backup: $20-30/month
  SNS Notifications: $2-5/month
  VPC Flow Logs: $10-15/month
  Subtotal: $47-75/month

Total Estimated Cost: $332-480/month
</code></pre>
<h3 class="code-line" data-line-start=592 data-line-end=593 ><a id="AWS_Pricing_Calculator_Integration_592"></a><strong>AWS Pricing Calculator Integration</strong></h3>
<p class="has-line-data" data-line-start="593" data-line-end="594">Use the <a href="https://calculator.aws/">AWS Pricing Calculator</a> to get precise estimates:</p>
<ol>
<li class="has-line-data" data-line-start="595" data-line-end="600">
<p class="has-line-data" data-line-start="595" data-line-end="596"><strong>VPC and Networking</strong></p>
<ul>
<li class="has-line-data" data-line-start="596" data-line-end="597">VPC: Free</li>
<li class="has-line-data" data-line-start="597" data-line-end="598">NAT Gateways: $45.58/month each</li>
<li class="has-line-data" data-line-start="598" data-line-end="600">Data Transfer: $0.09/GB</li>
</ul>
</li>
<li class="has-line-data" data-line-start="600" data-line-end="605">
<p class="has-line-data" data-line-start="600" data-line-end="601"><strong>EC2 Instances</strong></p>
<ul>
<li class="has-line-data" data-line-start="601" data-line-end="602">t3.medium: $30.37/month (Linux)</li>
<li class="has-line-data" data-line-start="602" data-line-end="603">t3.large: $60.74/month (Linux)</li>
<li class="has-line-data" data-line-start="603" data-line-end="605">EBS gp3: $0.08/GB-month</li>
</ul>
</li>
<li class="has-line-data" data-line-start="605" data-line-end="610">
<p class="has-line-data" data-line-start="605" data-line-end="606"><strong>RDS Database</strong></p>
<ul>
<li class="has-line-data" data-line-start="606" data-line-end="607">db.t3.micro: $13.14/month (Single-AZ)</li>
<li class="has-line-data" data-line-start="607" data-line-end="608">db.t3.small: $26.28/month (Single-AZ)</li>
<li class="has-line-data" data-line-start="608" data-line-end="610">Multi-AZ: 2x single-AZ cost</li>
</ul>
</li>
<li class="has-line-data" data-line-start="610" data-line-end="614">
<p class="has-line-data" data-line-start="610" data-line-end="611"><strong>Load Balancer</strong></p>
<ul>
<li class="has-line-data" data-line-start="611" data-line-end="612">Application Load Balancer: $22.27/month</li>
<li class="has-line-data" data-line-start="612" data-line-end="614">Load Balancer Capacity Units: $0.008/hour</li>
</ul>
</li>
</ol>
<h3 class="code-line" data-line-start=614 data-line-end=615 ><a id="Cost_Optimization_Strategies_614"></a><strong>Cost Optimization Strategies</strong></h3>
<pre><code class="has-line-data" data-line-start="616" data-line-end="636" class="language-yaml">Reserved Instances:
  - 40-60% savings for EC2 instances
  - 30-50% savings for RDS databases
  - Recommended for production workloads

Right-sizing:
  - Use CloudWatch metrics to optimize instance types
  - Implement Auto Scaling for dynamic workloads
  - Regular cost reviews and adjustments

Storage Optimization:
  - S3 Intelligent Tiering for backup storage
  - EBS gp3 volumes for better price/performance
  - Lifecycle policies for old snapshots

Monitoring:
  - Set up billing alerts for cost control
  - Use AWS Cost Explorer for analysis
  - Implement cost allocation tags
</code></pre>
<h3 class="code-line" data-line-start=637 data-line-end=638 ><a id="EnvironmentSpecific_Costs_637"></a><strong>Environment-Specific Costs</strong></h3>
<table class="table table-striped table-bordered">
<thead>
<tr>
<th>Environment</th>
<th>EC2 Instances</th>
<th>RDS</th>
<th>Monthly Cost</th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>Development</strong></td>
<td>2x t3.small</td>
<td>Single-AZ</td>
<td>$150-200</td>
</tr>
<tr>
<td><strong>Staging</strong></td>
<td>2x t3.medium</td>
<td>Single-AZ</td>
<td>$220-280</td>
</tr>
<tr>
<td><strong>Production</strong></td>
<td>4x t3.large</td>
<td>Multi-AZ</td>
<td>$400-600</td>
</tr>
<tr>
<td><strong>High-Traffic</strong></td>
<td>6x t3.xlarge</td>
<td>Multi-AZ</td>
<td>$800-1200</td>
</tr>
</tbody>
</table>
<h3 class="code-line" data-line-start=645 data-line-end=646 ><a id="Cost_Monitoring_Setup_645"></a><strong>Cost Monitoring Setup</strong></h3>
<pre><code class="has-line-data" data-line-start="647" data-line-end="657" class="language-bash"><span class="hljs-comment"># Set up billing alerts</span>
aws budgets create-budget \
  --account-id ACCOUNT_ID \
  --budget file://budget.json

<span class="hljs-comment"># Create cost allocation tags</span>
aws resourcegroupstaggingapi tag-resources \
  --resource-arn-list arn:aws:ec2:region:account:instance/* \
  --tags Environment=Production,Project=WebApp
</code></pre>
<h2 class="code-line" data-line-start=658 data-line-end=659 ><a id="_Quick_Start_658"></a>🚀 Quick Start</h2>
<h3 class="code-line" data-line-start=660 data-line-end=661 ><a id="Prerequisites_660"></a><strong>Prerequisites</strong></h3>
<ul>
<li class="has-line-data" data-line-start="661" data-line-end="662">AWS CLI configured with appropriate permissions</li>
<li class="has-line-data" data-line-start="662" data-line-end="663">Terraform v1.5+ installed</li>
<li class="has-line-data" data-line-start="663" data-line-end="664">Python 3.7+ for monitoring scripts</li>
<li class="has-line-data" data-line-start="664" data-line-end="666">Git for version control</li>
</ul>
<h3 class="code-line" data-line-start=666 data-line-end=667 ><a id="1_Infrastructure_Deployment_666"></a><strong>1. Infrastructure Deployment</strong></h3>
<pre><code class="has-line-data" data-line-start="668" data-line-end="685" class="language-bash"><span class="hljs-comment"># Clone the repository</span>
git <span class="hljs-built_in">clone</span> &lt;repository-url&gt;
<span class="hljs-built_in">cd</span> aws-infrastructure

<span class="hljs-comment"># Configure variables</span>
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars  <span class="hljs-comment"># Edit with your values</span>

<span class="hljs-comment"># Initialize Terraform</span>
terraform init

<span class="hljs-comment"># Plan deployment</span>
terraform plan

<span class="hljs-comment"># Apply infrastructure</span>
terraform apply
</code></pre>
<h3 class="code-line" data-line-start=686 data-line-end=687 ><a id="2_Monitoring_Setup_686"></a><strong>2. Monitoring Setup</strong></h3>
<pre><code class="has-line-data" data-line-start="688" data-line-end="697" class="language-bash"><span class="hljs-comment"># Configure email notifications</span>
python3 setup_env.py

<span class="hljs-comment"># Test monitoring (GUI version)</span>
python3 server_monitor.py

<span class="hljs-comment"># Or use console version (headless)</span>
python3 server_monitor_console.py
</code></pre>
<h3 class="code-line" data-line-start=698 data-line-end=699 ><a id="3_Verification_698"></a><strong>3. Verification</strong></h3>
<pre><code class="has-line-data" data-line-start="700" data-line-end="709" class="language-bash"><span class="hljs-comment"># Check infrastructure outputs</span>
terraform output

<span class="hljs-comment"># Test monitoring with demo</span>
python3 demo_usage.py

<span class="hljs-comment"># Access application</span>
curl http://$(terraform output -raw alb_dns_name)
</code></pre>
<h3 class="code-line" data-line-start=710 data-line-end=711 ><a id="4_Production_Readiness_710"></a><strong>4. Production Readiness</strong></h3>
<pre><code class="has-line-data" data-line-start="712" data-line-end="723" class="language-bash"><span class="hljs-comment"># Set up monitoring alerts</span>
aws sns subscribe \
  --topic-arn $(terraform output -raw sns_topic_arn) \
  --protocol email \
  --notification-endpoint your-email@company.com

<span class="hljs-comment"># Configure backup notifications</span>
aws backup put-backup-vault-notifications \
  --backup-vault-name $(terraform output -raw backup_vault_name) \
  --sns-topic-arn $(terraform output -raw sns_topic_arn)
</code></pre>
<h2 class="code-line" data-line-start=724 data-line-end=725 ><a id="_Documentation_724"></a>📚 Documentation</h2>
<h3 class="code-line" data-line-start=726 data-line-end=727 ><a id="Comprehensive_Guides_726"></a><strong>Comprehensive Guides</strong></h3>
<ul>
<li class="has-line-data" data-line-start="727" data-line-end="728"><strong><a href="INSTALLATION.md">Installation Guide</a></strong> - Complete setup instructions</li>
<li class="has-line-data" data-line-start="728" data-line-end="729"><strong><a href="QUICK_START.md">Quick Start Guide</a></strong> - 5-minute setup walkthrough</li>
<li class="has-line-data" data-line-start="729" data-line-end="730"><strong><a href="SERVER_MONITOR_README.md">Monitoring Documentation</a></strong> - Comprehensive monitoring guide</li>
<li class="has-line-data" data-line-start="730" data-line-end="731"><strong><a href="variables.tf">Terraform Variables</a></strong> - All configuration options</li>
<li class="has-line-data" data-line-start="731" data-line-end="733"><strong><a href="outputs.tf">Output Values</a></strong> - Infrastructure endpoints and IDs</li>
</ul>
<h3 class="code-line" data-line-start=733 data-line-end=734 ><a id="Architecture_Documentation_733"></a><strong>Architecture Documentation</strong></h3>
<ul>
<li class="has-line-data" data-line-start="734" data-line-end="735">Network topology and security groups</li>
<li class="has-line-data" data-line-start="735" data-line-end="736">Data flow and component relationships</li>
<li class="has-line-data" data-line-start="736" data-line-end="737">Backup and disaster recovery procedures</li>
<li class="has-line-data" data-line-start="737" data-line-end="739">Monitoring and alerting architecture</li>
</ul>
<h3 class="code-line" data-line-start=739 data-line-end=740 ><a id="Configuration_Examples_739"></a><strong>Configuration Examples</strong></h3>
<ul>
<li class="has-line-data" data-line-start="740" data-line-end="741">Development environment setup</li>
<li class="has-line-data" data-line-start="741" data-line-end="742">Production environment configuration</li>
<li class="has-line-data" data-line-start="742" data-line-end="743">Multi-region deployment options</li>
<li class="has-line-data" data-line-start="743" data-line-end="745">Custom monitoring configurations</li>
</ul>
<h3 class="code-line" data-line-start=745 data-line-end=746 ><a id="Troubleshooting_745"></a><strong>Troubleshooting</strong></h3>
<ul>
<li class="has-line-data" data-line-start="746" data-line-end="747">Common deployment issues</li>
<li class="has-line-data" data-line-start="747" data-line-end="748">Monitoring setup problems</li>
<li class="has-line-data" data-line-start="748" data-line-end="749">Performance optimization</li>
<li class="has-line-data" data-line-start="749" data-line-end="751">Security configuration</li>
</ul>
<h2 class="code-line" data-line-start=751 data-line-end=752 ><a id="_Contributing_751"></a>🤝 Contributing</h2>
<p class="has-line-data" data-line-start="753" data-line-end="754">We welcome contributions to improve this infrastructure solution!</p>
<h3 class="code-line" data-line-start=755 data-line-end=756 ><a id="How_to_Contribute_755"></a><strong>How to Contribute</strong></h3>
<ol>
<li class="has-line-data" data-line-start="756" data-line-end="757">Fork the repository</li>
<li class="has-line-data" data-line-start="757" data-line-end="758">Create a feature branch</li>
<li class="has-line-data" data-line-start="758" data-line-end="759">Make your changes</li>
<li class="has-line-data" data-line-start="759" data-line-end="760">Test thoroughly</li>
<li class="has-line-data" data-line-start="760" data-line-end="762">Submit a pull request</li>
</ol>
<h3 class="code-line" data-line-start=762 data-line-end=763 ><a id="Areas_for_Contribution_762"></a><strong>Areas for Contribution</strong></h3>
<ul>
<li class="has-line-data" data-line-start="763" data-line-end="764">Additional monitoring integrations</li>
<li class="has-line-data" data-line-start="764" data-line-end="765">Cost optimization improvements</li>
<li class="has-line-data" data-line-start="765" data-line-end="766">Security enhancements</li>
<li class="has-line-data" data-line-start="766" data-line-end="767">Documentation updates</li>
<li class="has-line-data" data-line-start="767" data-line-end="769">Bug fixes and improvements</li>
</ul>
<h3 class="code-line" data-line-start=769 data-line-end=770 ><a id="Development_Guidelines_769"></a><strong>Development Guidelines</strong></h3>
<ul>
<li class="has-line-data" data-line-start="770" data-line-end="771">Follow Terraform best practices</li>
<li class="has-line-data" data-line-start="771" data-line-end="772">Add comprehensive documentation</li>
<li class="has-line-data" data-line-start="772" data-line-end="773">Include test configurations</li>
<li class="has-line-data" data-line-start="773" data-line-end="774">Update cost estimates</li>
<li class="has-line-data" data-line-start="774" data-line-end="776">Validate security settings</li>
</ul>
<hr>
<h2 class="code-line" data-line-start=778 data-line-end=779 ><a id="_License_778"></a>📄 License</h2>
<p class="has-line-data" data-line-start="780" data-line-end="781">This project is licensed under the MIT License - see the <a href="LICENSE">LICENSE</a> file for details.</p>
<h2 class="code-line" data-line-start=782 data-line-end=783 ><a id="_Acknowledgments_782"></a>🙏 Acknowledgments</h2>
<ul>
<li class="has-line-data" data-line-start="784" data-line-end="785">AWS for comprehensive cloud services</li>
<li class="has-line-data" data-line-start="785" data-line-end="786">Terraform for infrastructure as code</li>
<li class="has-line-data" data-line-start="786" data-line-end="787">Python community for monitoring tools</li>
<li class="has-line-data" data-line-start="787" data-line-end="789">Open source contributors</li>
</ul>
<hr>
<h2 class="code-line" data-line-start=791 data-line-end=792 ><a id="_Support_791"></a>📞 Support</h2>
<p class="has-line-data" data-line-start="793" data-line-end="794">For questions, issues, or contributions:</p>
<ul>
<li class="has-line-data" data-line-start="794" data-line-end="795"><strong>Issues</strong>: Create GitHub issues for bugs or feature requests</li>
<li class="has-line-data" data-line-start="795" data-line-end="796"><strong>Discussions</strong>: Use GitHub discussions for questions</li>
<li class="has-line-data" data-line-start="796" data-line-end="798"><strong>Email</strong>: Contact the maintainers for urgent issues</li>
</ul>
<hr>
<p class="has-line-data" data-line-start="800" data-line-end="801"><strong>🚀 Ready to deploy your production-ready AWS infrastructure with automated monitoring?</strong></p>
<pre><code class="has-line-data" data-line-start="803" data-line-end="809" class="language-bash">git <span class="hljs-built_in">clone</span> &lt;repository-url&gt;
<span class="hljs-built_in">cd</span> aws-infrastructure
terraform init
terraform apply
python3 server_monitor.py
</code></pre>
<p class="has-line-data" data-line-start="810" data-line-end="811"><strong>Happy cloud building!</strong> ☁️</p>
