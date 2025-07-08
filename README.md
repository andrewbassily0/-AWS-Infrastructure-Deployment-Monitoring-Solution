# 🏗️ AWS Infrastructure Deployment & Monitoring Solution

[![Terraform](https://img.shields.io/badge/Terraform-v1.5+-623CE4?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![Python](https://img.shields.io/badge/Python-3.7+-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

A comprehensive, production-ready AWS infrastructure solution combining Infrastructure as Code (Terraform) with automated server monitoring. This project delivers a complete 3-tier architecture with high availability, security, and compliance features.

## 📋 Table of Contents

- [🎯 Project Overview](#-project-overview)
- [🏛️ Architecture Summary](#-architecture-summary)
- [📁 Terraform Project Structure](#-terraform-project-structure)
- [🛠️ Resource List](#-resource-list)
- [🔐 Security & Compliance](#-security--compliance)
- [🔄 Backup & Disaster Recovery](#-backup--disaster-recovery)
- [🤖 Automation Script Usage](#-automation-script-usage)
- [📊 Monitoring and Alerts](#-monitoring-and-alerts)
- [💰 Cost Estimation Guidance](#-cost-estimation-guidance)
- [🚀 Quick Start](#-quick-start)
- [📚 Documentation](#-documentation)

## 🎯 Project Overview

This solution provides a complete AWS infrastructure deployment with automated monitoring capabilities, designed for production workloads requiring high availability, security, and compliance.

### **Key Features**
- **Infrastructure as Code**: Complete Terraform configuration for AWS resources
- **High Availability**: Multi-AZ deployment across eu-central-1a/1b
- **Security**: Defense-in-depth architecture with private subnets and security groups
- **Monitoring**: Automated server monitoring with GUI and console interfaces
- **Compliance**: ISO27001-aligned security controls and monitoring
- **Backup**: Automated backup strategy with multi-tier retention policies
- **Scalability**: Auto Scaling Groups with load balancing
- **Cost Optimization**: Resource optimization and cost monitoring

### **Use Cases**
- **Production Web Applications**: Scalable 3-tier architecture
- **Enterprise Infrastructure**: Compliance-ready cloud deployment
- **Development Environments**: Configurable resource sizing
- **Disaster Recovery**: Multi-region backup capabilities
- **Infrastructure Monitoring**: Real-time health checks and alerting

## 🏛️ Architecture Summary

### **Network and Infrastructure Architecture**
```
┌─────────────────────────────────────────────────────────────────┐
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
```

### **Security Architecture**
```
┌─────────────────────────────────────────────────────────────┐
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
```

### **Data Flow**
1. **User Request** → Application Load Balancer
2. **ALB** → Web Servers (Public Subnets)
3. **Web Servers** → Application Servers (Private Subnets)
4. **App Servers** → RDS Database (Private Subnets)
5. **Monitoring** → CloudWatch → SNS → Email Alerts

### **Monitoring Architecture**
```
┌─────────────────────────────────────────────────────────────┐
│                    Monitoring & Alerting                    │
│                                                             │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    │
│  │ Server      │    │ CloudWatch  │    │ SNS Topic   │    │
│  │ Monitor     │───▶│ Metrics     │───▶│ Email       │    │
│  │ (GUI/CLI)   │    │ & Alarms    │    │ Alerts      │    │
│  └─────────────┘    └─────────────┘    └─────────────┘    │
│                                                             │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    │
│  │ VPC Flow    │    │ CloudTrail  │    │ AWS Backup  │    │
│  │ Logs        │───▶│ API Logs    │───▶│ Recovery    │    │
│  │             │    │             │    │ Monitoring  │    │
│  └─────────────┘    └─────────────┘    └─────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

## 📁 Terraform Project Structure

```
aws-infrastructure/
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
├── 🖥️ Monitoring & Automation
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
```

### **Key Terraform Files**

#### **main.tf** - Core Infrastructure
- VPC and networking components
- Security groups and IAM roles
- EC2 instances and Auto Scaling Groups
- RDS database and S3 storage
- Application Load Balancer
- CloudWatch monitoring and AWS Backup

#### **variables.tf** - Configuration Parameters
- Environment-specific variables
- Resource sizing and naming
- Security and compliance settings
- Cost optimization parameters

#### **outputs.tf** - Infrastructure Endpoints
- Load balancer DNS names
- Database connection strings
- Monitoring endpoints
- Security group IDs

## 🛠️ Resource List

### **VPC & Networking**
| Resource | Type | Purpose | High Availability |
|----------|------|---------|------------------|
| **VPC** | AWS::EC2::VPC | Network isolation (10.0.0.0/16) | Single region |
| **Internet Gateway** | AWS::EC2::InternetGateway | Internet access | Managed by AWS |
| **NAT Gateways** | AWS::EC2::NatGateway | Private subnet internet | Multi-AZ (2) |
| **Public Subnets** | AWS::EC2::Subnet | Web tier (10.0.1.0/24, 10.0.2.0/24) | Multi-AZ |
| **Private Subnets** | AWS::EC2::Subnet | App/DB tier (10.0.11.0/24, 10.0.12.0/24) | Multi-AZ |
| **Route Tables** | AWS::EC2::RouteTable | Traffic routing | Multi-AZ |

### **EC2 Compute Resources**
| Resource | Type | Configuration | Auto Scaling |
|----------|------|---------------|-------------|
| **Web Servers** | EC2 Instances | Ubuntu 22.04/Amazon Linux 2 | ASG: 2-5 instances |
| **App Servers** | EC2 Instances | Ubuntu 22.04/Amazon Linux 2 | Static: 2 instances |
| **Application Load Balancer** | AWS::ELBv2::LoadBalancer | Multi-AZ with health checks | Managed by AWS |
| **Target Groups** | AWS::ELBv2::TargetGroup | HTTP/HTTPS routing | Auto-managed |
| **Launch Templates** | AWS::EC2::LaunchTemplate | Instance configuration | Version control |

### **Database & Storage**
| Resource | Type | Configuration | Backup Strategy |
|----------|------|---------------|----------------|
| **RDS MySQL** | AWS::RDS::DBInstance | Multi-AZ, encrypted | Automated + AWS Backup |
| **S3 Backup Bucket** | AWS::S3::Bucket | Versioned, encrypted | Lifecycle policies |
| **EBS Volumes** | AWS::EC2::Volume | gp3, encrypted | Snapshot backups |
| **DB Subnet Group** | AWS::RDS::DBSubnetGroup | Multi-AZ placement | Automatic |

### **Security Components**
| Resource | Type | Purpose | Compliance |
|----------|------|---------|------------|
| **Security Groups** | AWS::EC2::SecurityGroup | Network access control | ISO27001 aligned |
| **IAM Roles** | AWS::IAM::Role | Least privilege access | Principle of least privilege |
| **KMS Keys** | AWS::KMS::Key | Encryption at rest | Customer-managed |
| **VPC Flow Logs** | AWS::EC2::FlowLogs | Network monitoring | Audit trail |
| **Secrets Manager** | AWS::SecretsManager::Secret | Credential storage | Encrypted |

### **Monitoring & Alerting**
| Resource | Type | Purpose | Integration |
|----------|------|---------|-------------|
| **CloudWatch Alarms** | AWS::CloudWatch::Alarm | Threshold monitoring | SNS notifications |
| **CloudWatch Dashboard** | AWS::CloudWatch::Dashboard | Visual monitoring | Custom metrics |
| **SNS Topic** | AWS::SNS::Topic | Alert notifications | Email/SMS |
| **CloudTrail** | AWS::CloudTrail | API monitoring | Security events |
| **EventBridge Rules** | AWS::Events::Rule | Event-driven automation | Lambda triggers |

### **Backup & Recovery**
| Resource | Type | Retention | Recovery Time |
|----------|------|-----------|---------------|
| **AWS Backup Vault** | AWS::Backup::BackupVault | Multi-tier retention | < 30 minutes |
| **Backup Plans** | AWS::Backup::BackupPlan | Daily/Weekly/Monthly | Point-in-time recovery |
| **Cross-Region Replication** | AWS::S3::Bucket | 90-day retention | < 1 hour |
| **RDS Snapshots** | AWS::RDS::DBSnapshot | Automated + manual | < 15 minutes |

## 🔐 Security & Compliance

### **ISO27001 Alignment**
This infrastructure implements controls aligned with ISO27001 standards:

#### **A.9 - Access Control**
- ✅ **IAM Roles**: Least privilege access for all resources
- ✅ **MFA Requirements**: Multi-factor authentication for AWS accounts
- ✅ **Access Logging**: CloudTrail for all API calls
- ✅ **Role-Based Access**: Separate roles for web/app servers

#### **A.10 - Cryptography**
- ✅ **Encryption at Rest**: KMS encryption for RDS, S3, EBS
- ✅ **Encryption in Transit**: TLS 1.2+ for all communications
- ✅ **Key Management**: Customer-managed KMS keys with rotation
- ✅ **Certificate Management**: ACM for SSL/TLS certificates

#### **A.12 - Operations Security**
- ✅ **Network Segmentation**: Private subnets for sensitive resources
- ✅ **Monitoring**: CloudWatch, VPC Flow Logs, CloudTrail
- ✅ **Patch Management**: Automated security updates
- ✅ **Backup**: Automated backup with encryption

#### **A.13 - Communications Security**
- ✅ **Network Controls**: Security groups with minimal access
- ✅ **VPC Isolation**: Private network with controlled access
- ✅ **NAT Gateway**: Outbound internet access without inbound exposure
- ✅ **Load Balancer**: SSL termination with security headers

#### **A.17 - Information Security Continuity**
- ✅ **Multi-AZ Deployment**: High availability across zones
- ✅ **Automated Backup**: Daily backups with long-term retention
- ✅ **Disaster Recovery**: Cross-region replication
- ✅ **Monitoring**: 24/7 automated health checks

### **Security Best Practices Implemented**
```yaml
Network Security:
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

Monitoring & Compliance:
  - CloudTrail for API audit logging
  - CloudWatch for performance monitoring
  - SNS for real-time alerting
  - Security event correlation
```

## 🔄 Backup & Disaster Recovery Strategy

### **Multi-Tier Backup Strategy**
```yaml
Tier 1 - Daily Backups:
  Frequency: Every 24 hours at 23:00 UTC (2:00 AM Bahrain time)
  Retention: 30 days
  Storage: AWS Backup Vault (encrypted)
  Recovery Time: < 30 minutes
  Recovery Point: 24 hours

Tier 2 - Weekly Backups:
  Frequency: Every Sunday at 23:00 UTC
  Retention: 12 months
  Storage: Cold storage transition after 30 days
  Recovery Time: < 2 hours
  Recovery Point: 1 week

Tier 3 - Monthly Backups:
  Frequency: First Sunday of every month
  Retention: 7 years
  Storage: Glacier Deep Archive after 90 days
  Recovery Time: < 12 hours
  Recovery Point: 1 month
```

### **Backup Coverage**
| Resource | Backup Method | Schedule | Retention |
|----------|---------------|----------|-----------|
| **RDS Database** | AWS Backup + Automated Snapshots | Daily | 30 days |
| **EBS Volumes** | AWS Backup Snapshots | Daily | 30 days |
| **S3 Bucket** | Cross-Region Replication | Real-time | 90 days |
| **Application Code** | S3 Backup | Weekly | 1 year |
| **Configuration** | Version Control + S3 | On change | Indefinite |

### **Disaster Recovery Procedures**
```yaml
RTO (Recovery Time Objective): 2 hours
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
```

### **Business Continuity**
- **High Availability**: Multi-AZ deployment ensures 99.9% uptime
- **Automatic Failover**: RDS and ALB provide automatic failover
- **Scalability**: Auto Scaling handles traffic spikes
- **Monitoring**: 24/7 automated monitoring with alerts

## 🤖 Automation Script Usage

### **Server Monitoring Solution**
This project includes comprehensive server monitoring with two interfaces:

#### **GUI Application** (`server_monitor.py`)
```bash
# Prerequisites
sudo apt-get install python3-tk  # Linux only

# Configure email notifications
python3 setup_env.py

# Run GUI application
python3 server_monitor.py
```

**Features:**
- **Modern Interface**: tkinter-based GUI with real-time updates
- **Visual Indicators**: Green ✅ for online, Red ❌ for offline servers
- **Configuration**: Point-and-click server management
- **Notifications**: Email alerts with SMTP integration
- **Dashboard**: Real-time status updates with response times

#### **Console Application** (`server_monitor_console.py`)
```bash
# No additional dependencies required
python3 server_monitor_console.py
```

**Features:**
- **Headless Operation**: Perfect for servers without GUI
- **SSH Compatible**: Works over SSH connections
- **Colored Output**: Terminal-based visual indicators
- **Menu Driven**: Easy navigation and configuration
- **Background Mode**: Can run as a system service

### **Configuration & Setup**

#### **Email Configuration**
```bash
# Interactive setup wizard
python3 setup_env.py

# Manual environment variables
export SMTP_SERVER=smtp.gmail.com
export SMTP_PORT=587
export SMTP_USERNAME=your-email@gmail.com
export SMTP_PASSWORD=your-app-password
export SMTP_FROM=your-email@gmail.com
export SMTP_TO=admin@company.com
export SMTP_USE_TLS=true
```

#### **Supported Email Providers**
| Provider | SMTP Server | Port | Security |
|----------|-------------|------|----------|
| **Gmail** | smtp.gmail.com | 587 | TLS + App Password |
| **Outlook** | smtp.live.com | 587 | TLS + Standard Auth |
| **Yahoo** | smtp.mail.yahoo.com | 587 | TLS + App Password |
| **Custom** | Your SMTP server | 587/465 | TLS/SSL |

### **Automation Features**
```yaml
Real-time Monitoring:
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
```

### **Usage Examples**

#### **Basic Usage**
```bash
# Quick demo
python3 demo_usage.py

# Add servers to monitor
python3 server_monitor_console.py
# Select option 1 to add server
# Enter IP: 8.8.8.8
# Select option 4 to start monitoring
```

#### **Production Deployment**
```bash
# Install as system service
sudo systemctl enable server-monitor
sudo systemctl start server-monitor

# Monitor service status
sudo systemctl status server-monitor

# View logs
sudo journalctl -u server-monitor -f
```

## 📊 Monitoring and Alerts

### **CloudWatch Integration**
```yaml
Metrics Monitored:
  - EC2 CPU utilization and memory usage
  - RDS performance and connection counts
  - Application Load Balancer response times
  - Auto Scaling Group health and capacity
  - S3 bucket storage and requests
  - VPC Flow Logs analysis

Alarms Configured:
  - EC2 CPU > 70% (triggers scaling)
  - RDS CPU > 80% (performance alert)
  - ALB latency > 1000ms (performance alert)
  - Failed health checks (availability alert)
  - Disk space > 85% (storage alert)
  - Memory usage > 80% (memory alert)

Dashboards Available:
  - Infrastructure overview
  - Application performance
  - Security events
  - Cost optimization
```

### **Alert Configuration**
```yaml
Critical Alerts (Immediate):
  - Server unreachable (3 consecutive failures)
  - Database connection failures
  - Application Load Balancer failures
  - Security group changes
  - Root login attempts

Warning Alerts (15-minute delay):
  - High CPU usage (>70%)
  - High memory usage (>80%)
  - High disk usage (>85%)
  - Slow response times (>1000ms)

Informational Alerts (Daily):
  - Backup completion status
  - Cost optimization recommendations
  - Security audit summaries
  - Performance reports
```

### **Monitoring Architecture**
```yaml
Server-Level Monitoring:
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
```

### **Security Monitoring**
```yaml
Network Security:
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
```

## 💰 Cost Estimation Guidance

### **Monthly Cost Breakdown (eu-central-1)**
```yaml
Compute Resources:
  EC2 Instances (4x t3.medium): $85-120/month
  Application Load Balancer: $25-35/month
  NAT Gateways (2x): $60-80/month
  EBS Storage (200GB): $25-35/month
  Subtotal: $195-270/month

Database & Storage:
  RDS MySQL (Multi-AZ): $70-100/month
  S3 Backup Storage (100GB): $5-10/month
  EBS Snapshots: $15-25/month
  Subtotal: $90-135/month

Monitoring & Backup:
  CloudWatch Metrics: $15-25/month
  AWS Backup: $20-30/month
  SNS Notifications: $2-5/month
  VPC Flow Logs: $10-15/month
  Subtotal: $47-75/month

Total Estimated Cost: $332-480/month
```

### **AWS Pricing Calculator Integration**
Use the [AWS Pricing Calculator](https://calculator.aws/) to get precise estimates:

1. **VPC and Networking**
   - VPC: Free
   - NAT Gateways: $45.58/month each
   - Data Transfer: $0.09/GB

2. **EC2 Instances**
   - t3.medium: $30.37/month (Linux)
   - t3.large: $60.74/month (Linux)
   - EBS gp3: $0.08/GB-month

3. **RDS Database**
   - db.t3.micro: $13.14/month (Single-AZ)
   - db.t3.small: $26.28/month (Single-AZ)
   - Multi-AZ: 2x single-AZ cost

4. **Load Balancer**
   - Application Load Balancer: $22.27/month
   - Load Balancer Capacity Units: $0.008/hour

### **Cost Optimization Strategies**
```yaml
Reserved Instances:
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
```

### **Environment-Specific Costs**
| Environment | EC2 Instances | RDS | Monthly Cost |
|-------------|---------------|-----|--------------|
| **Development** | 2x t3.small | Single-AZ | $150-200 |
| **Staging** | 2x t3.medium | Single-AZ | $220-280 |
| **Production** | 4x t3.large | Multi-AZ | $400-600 |
| **High-Traffic** | 6x t3.xlarge | Multi-AZ | $800-1200 |

### **Cost Monitoring Setup**
```bash
# Set up billing alerts
aws budgets create-budget \
  --account-id ACCOUNT_ID \
  --budget file://budget.json

# Create cost allocation tags
aws resourcegroupstaggingapi tag-resources \
  --resource-arn-list arn:aws:ec2:region:account:instance/* \
  --tags Environment=Production,Project=WebApp
```

## 🚀 Quick Start

### **Prerequisites**
- AWS CLI configured with appropriate permissions
- Terraform v1.5+ installed
- Python 3.7+ for monitoring scripts
- Git for version control

### **1. Infrastructure Deployment**
```bash
# Clone the repository
git clone <repository-url>
cd aws-infrastructure

# Configure variables
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars  # Edit with your values

# Initialize Terraform
terraform init

# Plan deployment
terraform plan

# Apply infrastructure
terraform apply
```

### **2. Monitoring Setup**
```bash
# Configure email notifications
python3 setup_env.py

# Test monitoring (GUI version)
python3 server_monitor.py

# Or use console version (headless)
python3 server_monitor_console.py
```

### **3. Verification**
```bash
# Check infrastructure outputs
terraform output

# Test monitoring with demo
python3 demo_usage.py

# Access application
curl http://$(terraform output -raw alb_dns_name)
```

### **4. Production Readiness**
```bash
# Set up monitoring alerts
aws sns subscribe \
  --topic-arn $(terraform output -raw sns_topic_arn) \
  --protocol email \
  --notification-endpoint your-email@company.com

# Configure backup notifications
aws backup put-backup-vault-notifications \
  --backup-vault-name $(terraform output -raw backup_vault_name) \
  --sns-topic-arn $(terraform output -raw sns_topic_arn)
```

## 📚 Documentation

### **Comprehensive Guides**
- **[Installation Guide](INSTALLATION.md)** - Complete setup instructions
- **[Quick Start Guide](QUICK_START.md)** - 5-minute setup walkthrough
- **[Monitoring Documentation](SERVER_MONITOR_README.md)** - Comprehensive monitoring guide
- **[Terraform Variables](variables.tf)** - All configuration options
- **[Output Values](outputs.tf)** - Infrastructure endpoints and IDs

### **Architecture Documentation**
- Network topology and security groups
- Data flow and component relationships
- Backup and disaster recovery procedures
- Monitoring and alerting architecture

### **Configuration Examples**
- Development environment setup
- Production environment configuration
- Multi-region deployment options
- Custom monitoring configurations

### **Troubleshooting**
- Common deployment issues
- Monitoring setup problems
- Performance optimization
- Security configuration

## 🤝 Contributing

We welcome contributions to improve this infrastructure solution!

### **How to Contribute**
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

### **Areas for Contribution**
- Additional monitoring integrations
- Cost optimization improvements
- Security enhancements
- Documentation updates
- Bug fixes and improvements

### **Development Guidelines**
- Follow Terraform best practices
- Add comprehensive documentation
- Include test configurations
- Update cost estimates
- Validate security settings

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- AWS for comprehensive cloud services
- Terraform for infrastructure as code
- Python community for monitoring tools
- Open source contributors

---

## 📞 Support

For questions, issues, or contributions:
- **Issues**: Create GitHub issues for bugs or feature requests
- **Discussions**: Use GitHub discussions for questions
- **Email**: Contact the maintainers for urgent issues

---

**🚀 Ready to deploy your production-ready AWS infrastructure with automated monitoring?**

```bash
git clone <repository-url>
cd aws-infrastructure
terraform init
terraform apply
python3 server_monitor.py
```

**Happy cloud building!** ☁️ 