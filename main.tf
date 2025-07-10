# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
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
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-vpc-main"
  })
}

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-igw"
  })
}

# Create Public Subnets
resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-vpc-public-1a"
    Type = "Public"
  })
}

resource "aws_subnet" "public_1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true

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
  
  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-eip-nat-1a"
  })
  
  depends_on = [aws_internet_gateway.main]
}

resource "aws_eip" "nat_1b" {
  domain = "vpc"
  
  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-eip-nat-1b"
  })
  
  depends_on = [aws_internet_gateway.main]
}

# Create NAT Gateways
resource "aws_nat_gateway" "nat_1a" {
  allocation_id = aws_eip.nat_1a.id
  subnet_id     = aws_subnet.public_1a.id

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-nat-1a"
  })

  depends_on = [aws_internet_gateway.main]
}

resource "aws_nat_gateway" "nat_1b" {
  allocation_id = aws_eip.nat_1b.id
  subnet_id     = aws_subnet.public_1b.id

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-nat-1b"
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
    Name = "${var.project_name}-${var.environment}-rt-public"
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
    Name = "${var.project_name}-${var.environment}-rt-private-1a"
  })
}

resource "aws_route_table" "private_1b" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1b.id
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-rt-private-1b"
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

# NOTE: IAM resources are commented out due to AWS Academy Labs permissions restrictions.
# These resources are not currently used by the EC2 instances anyway.
# Uncomment and configure these if you have IAM permissions in your AWS environment.

# # IAM Role for Web Servers
# resource "aws_iam_role" "web_server_role" {
#   name = "${var.project_name}-${var.environment}-web-server-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       }
#     ]
#   })

#   tags = merge(var.common_tags, {
#     Name = "${var.project_name}-${var.environment}-web-server-role"
#   })
# }

# # IAM Policy for Web Servers (least privilege)
# resource "aws_iam_policy" "web_server_policy" {
#   name        = "${var.project_name}-${var.environment}-web-server-policy"
#   description = "Policy for web server instances"

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "cloudwatch:PutMetricData",
#           "cloudwatch:GetMetricStatistics",
#           "cloudwatch:ListMetrics",
#           "logs:PutLogEvents",
#           "logs:CreateLogStream",
#           "logs:CreateLogGroup",
#           "logs:DescribeLogStreams",
#           "logs:DescribeLogGroups"
#         ]
#         Resource = "*"
#       }
#     ]
#   })

#   tags = merge(var.common_tags, {
#     Name = "${var.project_name}-${var.environment}-web-server-policy"
#   })
# }

# # Attach policy to web server role
# resource "aws_iam_role_policy_attachment" "web_server_policy_attachment" {
#   role       = aws_iam_role.web_server_role.name
#   policy_arn = aws_iam_policy.web_server_policy.arn
# }

# # Instance profile for web servers
# resource "aws_iam_instance_profile" "web_server_profile" {
#   name = "${var.project_name}-${var.environment}-web-server-profile"
#   role = aws_iam_role.web_server_role.name

#   tags = merge(var.common_tags, {
#     Name = "${var.project_name}-${var.environment}-web-server-profile"
#   })
# }

# # IAM Role for App Servers
# resource "aws_iam_role" "app_server_role" {
#   name = "${var.project_name}-${var.environment}-app-server-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       }
#     ]
#   })

#   tags = merge(var.common_tags, {
#     Name = "${var.project_name}-${var.environment}-app-server-role"
#   })
# }

# # IAM Policy for App Servers (least privilege)
# resource "aws_iam_policy" "app_server_policy" {
#   name        = "${var.project_name}-${var.environment}-app-server-policy"
#   description = "Policy for application server instances"

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "cloudwatch:PutMetricData",
#           "cloudwatch:GetMetricStatistics",
#           "cloudwatch:ListMetrics",
#           "logs:PutLogEvents",
#           "logs:CreateLogStream",
#           "logs:CreateLogGroup",
#           "logs:DescribeLogStreams",
#           "logs:DescribeLogGroups",
#           "ecr:GetAuthorizationToken",
#           "ecr:BatchCheckLayerAvailability",
#           "ecr:GetDownloadUrlForLayer",
#           "ecr:BatchGetImage"
#         ]
#         Resource = "*"
#       }
#     ]
#   })

#   tags = merge(var.common_tags, {
#     Name = "${var.project_name}-${var.environment}-app-server-policy"
#   })
# }

# # Attach policy to app server role
# resource "aws_iam_role_policy_attachment" "app_server_policy_attachment" {
#   role       = aws_iam_role.app_server_role.name
#   policy_arn = aws_iam_policy.app_server_policy.arn
# }

# # Instance profile for app servers
# resource "aws_iam_instance_profile" "app_server_profile" {
#   name = "${var.project_name}-${var.environment}-app-server-profile"
#   role = aws_iam_role.app_server_role.name

#   tags = merge(var.common_tags, {
#     Name = "${var.project_name}-${var.environment}-app-server-profile"
#   })
# }

# ==============================================================================
# SECURITY GROUPS
# ==============================================================================

# Web Security Group
resource "aws_security_group" "web" {
  name_prefix = "${var.project_name}-${var.environment}-web-"
  vpc_id      = aws_vpc.main.id
  description = "Security group for web servers"

  # HTTP access
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_http_cidrs
  }

  # HTTPS access
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_https_cidrs
  }

  # SSH access
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidrs
  }

  # ICMP access
  ingress {
    description = "ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = var.allowed_icmp_cidrs
  }

  # All outbound traffic
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

  lifecycle {
    create_before_destroy = true
  }
}

# Application Security Group
resource "aws_security_group" "app" {
  name_prefix = "${var.project_name}-${var.environment}-app-"
  vpc_id      = aws_vpc.main.id
  description = "Security group for application servers"

  # Application port access from web servers
  ingress {
    description     = "Application port 8080"
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  # MySQL access from web servers (if needed)
  ingress {
    description     = "MySQL from Web SG"
    from_port       = var.mysql_port
    to_port         = var.mysql_port
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  # All outbound traffic
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

  lifecycle {
    create_before_destroy = true
  }
}

# Database Security Group
resource "aws_security_group" "db" {
  name_prefix = "${var.project_name}-${var.environment}-db-"
  vpc_id      = aws_vpc.main.id
  description = "Security group for database servers"

  # MySQL access from application servers
  ingress {
    description     = "MySQL from Application SG"
    from_port       = var.mysql_port
    to_port         = var.mysql_port
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  # All outbound traffic
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

  lifecycle {
    create_before_destroy = true
  }
}

# ==============================================================================
# EC2 INSTANCES (Simplified - No IAM)
# ==============================================================================

# Web Server 1 (in public subnet 1a)
resource "aws_instance" "web_server_1a" {
  ami                    = var.web_server_os == "ubuntu" ? data.aws_ami.ubuntu.id : data.aws_ami.amazon_linux.id
  instance_type          = var.web_instance_type
  subnet_id              = aws_subnet.public_1a.id
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name               = var.key_pair_name

  user_data = base64encode(templatefile("${path.module}/user_data/web_server_${var.web_server_os}.sh", {
    app_port = var.app_port
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
    BackupEnabled = "true"
  })
}

# Web Server 2 (in public subnet 1b)
resource "aws_instance" "web_server_1b" {
  ami                    = var.web_server_os == "ubuntu" ? data.aws_ami.ubuntu.id : data.aws_ami.amazon_linux.id
  instance_type          = var.web_instance_type
  subnet_id              = aws_subnet.public_1b.id
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name               = var.key_pair_name

  user_data = base64encode(templatefile("${path.module}/user_data/web_server_${var.web_server_os}.sh", {
    app_port = var.app_port
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
    BackupEnabled = "true"
  })
}

# Application Server 1 (in private subnet 1a)
resource "aws_instance" "app_server_1a" {
  ami                    = var.app_server_os == "ubuntu" ? data.aws_ami.ubuntu.id : data.aws_ami.amazon_linux.id
  instance_type          = var.app_instance_type
  subnet_id              = aws_subnet.private_1a.id
  vpc_security_group_ids = [aws_security_group.app.id]
  key_name               = var.key_pair_name

  user_data = base64encode(templatefile("${path.module}/user_data/app_server_${var.app_server_os}.sh", {
    port = var.app_port
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
  key_name               = var.key_pair_name

  user_data = base64encode(templatefile("${path.module}/user_data/app_server_${var.app_server_os}.sh", {
    port = var.app_port
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
  storage_encrypted = false  # Simplified for Academy

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

  # Monitoring (simplified)
  monitoring_interval = 0  # Disabled for Academy
  enabled_cloudwatch_logs_exports = ["error", "general", "slowquery"]

  # Performance Insights (disabled for Academy)
  performance_insights_enabled = false

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
    aws_security_group.db
  ]
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
# S3 BACKUP BUCKET (Simplified)
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
    
    filter {
      prefix = ""
    }

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
    
    filter {
      prefix = ""
    }

    expiration {
      expired_object_delete_marker = true
    }

    noncurrent_version_expiration {
      noncurrent_days = 1
    }
  }

  depends_on = [aws_s3_bucket_versioning.backup]
}

# Configure public access blocking
resource "aws_s3_bucket_public_access_block" "backup" {
  bucket = aws_s3_bucket.backup.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ==============================================================================
# APPLICATION LOAD BALANCER (Simplified)
# ==============================================================================

resource "aws_security_group" "alb" {
  name_prefix = "${var.project_name}-${var.environment}-alb-"
  vpc_id      = aws_vpc.main.id
  description = "Security group for Application Load Balancer"

  # HTTP access
  ingress {
    description = "HTTP access from allowed CIDRs"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_http_cidrs
  }

  # HTTPS access
  ingress {
    description = "HTTPS access from allowed CIDRs"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_https_cidrs
  }

  # All outbound traffic
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-alb-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Additional security group rules for web servers to allow ALB access
resource "aws_security_group_rule" "web_alb_http" {
  description              = "HTTP from ALB"
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
  security_group_id        = aws_security_group.web.id
}

resource "aws_security_group_rule" "web_alb_https" {
  description              = "HTTPS from ALB"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
  security_group_id        = aws_security_group.web.id
}

# Application Load Balancer
resource "aws_lb" "main" {
  name               = "${var.project_name}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets           = [aws_subnet.public_1a.id, aws_subnet.public_1b.id]

  enable_deletion_protection = var.alb_deletion_protection

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-alb"
    Type = "LoadBalancer"
  })
}

# ALB Target Group
resource "aws_lb_target_group" "web" {
  name     = "${var.project_name}-${var.environment}-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

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

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-web-tg"
  })
}

# ALB Target Group Attachments
resource "aws_lb_target_group_attachment" "web_1a" {
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = aws_instance.web_server_1a.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "web_1b" {
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = aws_instance.web_server_1b.id
  port             = 80
}

# HTTP Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-alb-listener-http"
  })
}

# ==============================================================================
# BASIC MONITORING (Simplified)
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

# CloudWatch Alarm for EC2 CPU High
resource "aws_cloudwatch_metric_alarm" "ec2_cpu_high" {
  alarm_name          = "${var.project_name}-${var.environment}-ec2-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.ec2_cpu_alarm_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.ec2_cpu_alarm_period
  statistic           = "Average"
  threshold           = var.ec2_cpu_alarm_threshold
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-ec2-cpu-high"
  })
}

# CloudWatch Alarm for RDS CPU High
resource "aws_cloudwatch_metric_alarm" "rds_cpu_high" {
  alarm_name          = "${var.project_name}-${var.environment}-rds-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.rds_cpu_alarm_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = var.rds_cpu_alarm_period
  statistic           = "Average"
  threshold           = var.rds_cpu_alarm_threshold
  alarm_description   = "This metric monitors RDS cpu utilization"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.main.id
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-rds-cpu-high"
  })
}

# Current AWS Account ID
data "aws_caller_identity" "current" {}