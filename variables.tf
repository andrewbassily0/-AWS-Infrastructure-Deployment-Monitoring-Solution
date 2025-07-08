# Variables for VPC Configuration

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b"]
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "rooman"
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "map_public_ip_on_launch" {
  description = "Map public IP on launch for public subnets"
  type        = bool
  default     = true
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "prod"
    Project     = "rooman"
    ManagedBy   = "terraform"
  }
}

# Security Group Variables
variable "allowed_ssh_cidrs" {
  description = "List of CIDR blocks allowed for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_http_cidrs" {
  description = "List of CIDR blocks allowed for HTTP access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_https_cidrs" {
  description = "List of CIDR blocks allowed for HTTPS access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_icmp_cidrs" {
  description = "List of CIDR blocks allowed for ICMP access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "app_port" {
  description = "Application port"
  type        = number
  default     = 8080
}

variable "mysql_port" {
  description = "MySQL port"
  type        = number
  default     = 3306
}

# EC2 Instance Variables
variable "key_pair_name" {
  description = "Name of the EC2 Key Pair for SSH access"
  type        = string
  default     = null
}

variable "web_instance_type" {
  description = "Instance type for web servers"
  type        = string
  default     = "t3.micro"
}

variable "app_instance_type" {
  description = "Instance type for application servers"
  type        = string
  default     = "t3.small"
}

variable "web_server_os" {
  description = "Operating system for web servers (ubuntu or amazon_linux)"
  type        = string
  default     = "ubuntu"
  validation {
    condition     = contains(["ubuntu", "amazon_linux"], var.web_server_os)
    error_message = "Web server OS must be either 'ubuntu' or 'amazon_linux'."
  }
}

variable "app_server_os" {
  description = "Operating system for application servers (ubuntu or amazon_linux)"
  type        = string
  default     = "ubuntu"
  validation {
    condition     = contains(["ubuntu", "amazon_linux"], var.app_server_os)
    error_message = "App server OS must be either 'ubuntu' or 'amazon_linux'."
  }
}

variable "web_server_type" {
  description = "Type of web server to install (nginx or apache)"
  type        = string
  default     = "nginx"
  validation {
    condition     = contains(["nginx", "apache"], var.web_server_type)
    error_message = "Web server type must be either 'nginx' or 'apache'."
  }
}

variable "web_root_volume_size" {
  description = "Size of the root volume for web servers (GB)"
  type        = number
  default     = 20
}

variable "app_root_volume_size" {
  description = "Size of the root volume for application servers (GB)"
  type        = number
  default     = 30
}

variable "enable_detailed_monitoring" {
  description = "Enable detailed monitoring for EC2 instances"
  type        = bool
  default     = false
}

# RDS Database Variables
variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Username for the database"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "db_password" {
  description = "Password for the database (leave empty to auto-generate)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "db_engine_version" {
  description = "MySQL engine version"
  type        = string
  default     = "8.0.35"
}

variable "db_instance_class" {
  description = "Instance class for the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Allocated storage size in GB"
  type        = number
  default     = 20
}

variable "db_storage_type" {
  description = "Storage type for the RDS instance"
  type        = string
  default     = "gp3"
}

variable "db_multi_az" {
  description = "Enable Multi-AZ deployment for high availability"
  type        = bool
  default     = true
}

variable "db_backup_retention_period" {
  description = "Number of days to retain backups"
  type        = number
  default     = 7
}

variable "db_backup_window" {
  description = "Backup window in UTC"
  type        = string
  default     = "03:00-04:00"
}

variable "db_maintenance_window" {
  description = "Maintenance window in UTC"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

variable "db_auto_minor_version_upgrade" {
  description = "Enable automatic minor version upgrades"
  type        = bool
  default     = true
}

variable "db_monitoring_interval" {
  description = "Enhanced monitoring interval in seconds (0 to disable)"
  type        = number
  default     = 60
  validation {
    condition     = contains([0, 1, 5, 10, 15, 30, 60], var.db_monitoring_interval)
    error_message = "Monitoring interval must be one of: 0, 1, 5, 10, 15, 30, 60."
  }
}

variable "db_performance_insights_enabled" {
  description = "Enable Performance Insights"
  type        = bool
  default     = true
}

variable "db_performance_insights_retention_period" {
  description = "Performance Insights retention period in days"
  type        = number
  default     = 7
  validation {
    condition     = contains([7, 731], var.db_performance_insights_retention_period)
    error_message = "Performance Insights retention period must be 7 or 731 days."
  }
}

variable "db_parameter_group_family" {
  description = "Database parameter group family"
  type        = string
  default     = "mysql8.0"
}

variable "db_max_connections" {
  description = "Maximum number of database connections"
  type        = string
  default     = "100"
}

variable "db_skip_final_snapshot" {
  description = "Skip final snapshot when deleting the database"
  type        = bool
  default     = false
}

variable "db_deletion_protection" {
  description = "Enable deletion protection for the database"
  type        = bool
  default     = true
}

# S3 Backup Bucket Variables
variable "s3_versioning_enabled" {
  description = "Enable versioning for the S3 backup bucket"
  type        = bool
  default     = true
}

variable "s3_encryption_algorithm" {
  description = "Server-side encryption algorithm for S3 bucket"
  type        = string
  default     = "AES256"
  validation {
    condition     = contains(["AES256", "aws:kms"], var.s3_encryption_algorithm)
    error_message = "S3 encryption algorithm must be either 'AES256' or 'aws:kms'."
  }
}

variable "s3_bucket_key_enabled" {
  description = "Enable S3 bucket key for KMS encryption"
  type        = bool
  default     = true
}

variable "s3_glacier_transition_days" {
  description = "Number of days after which objects transition to Glacier"
  type        = number
  default     = 7
  validation {
    condition     = var.s3_glacier_transition_days >= 1
    error_message = "Glacier transition days must be at least 1."
  }
}

variable "s3_deep_archive_transition_days" {
  description = "Number of days after which objects transition to Deep Archive (0 to disable)"
  type        = number
  default     = 0
  validation {
    condition     = var.s3_deep_archive_transition_days >= 0
    error_message = "Deep Archive transition days must be 0 or greater."
  }
}

variable "s3_expiration_days" {
  description = "Number of days after which objects are permanently deleted"
  type        = number
  default     = 30
  validation {
    condition     = var.s3_expiration_days >= 1
    error_message = "Expiration days must be at least 1."
  }
}

variable "s3_noncurrent_version_glacier_transition_days" {
  description = "Number of days after which non-current versions transition to Glacier"
  type        = number
  default     = 7
}

variable "s3_noncurrent_version_expiration_days" {
  description = "Number of days after which non-current versions are deleted"
  type        = number
  default     = 30
}

variable "s3_abort_incomplete_multipart_upload_days" {
  description = "Number of days after which incomplete multipart uploads are aborted"
  type        = number
  default     = 7
}

variable "s3_enable_notifications" {
  description = "Enable S3 bucket notifications"
  type        = bool
  default     = false
}

variable "s3_notification_topic_arn" {
  description = "SNS topic ARN for S3 notifications"
  type        = string
  default     = ""
}

variable "s3_enable_access_logging" {
  description = "Enable S3 access logging"
  type        = bool
  default     = false
}

variable "s3_access_log_bucket" {
  description = "S3 bucket for access logs (leave empty to use same bucket)"
  type        = string
  default     = ""
}

variable "s3_access_log_prefix" {
  description = "Prefix for S3 access logs"
  type        = string
  default     = "access-logs/"
}

# Application Load Balancer Variables
variable "alb_allowed_cidrs" {
  description = "List of CIDR blocks allowed to access the ALB"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "alb_deletion_protection" {
  description = "Enable deletion protection for the ALB"
  type        = bool
  default     = false
}

variable "alb_enable_access_logs" {
  description = "Enable access logs for the ALB"
  type        = bool
  default     = false
}

variable "alb_access_logs_bucket" {
  description = "S3 bucket for ALB access logs"
  type        = string
  default     = ""
}

variable "alb_access_logs_prefix" {
  description = "Prefix for ALB access logs"
  type        = string
  default     = "alb-access-logs/"
}

variable "alb_health_check_healthy_threshold" {
  description = "Number of consecutive health check successes before considering target healthy"
  type        = number
  default     = 2
}

variable "alb_health_check_unhealthy_threshold" {
  description = "Number of consecutive health check failures before considering target unhealthy"
  type        = number
  default     = 2
}

variable "alb_health_check_timeout" {
  description = "Health check timeout in seconds"
  type        = number
  default     = 5
}

variable "alb_health_check_interval" {
  description = "Health check interval in seconds"
  type        = number
  default     = 30
}

variable "alb_health_check_path" {
  description = "Health check path"
  type        = string
  default     = "/"
}

variable "alb_health_check_matcher" {
  description = "Health check success codes"
  type        = string
  default     = "200"
}

variable "alb_enable_stickiness" {
  description = "Enable session stickiness"
  type        = bool
  default     = false
}

variable "alb_stickiness_duration" {
  description = "Session stickiness duration in seconds"
  type        = number
  default     = 86400
}

variable "alb_redirect_http_to_https" {
  description = "Redirect HTTP traffic to HTTPS"
  type        = bool
  default     = false
}

variable "alb_enable_https" {
  description = "Enable HTTPS listener"
  type        = bool
  default     = false
}

variable "alb_ssl_policy" {
  description = "SSL policy for HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

variable "alb_certificate_arn" {
  description = "ARN of the SSL certificate for HTTPS listener"
  type        = string
  default     = ""
}

variable "alb_unhealthy_target_evaluation_periods" {
  description = "Number of periods to evaluate for unhealthy target alarm"
  type        = number
  default     = 2
}

variable "alb_unhealthy_target_period" {
  description = "Period in seconds for unhealthy target alarm"
  type        = number
  default     = 300
}

variable "alb_unhealthy_target_threshold" {
  description = "Threshold for unhealthy target alarm"
  type        = number
  default     = 1
}

# Auto Scaling Group Variables
variable "asg_min_size" {
  description = "Minimum number of instances in ASG"
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "Maximum number of instances in ASG"
  type        = number
  default     = 5
}

variable "asg_desired_capacity" {
  description = "Desired number of instances in ASG"
  type        = number
  default     = 2
}

variable "asg_health_check_grace_period" {
  description = "Health check grace period in seconds"
  type        = number
  default     = 300
}

variable "asg_instance_refresh_min_healthy_percentage" {
  description = "Minimum healthy percentage during instance refresh"
  type        = number
  default     = 50
}

variable "asg_instance_warmup" {
  description = "Instance warmup time in seconds"
  type        = number
  default     = 300
}

variable "asg_scale_out_adjustment" {
  description = "Number of instances to add when scaling out"
  type        = number
  default     = 1
}

variable "asg_scale_out_cooldown" {
  description = "Cooldown period in seconds after scaling out"
  type        = number
  default     = 300
}

variable "asg_scale_in_adjustment" {
  description = "Number of instances to remove when scaling in (negative value)"
  type        = number
  default     = -1
}

variable "asg_scale_in_cooldown" {
  description = "Cooldown period in seconds after scaling in"
  type        = number
  default     = 300
}

variable "asg_cpu_high_threshold" {
  description = "CPU threshold for scaling out"
  type        = number
  default     = 60
}

variable "asg_cpu_high_evaluation_periods" {
  description = "Number of periods to evaluate for CPU high alarm"
  type        = number
  default     = 2
}

variable "asg_cpu_high_period" {
  description = "Period in seconds for CPU high alarm"
  type        = number
  default     = 300
}

variable "asg_cpu_low_threshold" {
  description = "CPU threshold for scaling in"
  type        = number
  default     = 30
}

variable "asg_cpu_low_evaluation_periods" {
  description = "Number of periods to evaluate for CPU low alarm"
  type        = number
  default     = 2
}

variable "asg_cpu_low_period" {
  description = "Period in seconds for CPU low alarm"
  type        = number
  default     = 300
}

variable "web_root_volume_type" {
  description = "Root volume type for web servers"
  type        = string
  default     = "gp3"
  validation {
    condition     = contains(["gp2", "gp3", "io1", "io2"], var.web_root_volume_type)
    error_message = "Web root volume type must be one of: gp2, gp3, io1, io2."
  }
}

# CloudWatch Monitoring & Alerts Variables
variable "alert_email" {
  description = "Email address for SNS alerts"
  type        = string
  default     = ""
}

variable "flow_logs_retention_days" {
  description = "CloudWatch log retention period for VPC Flow Logs (days)"
  type        = number
  default     = 14
}

variable "cloudtrail_retention_days" {
  description = "CloudWatch log retention period for CloudTrail (days)"
  type        = number
  default     = 30
}

variable "cloudtrail_multi_region" {
  description = "Enable multi-region CloudTrail"
  type        = bool
  default     = true
}

variable "flow_logs_traffic_type" {
  description = "Type of traffic to capture in VPC Flow Logs"
  type        = string
  default     = "ALL"
  validation {
    condition     = contains(["ALL", "ACCEPT", "REJECT"], var.flow_logs_traffic_type)
    error_message = "VPC Flow Logs traffic type must be ALL, ACCEPT, or REJECT."
  }
}

# EC2 CPU Alarm Variables
variable "ec2_cpu_alarm_threshold" {
  description = "CPU threshold for EC2 alarm (%)"
  type        = number
  default     = 70
}

variable "ec2_cpu_alarm_evaluation_periods" {
  description = "Number of evaluation periods for EC2 CPU alarm"
  type        = number
  default     = 2
}

variable "ec2_cpu_alarm_period" {
  description = "Period for EC2 CPU alarm (seconds)"
  type        = number
  default     = 300
}

# RDS CPU Alarm Variables
variable "rds_cpu_alarm_threshold" {
  description = "CPU threshold for RDS alarm (%)"
  type        = number
  default     = 80
}

variable "rds_cpu_alarm_evaluation_periods" {
  description = "Number of evaluation periods for RDS CPU alarm"
  type        = number
  default     = 2
}

variable "rds_cpu_alarm_period" {
  description = "Period for RDS CPU alarm (seconds)"
  type        = number
  default     = 300
}

# RDS Connections Alarm Variables
variable "rds_connections_alarm_threshold" {
  description = "Database connections threshold for RDS alarm"
  type        = number
  default     = 80
}

variable "rds_connections_alarm_evaluation_periods" {
  description = "Number of evaluation periods for RDS connections alarm"
  type        = number
  default     = 2
}

variable "rds_connections_alarm_period" {
  description = "Period for RDS connections alarm (seconds)"
  type        = number
  default     = 300
}

# RDS Storage Alarm Variables
variable "rds_storage_alarm_threshold" {
  description = "Free storage threshold for RDS alarm (bytes)"
  type        = number
  default     = 2000000000  # 2GB in bytes
}

variable "rds_storage_alarm_evaluation_periods" {
  description = "Number of evaluation periods for RDS storage alarm"
  type        = number
  default     = 1
}

variable "rds_storage_alarm_period" {
  description = "Period for RDS storage alarm (seconds)"
  type        = number
  default     = 300
}

# Security Alarm Variables
variable "root_login_alarm_threshold" {
  description = "Threshold for root login attempts alarm"
  type        = number
  default     = 0
}

variable "root_login_alarm_evaluation_periods" {
  description = "Number of evaluation periods for root login alarm"
  type        = number
  default     = 1
}

variable "root_login_alarm_period" {
  description = "Period for root login alarm (seconds)"
  type        = number
  default     = 300
}

variable "security_group_alarm_threshold" {
  description = "Threshold for security group changes alarm"
  type        = number
  default     = 0
}

variable "security_group_alarm_evaluation_periods" {
  description = "Number of evaluation periods for security group alarm"
  type        = number
  default     = 1
}

variable "security_group_alarm_period" {
  description = "Period for security group alarm (seconds)"
  type        = number
  default     = 300
}

variable "console_login_alarm_threshold" {
  description = "Threshold for console login failures alarm"
  type        = number
  default     = 3
}

variable "console_login_alarm_evaluation_periods" {
  description = "Number of evaluation periods for console login alarm"
  type        = number
  default     = 1
}

variable "console_login_alarm_period" {
  description = "Period for console login alarm (seconds)"
  type        = number
  default     = 300
}

variable "unauthorized_api_alarm_threshold" {
  description = "Threshold for unauthorized API calls alarm"
  type        = number
  default     = 5
}

variable "unauthorized_api_alarm_evaluation_periods" {
  description = "Number of evaluation periods for unauthorized API alarm"
  type        = number
  default     = 1
}

variable "unauthorized_api_alarm_period" {
  description = "Period for unauthorized API alarm (seconds)"
  type        = number
  default     = 300
}

# AWS Backup Variables
variable "backup_kms_deletion_window" {
  description = "KMS key deletion window for backup vault (days)"
  type        = number
  default     = 7
  validation {
    condition     = var.backup_kms_deletion_window >= 7 && var.backup_kms_deletion_window <= 30
    error_message = "KMS key deletion window must be between 7 and 30 days."
  }
}

variable "backup_schedule_expression" {
  description = "Cron expression for backup schedule (2:00 AM Bahrain time = 23:00 UTC)"
  type        = string
  default     = "cron(0 23 * * ? *)"
}

variable "backup_start_window" {
  description = "Backup start window in minutes"
  type        = number
  default     = 480
}

variable "backup_completion_window" {
  description = "Backup completion window in minutes"
  type        = number
  default     = 10080
}

variable "backup_cold_storage_after" {
  description = "Move backups to cold storage after (days)"
  type        = number
  default     = 30
}

variable "backup_delete_after" {
  description = "Delete backups after (days)"
  type        = number
  default     = 120
}

variable "backup_copy_cold_storage_after" {
  description = "Move copied backups to cold storage after (days)"
  type        = number
  default     = 30
}

variable "backup_copy_delete_after" {
  description = "Delete copied backups after (days)"
  type        = number
  default     = 120
}

variable "backup_weekly_schedule_expression" {
  description = "Weekly backup schedule (Sunday at 2:00 AM Bahrain time)"
  type        = string
  default     = "cron(0 23 ? * SUN *)"
}

variable "backup_weekly_cold_storage_after" {
  description = "Move weekly backups to cold storage after (days)"
  type        = number
  default     = 90
}

variable "backup_weekly_delete_after" {
  description = "Delete weekly backups after (days)"
  type        = number
  default     = 365
}

variable "backup_monthly_schedule_expression" {
  description = "Monthly backup schedule (1st day of month at 2:00 AM Bahrain time)"
  type        = string
  default     = "cron(0 23 1 * ? *)"
}

variable "backup_monthly_cold_storage_after" {
  description = "Move monthly backups to cold storage after (days)"
  type        = number
  default     = 90
}

variable "backup_monthly_delete_after" {
  description = "Delete monthly backups after (days)"
  type        = number
  default     = 2555
}

variable "backup_recovery_point_tags" {
  description = "Tags to apply to backup recovery points"
  type        = map(string)
  default = {
    Environment = "Production"
    BackupType  = "Automated"
  }
}

variable "backup_s3_enabled" {
  description = "Enable S3 bucket backups"
  type        = bool
  default     = true
}

variable "backup_notification_email" {
  description = "Email address for backup notifications"
  type        = string
  default     = ""
}

variable "backup_vault_events" {
  description = "List of backup vault events to monitor"
  type        = list(string)
  default = [
    "BACKUP_JOB_STARTED",
    "BACKUP_JOB_COMPLETED",
    "BACKUP_JOB_SUCCESSFUL",
    "BACKUP_JOB_FAILED",
    "BACKUP_JOB_EXPIRED",
    "RESTORE_JOB_STARTED",
    "RESTORE_JOB_COMPLETED",
    "RESTORE_JOB_SUCCESSFUL",
    "RESTORE_JOB_FAILED",
    "COPY_JOB_STARTED",
    "COPY_JOB_SUCCESSFUL",
    "COPY_JOB_FAILED",
    "RECOVERY_POINT_MODIFIED",
    "BACKUP_PLAN_CREATED",
    "BACKUP_PLAN_MODIFIED"
  ]
}

variable "backup_log_retention_days" {
  description = "Backup events log retention period (days)"
  type        = number
  default     = 30
}

variable "backup_event_states" {
  description = "List of backup event states to monitor"
  type        = list(string)
  default = [
    "CREATED",
    "PENDING",
    "RUNNING",
    "ABORTING",
    "ABORTED",
    "COMPLETED",
    "FAILED",
    "EXPIRED"
  ]
}

variable "backup_alarm_evaluation_periods" {
  description = "Number of evaluation periods for backup alarms"
  type        = number
  default     = 1
}

variable "backup_alarm_period" {
  description = "Period for backup alarms (seconds)"
  type        = number
  default     = 300
}

variable "backup_alarm_threshold" {
  description = "Threshold for backup job failure alarm"
  type        = number
  default     = 0
}

variable "backup_reporting_enabled" {
  description = "Enable daily backup reporting"
  type        = bool
  default     = false
}

variable "backup_report_schedule" {
  description = "Schedule for daily backup reports"
  type        = string
  default     = "cron(0 8 * * ? *)"
}

variable "backup_cross_region_enabled" {
  description = "Enable cross-region backup replication"
  type        = bool
  default     = false
}

variable "backup_cross_region_destination" {
  description = "Destination region for cross-region backup replication"
  type        = string
  default     = "us-east-1"
}

variable "backup_point_in_time_recovery_enabled" {
  description = "Enable point-in-time recovery for supported services"
  type        = bool
  default     = true
}

variable "backup_lifecycle_enabled" {
  description = "Enable backup lifecycle management"
  type        = bool
  default     = true
}

variable "backup_encryption_enabled" {
  description = "Enable backup encryption"
  type        = bool
  default     = true
}

variable "backup_resource_assignment_enabled" {
  description = "Enable automatic resource assignment to backup plans"
  type        = bool
  default     = true
}

variable "backup_compliance_enabled" {
  description = "Enable backup compliance features"
  type        = bool
  default     = true
}

variable "backup_continuous_enabled" {
  description = "Enable continuous backup for supported services"
  type        = bool
  default     = false
} 