# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}

# Configure the AWS Provider region
provider "aws" {
  region = var.aws_region
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-vpc-main"
  })
}

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-vpc-igw"
  })
}

# Create Public Subnets
resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-vpc-public-1a"
    Type = "Public"
  })
}

resource "aws_subnet" "public_1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-vpc-public-1b"
    Type = "Public"
  })
}

# Create Private Subnets
resource "aws_subnet" "private_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[0]
  availability_zone = var.availability_zones[0]

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-vpc-private-1a"
    Type = "Private"
  })
}

resource "aws_subnet" "private_1b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[1]
  availability_zone = var.availability_zones[1]

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-vpc-private-1b"
    Type = "Private"
  })
}

# Create Elastic IPs for NAT Gateways
resource "aws_eip" "nat_1a" {
  domain = "vpc"
  depends_on = [aws_internet_gateway.main]

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-vpc-eip-nat-1a"
  })
}

resource "aws_eip" "nat_1b" {
  domain = "vpc"
  depends_on = [aws_internet_gateway.main]

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-vpc-eip-nat-1b"
  })
}

# Create NAT Gateways
resource "aws_nat_gateway" "nat_1a" {
  allocation_id = aws_eip.nat_1a.id
  subnet_id     = aws_subnet.public_1a.id

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-vpc-nat-1a"
  })

  depends_on = [aws_internet_gateway.main]
}

resource "aws_nat_gateway" "nat_1b" {
  allocation_id = aws_eip.nat_1b.id
  subnet_id     = aws_subnet.public_1b.id

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-vpc-nat-1b"
  })

  depends_on = [aws_internet_gateway.main]
}

# Create Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-vpc-rt-public"
  })
}

# Create Private Route Tables
resource "aws_route_table" "private_1a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1a.id
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-vpc-rt-private-1a"
  })
}

resource "aws_route_table" "private_1b" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1b.id
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-vpc-rt-private-1b"
  })
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_1b" {
  subnet_id      = aws_subnet.public_1b.id
  route_table_id = aws_route_table.public.id
}

# Associate Private Subnets with Private Route Tables
resource "aws_route_table_association" "private_1a" {
  subnet_id      = aws_subnet.private_1a.id
  route_table_id = aws_route_table.private_1a.id
}

resource "aws_route_table_association" "private_1b" {
  subnet_id      = aws_subnet.private_1b.id
  route_table_id = aws_route_table.private_1b.id
}

# ==============================================================================
# DATA SOURCES
# ==============================================================================

# Get latest Ubuntu 22.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ==============================================================================
# IAM ROLES AND POLICIES
# ==============================================================================

# IAM Role for Web Servers
resource "aws_iam_role" "web_server_role" {
  name = "${var.project_name}-${var.environment}-web-server-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-web-server-role"
  })
}

# IAM Policy for Web Servers (least privilege)
resource "aws_iam_policy" "web_server_policy" {
  name        = "${var.project_name}-${var.environment}-web-server-policy"
  description = "Policy for web server instances"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics",
          "logs:PutLogEvents",
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "logs:DescribeLogStreams",
          "logs:DescribeLogGroups"
        ]
        Resource = "*"
      }
    ]
  })

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-web-server-policy"
  })
}

# Attach policy to web server role
resource "aws_iam_role_policy_attachment" "web_server_policy_attachment" {
  role       = aws_iam_role.web_server_role.name
  policy_arn = aws_iam_policy.web_server_policy.arn
}

# Instance profile for web servers
resource "aws_iam_instance_profile" "web_server_profile" {
  name = "${var.project_name}-${var.environment}-web-server-profile"
  role = aws_iam_role.web_server_role.name

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-web-server-profile"
  })
}

# IAM Role for App Servers
resource "aws_iam_role" "app_server_role" {
  name = "${var.project_name}-${var.environment}-app-server-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-app-server-role"
  })
}

# IAM Policy for App Servers (least privilege)
resource "aws_iam_policy" "app_server_policy" {
  name        = "${var.project_name}-${var.environment}-app-server-policy"
  description = "Policy for application server instances"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics",
          "logs:PutLogEvents",
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "logs:DescribeLogStreams",
          "logs:DescribeLogGroups",
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      }
    ]
  })

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-app-server-policy"
  })
}

# Attach policy to app server role
resource "aws_iam_role_policy_attachment" "app_server_policy_attachment" {
  role       = aws_iam_role.app_server_role.name
  policy_arn = aws_iam_policy.app_server_policy.arn
}

# Instance profile for app servers
resource "aws_iam_instance_profile" "app_server_profile" {
  name = "${var.project_name}-${var.environment}-app-server-profile"
  role = aws_iam_role.app_server_role.name

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-app-server-profile"
  })
}

# ==============================================================================
# SECURITY GROUPS
# ==============================================================================

# Web Security Group
resource "aws_security_group" "web" {
  name        = "${var.project_name}-${var.environment}-web-sg"
  description = "Security group for web servers"
  vpc_id      = aws_vpc.main.id

  # HTTP access from anywhere
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_http_cidrs
  }

  # HTTPS access from anywhere
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_https_cidrs
  }

  # SSH access from anywhere
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidrs
  }

  # ICMP access from anywhere
  ingress {
    description = "ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = var.allowed_icmp_cidrs
  }

  # Allow all outbound traffic
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-web-sg"
    Type = "Web"
  })
}

# Application Security Group
resource "aws_security_group" "app" {
  name        = "${var.project_name}-${var.environment}-app-sg"
  description = "Security group for application servers"
  vpc_id      = aws_vpc.main.id

  # Application port from Web Security Group only
  ingress {
    description     = "Application port ${var.app_port}"
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  # MySQL port from Web Security Group only
  ingress {
    description     = "MySQL from Web SG"
    from_port       = var.mysql_port
    to_port         = var.mysql_port
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  # Allow all outbound traffic
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-app-sg"
    Type = "Application"
  })
}

# Database Security Group
resource "aws_security_group" "db" {
  name        = "${var.project_name}-${var.environment}-db-sg"
  description = "Security group for database servers"
  vpc_id      = aws_vpc.main.id

  # MySQL port from Application Security Group only
  ingress {
    description     = "MySQL from Application SG"
    from_port       = var.mysql_port
    to_port         = var.mysql_port
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  # Allow all outbound traffic
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-db-sg"
    Type = "Database"
  })
}

# ==============================================================================
# EC2 INSTANCES
# ==============================================================================

# Web Server 1 (Ubuntu 22.04 in AZ 1a)
resource "aws_instance" "web_server_1a" {
  ami                    = var.web_server_os == "ubuntu" ? data.aws_ami.ubuntu.id : data.aws_ami.amazon_linux.id
  instance_type          = var.web_instance_type
  subnet_id              = aws_subnet.public_1a.id
  vpc_security_group_ids = [aws_security_group.web.id]
  iam_instance_profile   = aws_iam_instance_profile.web_server_profile.name
  key_name               = var.key_pair_name

  user_data = base64encode(templatefile("${path.module}/user_data/web_server_${var.web_server_os}.sh", {
    web_server_type = var.web_server_type
  }))

  root_block_device {
    volume_type = "gp3"
    volume_size = var.web_root_volume_size
    encrypted   = true
    tags = merge(var.common_tags, {
      Name = "${var.project_name}-${var.environment}-web-1a-root"
    })
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-web-1a"
    Type = "WebServer"
    AZ   = "1a"
  })
}

# Web Server 2 (Ubuntu 22.04 in AZ 1b)
resource "aws_instance" "web_server_1b" {
  ami                    = var.web_server_os == "ubuntu" ? data.aws_ami.ubuntu.id : data.aws_ami.amazon_linux.id
  instance_type          = var.web_instance_type
  subnet_id              = aws_subnet.public_1b.id
  vpc_security_group_ids = [aws_security_group.web.id]
  iam_instance_profile   = aws_iam_instance_profile.web_server_profile.name
  key_name               = var.key_pair_name

  user_data = base64encode(templatefile("${path.module}/user_data/web_server_${var.web_server_os}.sh", {
    web_server_type = var.web_server_type
  }))

  root_block_device {
    volume_type = "gp3"
    volume_size = var.web_root_volume_size
    encrypted   = true
    tags = merge(var.common_tags, {
      Name = "${var.project_name}-${var.environment}-web-1b-root"
    })
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-web-1b"
    Type = "WebServer"
    AZ   = "1b"
  })
}

# Application Server 1 (in private subnet 1a)
resource "aws_instance" "app_server_1a" {
  ami                    = var.app_server_os == "ubuntu" ? data.aws_ami.ubuntu.id : data.aws_ami.amazon_linux.id
  instance_type          = var.app_instance_type
  subnet_id              = aws_subnet.private_1a.id
  vpc_security_group_ids = [aws_security_group.app.id]
  iam_instance_profile   = aws_iam_instance_profile.app_server_profile.name
  key_name               = var.key_pair_name

  user_data = base64encode(templatefile("${path.module}/user_data/app_server_${var.app_server_os}.sh", {
    app_port = var.app_port
  }))

  root_block_device {
    volume_type = "gp3"
    volume_size = var.app_root_volume_size
    encrypted   = true
    tags = merge(var.common_tags, {
      Name = "${var.project_name}-${var.environment}-app-1a-root"
    })
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-app-1a"
    Type = "AppServer"
    AZ   = "1a"
    BackupEnabled = "true"
  })
}

# Application Server 2 (in private subnet 1b)
resource "aws_instance" "app_server_1b" {
  ami                    = var.app_server_os == "ubuntu" ? data.aws_ami.ubuntu.id : data.aws_ami.amazon_linux.id
  instance_type          = var.app_instance_type
  subnet_id              = aws_subnet.private_1b.id
  vpc_security_group_ids = [aws_security_group.app.id]
  iam_instance_profile   = aws_iam_instance_profile.app_server_profile.name
  key_name               = var.key_pair_name

  user_data = base64encode(templatefile("${path.module}/user_data/app_server_${var.app_server_os}.sh", {
    app_port = var.app_port
  }))

  root_block_device {
    volume_type = "gp3"
    volume_size = var.app_root_volume_size
    encrypted   = true
    tags = merge(var.common_tags, {
      Name = "${var.project_name}-${var.environment}-app-1b-root"
    })
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-app-1b"
    Type = "AppServer"
    AZ   = "1b"
    BackupEnabled = "true"
  })
}

# ==============================================================================
# RDS DATABASE
# ==============================================================================

# Create DB subnet group
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = [aws_subnet.private_1a.id, aws_subnet.private_1b.id]

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
  })
}

# Create DB parameter group
resource "aws_db_parameter_group" "main" {
  family = var.db_parameter_group_family
  name   = "${var.project_name}-${var.environment}-db-params"

  parameter {
    name  = "innodb_buffer_pool_size"
    value = "{DBInstanceClassMemory*3/4}"
  }

  parameter {
    name  = "max_connections"
    value = var.db_max_connections
  }

  parameter {
    name  = "slow_query_log"
    value = "1"
  }

  parameter {
    name  = "long_query_time"
    value = "2"
  }

  parameter {
    name  = "general_log"
    value = "0"
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-db-params"
  })
}

# Generate random password for database if not provided
resource "random_password" "db_password" {
  count   = var.db_password == "" ? 1 : 0
  length  = 16
  special = true
}

# Create RDS MySQL instance
resource "aws_db_instance" "main" {
  identifier = "${var.project_name}-${var.environment}-mysql"

  # Engine configuration
  engine            = "mysql"
  engine_version    = var.db_engine_version
  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  storage_type      = var.db_storage_type
  storage_encrypted = true
  kms_key_id        = aws_kms_key.rds.arn

  # Database configuration
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password != "" ? var.db_password : random_password.db_password[0].result

  # Network configuration
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db.id]
  publicly_accessible    = false
  port                   = var.mysql_port

  # High Availability
  multi_az = var.db_multi_az

  # Backup configuration
  backup_retention_period = var.db_backup_retention_period
  backup_window          = var.db_backup_window
  copy_tags_to_snapshot  = true
  delete_automated_backups = false

  # Maintenance
  maintenance_window      = var.db_maintenance_window
  auto_minor_version_upgrade = var.db_auto_minor_version_upgrade

  # Monitoring
  monitoring_interval = var.db_monitoring_interval
  monitoring_role_arn = var.db_monitoring_interval > 0 ? aws_iam_role.rds_monitoring[0].arn : null
  enabled_cloudwatch_logs_exports = ["error", "general", "slow-query"]

  # Performance Insights
  performance_insights_enabled = var.db_performance_insights_enabled
  performance_insights_retention_period = var.db_performance_insights_enabled ? var.db_performance_insights_retention_period : null

  # Parameter group
  parameter_group_name = aws_db_parameter_group.main.name

  # Final snapshot
  final_snapshot_identifier = "${var.project_name}-${var.environment}-mysql-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
  skip_final_snapshot       = var.db_skip_final_snapshot

  # Deletion protection
  deletion_protection = var.db_deletion_protection

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-mysql"
    Type = "Database"
    BackupEnabled = "true"
  })

  depends_on = [
    aws_db_subnet_group.main,
    aws_security_group.db,
    aws_kms_key.rds
  ]
}

# Create KMS key for RDS encryption
resource "aws_kms_key" "rds" {
  description             = "KMS key for RDS encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-rds-kms-key"
  })
}

# Create KMS key alias
resource "aws_kms_alias" "rds" {
  name          = "alias/${var.project_name}-${var.environment}-rds"
  target_key_id = aws_kms_key.rds.key_id
}

# IAM role for RDS monitoring
resource "aws_iam_role" "rds_monitoring" {
  count = var.db_monitoring_interval > 0 ? 1 : 0
  name  = "${var.project_name}-${var.environment}-rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-rds-monitoring-role"
  })
}

# Attach policy to RDS monitoring role
resource "aws_iam_role_policy_attachment" "rds_monitoring" {
  count      = var.db_monitoring_interval > 0 ? 1 : 0
  role       = aws_iam_role.rds_monitoring[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# Store database password in AWS Secrets Manager
resource "aws_secretsmanager_secret" "db_password" {
  name        = "${var.project_name}-${var.environment}-mysql-credentials"
  description = "MySQL database credentials"
  
  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-mysql-credentials"
  })
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id = aws_secretsmanager_secret.db_password.id
  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password != "" ? var.db_password : random_password.db_password[0].result
    engine   = "mysql"
    host     = aws_db_instance.main.endpoint
    port     = var.mysql_port
    dbname   = var.db_name
  })
}

# ==============================================================================
# S3 BACKUP BUCKET
# ==============================================================================

# Generate random suffix for bucket name
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Create S3 bucket for backups
resource "aws_s3_bucket" "backup" {
  bucket = "${var.project_name}-backup-bucket-${random_string.bucket_suffix.result}"

  tags = merge(var.common_tags, {
    Name        = "${var.project_name}-backup-bucket-${random_string.bucket_suffix.result}"
    Purpose     = "Backup"
    Lifecycle   = "Managed"
  })
}

# Configure bucket versioning
resource "aws_s3_bucket_versioning" "backup" {
  bucket = aws_s3_bucket.backup.id
  versioning_configuration {
    status = var.s3_versioning_enabled ? "Enabled" : "Suspended"
  }
}

# Configure server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "backup" {
  bucket = aws_s3_bucket.backup.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.s3_encryption_algorithm
    }
    bucket_key_enabled = var.s3_bucket_key_enabled
  }
}

# Configure lifecycle rules
resource "aws_s3_bucket_lifecycle_configuration" "backup" {
  bucket = aws_s3_bucket.backup.id

  rule {
    id     = "backup_lifecycle"
    status = "Enabled"

    # Transition to Glacier after specified days
    transition {
      days          = var.s3_glacier_transition_days
      storage_class = "GLACIER"
    }

    # Transition to Deep Archive after specified days (optional)
    dynamic "transition" {
      for_each = var.s3_deep_archive_transition_days > 0 ? [1] : []
      content {
        days          = var.s3_deep_archive_transition_days
        storage_class = "DEEP_ARCHIVE"
      }
    }

    # Delete objects after specified days
    expiration {
      days = var.s3_expiration_days
    }

    # Delete incomplete multipart uploads
    abort_incomplete_multipart_upload {
      days_after_initiation = var.s3_abort_incomplete_multipart_upload_days
    }

    # Handle non-current versions
    noncurrent_version_transition {
      noncurrent_days = var.s3_noncurrent_version_glacier_transition_days
      storage_class   = "GLACIER"
    }

    noncurrent_version_expiration {
      noncurrent_days = var.s3_noncurrent_version_expiration_days
    }
  }

  # Rule for cleaning up old delete markers
  rule {
    id     = "delete_markers_cleanup"
    status = "Enabled"

    expiration {
      expired_object_delete_marker = true
    }

    noncurrent_version_expiration {
      noncurrent_days = 1
    }
  }

  depends_on = [aws_s3_bucket_versioning.backup]
}

# Block all public access to the bucket
resource "aws_s3_bucket_public_access_block" "backup" {
  bucket = aws_s3_bucket.backup.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Configure bucket notification (optional)
resource "aws_s3_bucket_notification" "backup" {
  count  = var.s3_enable_notifications ? 1 : 0
  bucket = aws_s3_bucket.backup.id

  # SNS topic notifications for object creation
  dynamic "topic" {
    for_each = var.s3_notification_topic_arn != "" ? [1] : []
    content {
      topic_arn = var.s3_notification_topic_arn
      events    = ["s3:ObjectCreated:*"]
    }
  }
}

# Configure bucket logging (optional)
resource "aws_s3_bucket_logging" "backup" {
  count  = var.s3_enable_access_logging ? 1 : 0
  bucket = aws_s3_bucket.backup.id

  target_bucket = var.s3_access_log_bucket != "" ? var.s3_access_log_bucket : aws_s3_bucket.backup.id
  target_prefix = var.s3_access_log_prefix
}

# Configure bucket policy for secure access
resource "aws_s3_bucket_policy" "backup" {
  bucket = aws_s3_bucket.backup.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "BackupBucketPolicy"
    Statement = [
      {
        Sid       = "DenyInsecureConnections"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.backup.arn,
          "${aws_s3_bucket.backup.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      },
      {
        Sid    = "AllowBackupOperations"
        Effect = "Allow"
        Principal = {
          AWS = [
            aws_iam_role.backup_role.arn,
            aws_iam_role.web_server_role.arn,
            aws_iam_role.app_server_role.arn
          ]
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.backup.arn,
          "${aws_s3_bucket.backup.arn}/*"
        ]
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.backup]
}

# IAM role for backup operations
resource "aws_iam_role" "backup_role" {
  name = "${var.project_name}-${var.environment}-backup-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = [
            "ec2.amazonaws.com",
            "backup.amazonaws.com"
          ]
        }
      }
    ]
  })

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-backup-role"
  })
}

# IAM policy for backup operations
resource "aws_iam_policy" "backup_policy" {
  name        = "${var.project_name}-${var.environment}-backup-policy"
  description = "Policy for backup operations to S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:GetBucketVersioning",
          "s3:PutObjectAcl",
          "s3:GetObjectAcl",
          "s3:RestoreObject"
        ]
        Resource = [
          aws_s3_bucket.backup.arn,
          "${aws_s3_bucket.backup.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListAllMyBuckets"
        ]
        Resource = "*"
      }
    ]
  })

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-backup-policy"
  })
}

# Attach backup policy to backup role
resource "aws_iam_role_policy_attachment" "backup_policy_attachment" {
  role       = aws_iam_role.backup_role.name
  policy_arn = aws_iam_policy.backup_policy.arn
}

# Create instance profile for backup role
resource "aws_iam_instance_profile" "backup_profile" {
  name = "${var.project_name}-${var.environment}-backup-profile"
  role = aws_iam_role.backup_role.name

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-backup-profile"
  })
}

# ==============================================================================
# APPLICATION LOAD BALANCER & AUTO SCALING
# ==============================================================================

# Security Group for Application Load Balancer
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-${var.environment}-alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = aws_vpc.main.id

  # HTTP inbound
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.alb_allowed_cidrs
    description = "HTTP access from allowed CIDRs"
  }

  # HTTPS inbound
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.alb_allowed_cidrs
    description = "HTTPS access from allowed CIDRs"
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-alb-sg"
  })
}

# Update Web Security Group to allow traffic from ALB
resource "aws_security_group_rule" "web_alb_http" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.web.id
  source_security_group_id = aws_security_group.alb.id
  description              = "HTTP from ALB"
}

resource "aws_security_group_rule" "web_alb_https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.web.id
  source_security_group_id = aws_security_group.alb.id
  description              = "HTTPS from ALB"
}

# Application Load Balancer
resource "aws_lb" "main" {
  name               = "${var.project_name}-${var.environment}-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.public_1a.id, aws_subnet.public_1b.id]

  enable_deletion_protection = var.alb_deletion_protection

  # Access logs (optional)
  dynamic "access_logs" {
    for_each = var.alb_enable_access_logs ? [1] : []
    content {
      bucket  = var.alb_access_logs_bucket
      prefix  = var.alb_access_logs_prefix
      enabled = true
    }
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-alb"
  })
}

# Target Group for Web Servers
resource "aws_lb_target_group" "web" {
  name     = "${var.project_name}-${var.environment}-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  # Health check configuration
  health_check {
    enabled             = true
    healthy_threshold   = var.alb_health_check_healthy_threshold
    unhealthy_threshold = var.alb_health_check_unhealthy_threshold
    timeout             = var.alb_health_check_timeout
    interval            = var.alb_health_check_interval
    path                = var.alb_health_check_path
    matcher             = var.alb_health_check_matcher
    port                = "traffic-port"
    protocol            = "HTTP"
  }

  # Stickiness configuration
  dynamic "stickiness" {
    for_each = var.alb_enable_stickiness ? [1] : []
    content {
      type            = "lb_cookie"
      cookie_duration = var.alb_stickiness_duration
      enabled         = true
    }
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-web-tg"
  })
}

# HTTP Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  dynamic "default_action" {
    for_each = var.alb_redirect_http_to_https ? [1] : []
    content {
      type = "redirect"
      redirect {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  }

  dynamic "default_action" {
    for_each = var.alb_redirect_http_to_https ? [] : [1]
    content {
      type             = "forward"
      target_group_arn = aws_lb_target_group.web.arn
    }
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-http-listener"
  })
}

# HTTPS Listener (conditional)
resource "aws_lb_listener" "https" {
  count             = var.alb_enable_https ? 1 : 0
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.alb_ssl_policy
  certificate_arn   = var.alb_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-https-listener"
  })
}

# Launch Template for Auto Scaling Group
resource "aws_launch_template" "web" {
  name_prefix   = "${var.project_name}-${var.environment}-web-"
  image_id      = var.web_server_os == "ubuntu" ? data.aws_ami.ubuntu.id : data.aws_ami.amazon_linux.id
  instance_type = var.web_instance_type
  key_name      = var.key_pair_name

  vpc_security_group_ids = [aws_security_group.web.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.web_server_profile.name
  }

  user_data = base64encode(
    var.web_server_os == "ubuntu" ? 
    templatefile("${path.module}/user_data/web_server_ubuntu.sh", {
      web_server_type = var.web_server_type
    }) : 
    templatefile("${path.module}/user_data/web_server_amazon_linux.sh", {
      web_server_type = var.web_server_type
    })
  )

  block_device_mappings {
    device_name = var.web_server_os == "ubuntu" ? "/dev/sda1" : "/dev/xvda"
    ebs {
      volume_size = var.web_root_volume_size
      volume_type = var.web_root_volume_type
      encrypted   = true
    }
  }

  monitoring {
    enabled = var.enable_detailed_monitoring
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(var.common_tags, {
      Name = "${var.project_name}-${var.environment}-web-asg"
      BackupEnabled = "true"
    })
  }

  tag_specifications {
    resource_type = "volume"
    tags = merge(var.common_tags, {
      Name = "${var.project_name}-${var.environment}-web-asg-volume"
      BackupEnabled = "true"
    })
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-web-launch-template"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "web" {
  name                = "${var.project_name}-${var.environment}-web-asg"
  vpc_zone_identifier = [aws_subnet.public_1a.id, aws_subnet.public_1b.id]
  target_group_arns   = [aws_lb_target_group.web.arn]
  health_check_type   = "ELB"
  health_check_grace_period = var.asg_health_check_grace_period

  min_size         = var.asg_min_size
  max_size         = var.asg_max_size
  desired_capacity = var.asg_desired_capacity

  # Launch template configuration
  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  # Instance refresh configuration
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = var.asg_instance_refresh_min_healthy_percentage
      instance_warmup        = var.asg_instance_warmup
    }
  }

  # Tags for ASG and instances
  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-web-asg"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.common_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Scale Out Policy (CPU > 60%)
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "${var.project_name}-${var.environment}-scale-out"
  scaling_adjustment     = var.asg_scale_out_adjustment
  adjustment_type        = "ChangeInCapacity"
  cooldown              = var.asg_scale_out_cooldown
  autoscaling_group_name = aws_autoscaling_group.web.name

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-scale-out-policy"
  })
}

# Scale In Policy (CPU < 30%)
resource "aws_autoscaling_policy" "scale_in" {
  name                   = "${var.project_name}-${var.environment}-scale-in"
  scaling_adjustment     = var.asg_scale_in_adjustment
  adjustment_type        = "ChangeInCapacity"
  cooldown              = var.asg_scale_in_cooldown
  autoscaling_group_name = aws_autoscaling_group.web.name

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-scale-in-policy"
  })
}

# CloudWatch Alarm for Scale Out (CPU > 60%)
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.project_name}-${var.environment}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.asg_cpu_high_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.asg_cpu_high_period
  statistic           = "Average"
  threshold           = var.asg_cpu_high_threshold
  alarm_description   = "This metric monitors ec2 cpu utilization for scale out"
  alarm_actions       = [aws_autoscaling_policy.scale_out.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-cpu-high-alarm"
  })
}

# CloudWatch Alarm for Scale In (CPU < 30%)
resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "${var.project_name}-${var.environment}-cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.asg_cpu_low_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.asg_cpu_low_period
  statistic           = "Average"
  threshold           = var.asg_cpu_low_threshold
  alarm_description   = "This metric monitors ec2 cpu utilization for scale in"
  alarm_actions       = [aws_autoscaling_policy.scale_in.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-cpu-low-alarm"
  })
}

# CloudWatch Alarm for ALB Target Health
resource "aws_cloudwatch_metric_alarm" "alb_target_health" {
  alarm_name          = "${var.project_name}-${var.environment}-alb-unhealthy-targets"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.alb_unhealthy_target_evaluation_periods
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = var.alb_unhealthy_target_period
  statistic           = "Average"
  threshold           = var.alb_unhealthy_target_threshold
  alarm_description   = "This metric monitors ALB healthy target count"
  treat_missing_data  = "notBreaching"

  dimensions = {
    TargetGroup  = aws_lb_target_group.web.arn_suffix
    LoadBalancer = aws_lb.main.arn_suffix
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-alb-unhealthy-targets"
  })
}

# Optional: Remove the standalone web server instances since they're now managed by ASG
# Comment out or remove the individual web server instances
# resource "aws_instance" "web_server_1a" { ... }
# resource "aws_instance" "web_server_1b" { ... }

# ==============================================================================
# CLOUDWATCH MONITORING & ALERTS
# ==============================================================================

# SNS Topic for Alerts
resource "aws_sns_topic" "alerts" {
  name = "${var.project_name}-alerts"

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-alerts"
  })
}

# SNS Topic Subscription for Email Alerts
resource "aws_sns_topic_subscription" "email_alerts" {
  count     = var.alert_email != "" ? 1 : 0
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# CloudWatch Log Group for VPC Flow Logs
resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "/aws/vpc/flowlogs"
  retention_in_days = var.flow_logs_retention_days

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-vpc-flow-logs"
  })
}

# CloudWatch Log Group for CloudTrail
resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = "/aws/cloudtrail/${var.project_name}"
  retention_in_days = var.cloudtrail_retention_days

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-cloudtrail-logs"
  })
}

# IAM Role for VPC Flow Logs
resource "aws_iam_role" "vpc_flow_logs_role" {
  name = "${var.project_name}-${var.environment}-vpc-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-vpc-flow-logs-role"
  })
}

# IAM Policy for VPC Flow Logs
resource "aws_iam_role_policy" "vpc_flow_logs_policy" {
  name = "${var.project_name}-${var.environment}-vpc-flow-logs-policy"
  role = aws_iam_role.vpc_flow_logs_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      }
    ]
  })
}

# IAM Role for CloudTrail
resource "aws_iam_role" "cloudtrail_role" {
  name = "${var.project_name}-${var.environment}-cloudtrail-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-cloudtrail-role"
  })
}

# IAM Policy for CloudTrail
resource "aws_iam_role_policy" "cloudtrail_policy" {
  name = "${var.project_name}-${var.environment}-cloudtrail-policy"
  role = aws_iam_role.cloudtrail_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
      }
    ]
  })
}

# S3 Bucket for CloudTrail Logs
resource "aws_s3_bucket" "cloudtrail_logs" {
  bucket = "${var.project_name}-cloudtrail-logs-${random_string.bucket_suffix.result}"

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-cloudtrail-logs-${random_string.bucket_suffix.result}"
  })
}

# S3 Bucket Versioning for CloudTrail
resource "aws_s3_bucket_versioning" "cloudtrail_logs" {
  bucket = aws_s3_bucket.cloudtrail_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket Encryption for CloudTrail
resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail_logs" {
  bucket = aws_s3_bucket.cloudtrail_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 Bucket Public Access Block for CloudTrail
resource "aws_s3_bucket_public_access_block" "cloudtrail_logs" {
  bucket = aws_s3_bucket.cloudtrail_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 Bucket Policy for CloudTrail
resource "aws_s3_bucket_policy" "cloudtrail_logs" {
  bucket = aws_s3_bucket.cloudtrail_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSCloudTrailAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.cloudtrail_logs.arn
      },
      {
        Sid    = "AWSCloudTrailWrite"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.cloudtrail_logs.arn}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.cloudtrail_logs]
}

# CloudTrail
resource "aws_cloudtrail" "main" {
  name           = "${var.project_name}-${var.environment}-cloudtrail"
  s3_bucket_name = aws_s3_bucket.cloudtrail_logs.id

  # CloudWatch Logs integration
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_role.arn

  # Enable logging for management and data events
  include_global_service_events = true
  is_multi_region_trail         = var.cloudtrail_multi_region
  enable_logging               = true

  # Data events for S3 buckets
  event_selector {
    read_write_type           = "All"
    include_management_events = true

    # Monitor S3 data events
    data_resource {
      type   = "AWS::S3::Object"
      values = ["${aws_s3_bucket.backup.arn}/*"]
    }
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-cloudtrail"
  })

  depends_on = [aws_s3_bucket_policy.cloudtrail_logs]
}

# VPC Flow Logs
resource "aws_flow_log" "vpc_flow_logs" {
  iam_role_arn    = aws_iam_role.vpc_flow_logs_role.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_logs.arn
  traffic_type    = var.flow_logs_traffic_type
  vpc_id          = aws_vpc.main.id

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-vpc-flow-logs"
  })
}

# ==============================================================================
# CLOUDWATCH ALARMS
# ==============================================================================

# EC2 CPU Alarm (separate from ASG alarms)
resource "aws_cloudwatch_metric_alarm" "ec2_cpu_high" {
  alarm_name          = "${var.project_name}-${var.environment}-ec2-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.ec2_cpu_alarm_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.ec2_cpu_alarm_period
  statistic           = "Average"
  threshold           = var.ec2_cpu_alarm_threshold
  alarm_description   = "This metric monitors EC2 CPU utilization"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-ec2-cpu-high-alarm"
  })
}

# RDS CPU Alarm
resource "aws_cloudwatch_metric_alarm" "rds_cpu_high" {
  alarm_name          = "${var.project_name}-${var.environment}-rds-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.rds_cpu_alarm_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = var.rds_cpu_alarm_period
  statistic           = "Average"
  threshold           = var.rds_cpu_alarm_threshold
  alarm_description   = "This metric monitors RDS CPU utilization"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.main.id
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-rds-cpu-high-alarm"
  })
}

# RDS Database Connections Alarm
resource "aws_cloudwatch_metric_alarm" "rds_connections_high" {
  alarm_name          = "${var.project_name}-${var.environment}-rds-connections-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.rds_connections_alarm_evaluation_periods
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = var.rds_connections_alarm_period
  statistic           = "Average"
  threshold           = var.rds_connections_alarm_threshold
  alarm_description   = "This metric monitors RDS database connections"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.main.id
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-rds-connections-high-alarm"
  })
}

# RDS Free Storage Space Alarm
resource "aws_cloudwatch_metric_alarm" "rds_free_storage_low" {
  alarm_name          = "${var.project_name}-${var.environment}-rds-free-storage-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.rds_storage_alarm_evaluation_periods
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = var.rds_storage_alarm_period
  statistic           = "Average"
  threshold           = var.rds_storage_alarm_threshold
  alarm_description   = "This metric monitors RDS free storage space"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.main.id
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-rds-free-storage-low-alarm"
  })
}

# CloudWatch Metric Filter for Root Login Attempts
resource "aws_cloudwatch_log_metric_filter" "root_login_attempts" {
  name           = "${var.project_name}-root-login-attempts"
  log_group_name = aws_cloudwatch_log_group.cloudtrail.name
  pattern        = "{ ($.userIdentity.type = \"Root\") && ($.userIdentity.invokedBy NOT EXISTS) && ($.eventType != \"AwsServiceEvent\") }"

  metric_transformation {
    name          = "RootLoginAttempts"
    namespace     = "Security/Authentication"
    value         = "1"
    default_value = "0"
  }
}

# CloudWatch Alarm for Root Login Attempts
resource "aws_cloudwatch_metric_alarm" "root_login_attempts" {
  alarm_name          = "${var.project_name}-${var.environment}-root-login-attempts"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.root_login_alarm_evaluation_periods
  metric_name         = "RootLoginAttempts"
  namespace           = "Security/Authentication"
  period              = var.root_login_alarm_period
  statistic           = "Sum"
  threshold           = var.root_login_alarm_threshold
  alarm_description   = "This metric monitors root account login attempts"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  treat_missing_data  = "notBreaching"

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-root-login-attempts-alarm"
  })
}

# CloudWatch Metric Filter for Security Group Changes
resource "aws_cloudwatch_log_metric_filter" "security_group_changes" {
  name           = "${var.project_name}-security-group-changes"
  log_group_name = aws_cloudwatch_log_group.cloudtrail.name
  pattern        = "{ ($.eventName = AuthorizeSecurityGroupIngress) || ($.eventName = AuthorizeSecurityGroupEgress) || ($.eventName = RevokeSecurityGroupIngress) || ($.eventName = RevokeSecurityGroupEgress) || ($.eventName = CreateSecurityGroup) || ($.eventName = DeleteSecurityGroup) }"

  metric_transformation {
    name          = "SecurityGroupChanges"
    namespace     = "Security/Network"
    value         = "1"
    default_value = "0"
  }
}

# CloudWatch Alarm for Security Group Changes
resource "aws_cloudwatch_metric_alarm" "security_group_changes" {
  alarm_name          = "${var.project_name}-${var.environment}-security-group-changes"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.security_group_alarm_evaluation_periods
  metric_name         = "SecurityGroupChanges"
  namespace           = "Security/Network"
  period              = var.security_group_alarm_period
  statistic           = "Sum"
  threshold           = var.security_group_alarm_threshold
  alarm_description   = "This metric monitors security group configuration changes"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  treat_missing_data  = "notBreaching"

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-security-group-changes-alarm"
  })
}

# CloudWatch Metric Filter for Console Login Failures
resource "aws_cloudwatch_log_metric_filter" "console_login_failures" {
  name           = "${var.project_name}-console-login-failures"
  log_group_name = aws_cloudwatch_log_group.cloudtrail.name
  pattern        = "{ ($.eventName = ConsoleLogin) && ($.errorMessage EXISTS) }"

  metric_transformation {
    name          = "ConsoleLoginFailures"
    namespace     = "Security/Authentication"
    value         = "1"
    default_value = "0"
  }
}

# CloudWatch Alarm for Console Login Failures
resource "aws_cloudwatch_metric_alarm" "console_login_failures" {
  alarm_name          = "${var.project_name}-${var.environment}-console-login-failures"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.console_login_alarm_evaluation_periods
  metric_name         = "ConsoleLoginFailures"
  namespace           = "Security/Authentication"
  period              = var.console_login_alarm_period
  statistic           = "Sum"
  threshold           = var.console_login_alarm_threshold
  alarm_description   = "This metric monitors console login failures"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  treat_missing_data  = "notBreaching"

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-console-login-failures-alarm"
  })
}

# CloudWatch Metric Filter for Unauthorized API Calls
resource "aws_cloudwatch_log_metric_filter" "unauthorized_api_calls" {
  name           = "${var.project_name}-unauthorized-api-calls"
  log_group_name = aws_cloudwatch_log_group.cloudtrail.name
  pattern        = "{ ($.errorCode = \"*UnauthorizedOperation\") || ($.errorCode = \"AccessDenied*\") }"

  metric_transformation {
    name          = "UnauthorizedAPICalls"
    namespace     = "Security/Authorization"
    value         = "1"
    default_value = "0"
  }
}

# CloudWatch Alarm for Unauthorized API Calls
resource "aws_cloudwatch_metric_alarm" "unauthorized_api_calls" {
  alarm_name          = "${var.project_name}-${var.environment}-unauthorized-api-calls"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.unauthorized_api_alarm_evaluation_periods
  metric_name         = "UnauthorizedAPICalls"
  namespace           = "Security/Authorization"
  period              = var.unauthorized_api_alarm_period
  statistic           = "Sum"
  threshold           = var.unauthorized_api_alarm_threshold
  alarm_description   = "This metric monitors unauthorized API calls"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  treat_missing_data  = "notBreaching"

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-unauthorized-api-calls-alarm"
  })
}

# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-${var.environment}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", aws_autoscaling_group.web.name],
            ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", aws_db_instance.main.id],
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", aws_lb.main.arn_suffix],
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", aws_lb.main.arn_suffix]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "System Overview"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["Security/Authentication", "RootLoginAttempts"],
            ["Security/Network", "SecurityGroupChanges"],
            ["Security/Authentication", "ConsoleLoginFailures"],
            ["Security/Authorization", "UnauthorizedAPICalls"]
          ]
          period = 300
          stat   = "Sum"
          region = var.aws_region
          title  = "Security Metrics"
        }
      }
    ]
  })
}

# ==============================================================================
# AWS BACKUP CONFIGURATION
# ==============================================================================

# AWS Backup Vault
resource "aws_backup_vault" "main" {
  name        = "${var.project_name}-${var.environment}-backup-vault"
  kms_key_arn = aws_kms_key.backup_vault.arn

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-backup-vault"
  })
}

# KMS Key for Backup Vault Encryption
resource "aws_kms_key" "backup_vault" {
  description             = "KMS key for ${var.project_name} backup vault encryption"
  deletion_window_in_days = var.backup_kms_deletion_window
  enable_key_rotation     = true

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-backup-vault-key"
  })
}

# KMS Key Alias for Backup Vault
resource "aws_kms_alias" "backup_vault" {
  name          = "alias/${var.project_name}-${var.environment}-backup-vault"
  target_key_id = aws_kms_key.backup_vault.key_id
}

# AWS Backup Vault Policy
resource "aws_backup_vault_policy" "main" {
  backup_vault_name = aws_backup_vault.main.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "BackupVaultAccess"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = [
          "backup:DescribeBackupVault",
          "backup:DeleteBackupVault",
          "backup:PutBackupVaultAccessPolicy",
          "backup:DeleteBackupVaultAccessPolicy",
          "backup:GetBackupVaultAccessPolicy",
          "backup:StartBackupJob",
          "backup:GetBackupVaultNotifications",
          "backup:PutBackupVaultNotifications"
        ]
        Resource = aws_backup_vault.main.arn
      }
    ]
  })
}

# AWS Backup Plan
resource "aws_backup_plan" "main" {
  name = "${var.project_name}-${var.environment}-backup-plan"

  rule {
    rule_name         = "daily_backup_rule"
    target_vault_name = aws_backup_vault.main.name
    schedule          = var.backup_schedule_expression
    start_window      = var.backup_start_window
    completion_window = var.backup_completion_window

    lifecycle {
      cold_storage_after = var.backup_cold_storage_after
      delete_after       = var.backup_delete_after
    }

    recovery_point_tags = merge(var.common_tags, var.backup_recovery_point_tags)

    copy_action {
      destination_vault_arn = aws_backup_vault.main.arn
      lifecycle {
        cold_storage_after = var.backup_copy_cold_storage_after
        delete_after       = var.backup_copy_delete_after
      }
    }
  }

  # Weekly backup rule for long-term retention
  rule {
    rule_name         = "weekly_backup_rule"
    target_vault_name = aws_backup_vault.main.name
    schedule          = var.backup_weekly_schedule_expression
    start_window      = var.backup_start_window
    completion_window = var.backup_completion_window

    lifecycle {
      cold_storage_after = var.backup_weekly_cold_storage_after
      delete_after       = var.backup_weekly_delete_after
    }

    recovery_point_tags = merge(var.common_tags, var.backup_recovery_point_tags, {
      BackupType = "Weekly"
    })
  }

  # Monthly backup rule for compliance
  rule {
    rule_name         = "monthly_backup_rule"
    target_vault_name = aws_backup_vault.main.name
    schedule          = var.backup_monthly_schedule_expression
    start_window      = var.backup_start_window
    completion_window = var.backup_completion_window

    lifecycle {
      cold_storage_after = var.backup_monthly_cold_storage_after
      delete_after       = var.backup_monthly_delete_after
    }

    recovery_point_tags = merge(var.common_tags, var.backup_recovery_point_tags, {
      BackupType = "Monthly"
    })
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-backup-plan"
  })
}

# IAM Role for AWS Backup
resource "aws_iam_role" "backup_service_role" {
  name = "${var.project_name}-${var.environment}-backup-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "backup.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-backup-service-role"
  })
}

# Attach AWS Backup service role policy
resource "aws_iam_role_policy_attachment" "backup_service_policy" {
  role       = aws_iam_role.backup_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

# Attach AWS Backup service role for S3 policy
resource "aws_iam_role_policy_attachment" "backup_s3_service_policy" {
  role       = aws_iam_role.backup_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForS3Backup"
}

# Custom IAM Policy for Enhanced Backup Permissions
resource "aws_iam_role_policy" "backup_enhanced_policy" {
  name = "${var.project_name}-${var.environment}-backup-enhanced-policy"
  role = aws_iam_role.backup_service_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey",
          "kms:CreateGrant"
        ]
        Resource = [
          aws_kms_key.backup_vault.arn,
          aws_kms_key.rds.arn,
          aws_kms_key.backup.arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetBucketVersioning",
          "s3:GetBucketLocation",
          "s3:GetBucketAcl",
          "s3:GetBucketLogging",
          "s3:GetBucketNotification",
          "s3:GetBucketTagging",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:ListBucketVersions"
        ]
        Resource = [
          aws_s3_bucket.backup.arn,
          "${aws_s3_bucket.backup.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "tag:GetResources",
          "tag:TagResources",
          "tag:UntagResources",
          "tag:GetTagKeys",
          "tag:GetTagValues"
        ]
        Resource = "*"
      }
    ]
  })
}

# AWS Backup Selection for RDS
resource "aws_backup_selection" "rds" {
  iam_role_arn = aws_iam_role.backup_service_role.arn
  name         = "${var.project_name}-${var.environment}-rds-backup-selection"
  plan_id      = aws_backup_plan.main.id

  resources = [
    aws_db_instance.main.arn
  ]

  condition {
    string_equals {
      key   = "aws:ResourceTag/Environment"
      value = var.environment
    }
  }

  condition {
    string_equals {
      key   = "aws:ResourceTag/Project"
      value = var.project_name
    }
  }
}

# AWS Backup Selection for EC2 EBS Volumes
resource "aws_backup_selection" "ebs" {
  iam_role_arn = aws_iam_role.backup_service_role.arn
  name         = "${var.project_name}-${var.environment}-ebs-backup-selection"
  plan_id      = aws_backup_plan.main.id

  resources = ["*"]

  condition {
    string_equals {
      key   = "aws:ResourceTag/Environment"
      value = var.environment
    }
  }

  condition {
    string_equals {
      key   = "aws:ResourceTag/Project"
      value = var.project_name
    }
  }

  condition {
    string_equals {
      key   = "aws:ResourceTag/BackupEnabled"
      value = "true"
    }
  }
}

# AWS Backup Selection for S3 Bucket
resource "aws_backup_selection" "s3" {
  count        = var.backup_s3_enabled ? 1 : 0
  iam_role_arn = aws_iam_role.backup_service_role.arn
  name         = "${var.project_name}-${var.environment}-s3-backup-selection"
  plan_id      = aws_backup_plan.main.id

  resources = [
    aws_s3_bucket.backup.arn
  ]

  condition {
    string_equals {
      key   = "aws:ResourceTag/Environment"
      value = var.environment
    }
  }
}

# SNS Topic for Backup Notifications
resource "aws_sns_topic" "backup_notifications" {
  name = "${var.project_name}-${var.environment}-backup-notifications"

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-backup-notifications"
  })
}

# SNS Topic Subscription for Backup Notifications
resource "aws_sns_topic_subscription" "backup_email" {
  count     = var.backup_notification_email != "" ? 1 : 0
  topic_arn = aws_sns_topic.backup_notifications.arn
  protocol  = "email"
  endpoint  = var.backup_notification_email
}

# AWS Backup Vault Notifications
resource "aws_backup_vault_notifications" "main" {
  backup_vault_name   = aws_backup_vault.main.name
  sns_topic_arn       = aws_sns_topic.backup_notifications.arn
  backup_vault_events = var.backup_vault_events
}

# CloudWatch Log Group for Backup Events
resource "aws_cloudwatch_log_group" "backup_events" {
  name              = "/aws/backup/${var.project_name}-${var.environment}"
  retention_in_days = var.backup_log_retention_days

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-backup-events"
  })
}

# EventBridge Rule for Backup Events
resource "aws_cloudwatch_event_rule" "backup_events" {
  name        = "${var.project_name}-${var.environment}-backup-events"
  description = "Capture AWS Backup events"

  event_pattern = jsonencode({
    source      = ["aws.backup"]
    detail-type = ["Backup Job State Change"]
    detail = {
      state = var.backup_event_states
    }
  })

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-backup-events-rule"
  })
}

# EventBridge Target for Backup Events
resource "aws_cloudwatch_event_target" "backup_events_sns" {
  rule      = aws_cloudwatch_event_rule.backup_events.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.backup_notifications.arn
}

# CloudWatch Alarms for Backup Monitoring
resource "aws_cloudwatch_metric_alarm" "backup_job_failed" {
  alarm_name          = "${var.project_name}-${var.environment}-backup-job-failed"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.backup_alarm_evaluation_periods
  metric_name         = "NumberOfBackupJobsFailed"
  namespace           = "AWS/Backup"
  period              = var.backup_alarm_period
  statistic           = "Sum"
  threshold           = var.backup_alarm_threshold
  alarm_description   = "This metric monitors failed backup jobs"
  alarm_actions       = [aws_sns_topic.backup_notifications.arn]
  ok_actions          = [aws_sns_topic.backup_notifications.arn]

  dimensions = {
    BackupVaultName = aws_backup_vault.main.name
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-backup-job-failed-alarm"
  })
}

# Data source for current AWS account
data "aws_caller_identity" "current" {} 