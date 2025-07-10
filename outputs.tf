# ==============================================================================
# NETWORK OUTPUTS
# ==============================================================================

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = [aws_subnet.public_1a.id, aws_subnet.public_1b.id]
}

output "public_subnet_1a_id" {
  description = "ID of public subnet 1a"
  value       = aws_subnet.public_1a.id
}

output "public_subnet_1b_id" {
  description = "ID of public subnet 1b"
  value       = aws_subnet.public_1b.id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = [aws_subnet.private_1a.id, aws_subnet.private_1b.id]
}

output "private_subnet_1a_id" {
  description = "ID of private subnet 1a"
  value       = aws_subnet.private_1a.id
}

output "private_subnet_1b_id" {
  description = "ID of private subnet 1b"
  value       = aws_subnet.private_1b.id
}

output "nat_gateway_ids" {
  description = "IDs of the NAT Gateways"
  value       = [aws_nat_gateway.nat_1a.id, aws_nat_gateway.nat_1b.id]
}

output "nat_gateway_1a_id" {
  description = "ID of NAT Gateway 1a"
  value       = aws_nat_gateway.nat_1a.id
}

output "nat_gateway_1b_id" {
  description = "ID of NAT Gateway 1b"
  value       = aws_nat_gateway.nat_1b.id
}

output "eip_nat_1a" {
  description = "Elastic IP address of NAT Gateway 1a"
  value       = aws_eip.nat_1a.public_ip
}

output "eip_nat_1b" {
  description = "Elastic IP address of NAT Gateway 1b"
  value       = aws_eip.nat_1b.public_ip
}

output "availability_zones" {
  description = "Availability zones used"
  value       = var.availability_zones
}

# ==============================================================================
# SECURITY GROUP OUTPUTS
# ==============================================================================

output "web_security_group_id" {
  description = "ID of the web security group"
  value       = aws_security_group.web.id
}

output "app_security_group_id" {
  description = "ID of the app security group"
  value       = aws_security_group.app.id
}

output "db_security_group_id" {
  description = "ID of the database security group"
  value       = aws_security_group.db.id
}

output "alb_security_group_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb.id
}

output "security_group_ids" {
  description = "Map of all security group IDs"
  value = {
    web = aws_security_group.web.id
    app = aws_security_group.app.id
    db  = aws_security_group.db.id
    alb = aws_security_group.alb.id
  }
}

# ==============================================================================
# EC2 INSTANCE OUTPUTS
# ==============================================================================

output "web_server_ids" {
  description = "IDs of the web servers"
  value       = [aws_instance.web_server_1a.id, aws_instance.web_server_1b.id]
}

output "web_server_1a_id" {
  description = "ID of web server 1a"
  value       = aws_instance.web_server_1a.id
}

output "web_server_1b_id" {
  description = "ID of web server 1b"
  value       = aws_instance.web_server_1b.id
}

output "web_server_public_ips" {
  description = "Public IP addresses of web servers"
  value       = [aws_instance.web_server_1a.public_ip, aws_instance.web_server_1b.public_ip]
}

output "web_server_1a_public_ip" {
  description = "Public IP address of web server 1a"
  value       = aws_instance.web_server_1a.public_ip
}

output "web_server_1b_public_ip" {
  description = "Public IP address of web server 1b"
  value       = aws_instance.web_server_1b.public_ip
}

output "web_server_private_ips" {
  description = "Private IP addresses of web servers"
  value       = [aws_instance.web_server_1a.private_ip, aws_instance.web_server_1b.private_ip]
}

output "app_server_ids" {
  description = "IDs of the application servers"
  value       = [aws_instance.app_server_1a.id, aws_instance.app_server_1b.id]
}

output "app_server_1a_id" {
  description = "ID of application server 1a"
  value       = aws_instance.app_server_1a.id
}

output "app_server_1b_id" {
  description = "ID of application server 1b"
  value       = aws_instance.app_server_1b.id
}

output "app_server_private_ips" {
  description = "Private IP addresses of application servers"
  value       = [aws_instance.app_server_1a.private_ip, aws_instance.app_server_1b.private_ip]
}

output "app_server_1a_private_ip" {
  description = "Private IP address of application server 1a"
  value       = aws_instance.app_server_1a.private_ip
}

output "app_server_1b_private_ip" {
  description = "Private IP address of application server 1b"
  value       = aws_instance.app_server_1b.private_ip
}

# ==============================================================================
# AMI OUTPUTS
# ==============================================================================

output "ubuntu_ami_id" {
  description = "AMI ID of the Ubuntu image used"
  value       = data.aws_ami.ubuntu.id
}

output "amazon_linux_ami_id" {
  description = "AMI ID of the Amazon Linux image used"
  value       = data.aws_ami.amazon_linux.id
}

# ==============================================================================
# DATABASE OUTPUTS
# ==============================================================================

output "db_instance_id" {
  description = "RDS instance ID"
  value       = aws_db_instance.main.id
}

output "db_instance_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.main.endpoint
}

output "db_instance_hosted_zone_id" {
  description = "RDS instance hosted zone ID"
  value       = aws_db_instance.main.hosted_zone_id
}

output "db_instance_port" {
  description = "RDS instance port"
  value       = aws_db_instance.main.port
}

output "db_subnet_group_id" {
  description = "DB subnet group ID"
  value       = aws_db_subnet_group.main.id
}

output "db_parameter_group_id" {
  description = "DB parameter group ID"
  value       = aws_db_parameter_group.main.id
}

output "db_instance_arn" {
  description = "RDS instance ARN"
  value       = aws_db_instance.main.arn
}

output "db_instance_availability_zone" {
  description = "RDS instance availability zone"
  value       = aws_db_instance.main.availability_zone
}

output "db_instance_backup_retention_period" {
  description = "RDS instance backup retention period"
  value       = aws_db_instance.main.backup_retention_period
}

output "db_instance_status" {
  description = "RDS instance status"
  value       = aws_db_instance.main.status
}

output "db_instance_multi_az" {
  description = "RDS instance multi-AZ status"
  value       = aws_db_instance.main.multi_az
}

output "db_instance_engine_version" {
  description = "RDS instance engine version"
  value       = aws_db_instance.main.engine_version
}

output "db_secrets_manager_secret_arn" {
  description = "Secrets Manager secret ARN for database credentials"
  value       = aws_secretsmanager_secret.db_password.arn
}

# Database connection information (for application configuration)
output "db_connection_info" {
  description = "Database connection information"
  sensitive   = true
  value = {
    endpoint = aws_db_instance.main.endpoint
    port     = aws_db_instance.main.port
    database = aws_db_instance.main.db_name
    username = aws_db_instance.main.username
  }
}

# ==============================================================================
# S3 BACKUP BUCKET OUTPUTS
# ==============================================================================

output "s3_backup_bucket_id" {
  description = "ID of the S3 backup bucket"
  value       = aws_s3_bucket.backup.id
}

output "s3_backup_bucket_arn" {
  description = "ARN of the S3 backup bucket"
  value       = aws_s3_bucket.backup.arn
}

output "s3_backup_bucket_domain_name" {
  description = "Domain name of the S3 backup bucket"
  value       = aws_s3_bucket.backup.bucket_domain_name
}

output "s3_backup_bucket_regional_domain_name" {
  description = "Regional domain name of the S3 backup bucket"
  value       = aws_s3_bucket.backup.bucket_regional_domain_name
}

output "s3_backup_bucket_hosted_zone_id" {
  description = "Hosted zone ID of the S3 backup bucket"
  value       = aws_s3_bucket.backup.hosted_zone_id
}

output "s3_backup_bucket_region" {
  description = "Region of the S3 backup bucket"
  value       = aws_s3_bucket.backup.region
}

output "s3_backup_bucket_versioning_status" {
  description = "Versioning status of the S3 backup bucket"
  value       = aws_s3_bucket_versioning.backup.versioning_configuration[0].status
}

output "s3_backup_bucket_encryption_algorithm" {
  description = "Encryption algorithm used for the S3 backup bucket"
  value       = var.s3_encryption_algorithm
}

output "s3_backup_lifecycle_rules" {
  description = "Lifecycle rules configuration for the S3 backup bucket"
  value = {
    glacier_transition_days       = var.s3_glacier_transition_days
    deep_archive_transition_days  = var.s3_deep_archive_transition_days
    expiration_days              = var.s3_expiration_days
    noncurrent_version_expiration = var.s3_noncurrent_version_expiration_days
  }
}

# ==============================================================================
# APPLICATION LOAD BALANCER OUTPUTS
# ==============================================================================

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.main.arn
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the Application Load Balancer"
  value       = aws_lb.main.zone_id
}

output "alb_target_group_arn" {
  description = "ARN of the ALB target group"
  value       = aws_lb_target_group.web.arn
}

output "alb_target_group_name" {
  description = "Name of the ALB target group"
  value       = aws_lb_target_group.web.name
}

output "alb_http_listener_arn" {
  description = "ARN of the HTTP listener"
  value       = aws_lb_listener.http.arn
}

output "alb_url" {
  description = "URL of the Application Load Balancer"
  value       = "http://${aws_lb.main.dns_name}"
}

# ALB Health Check Configuration
output "alb_health_check_configuration" {
  description = "ALB target group health check configuration"
  value = {
    healthy_threshold   = var.alb_health_check_healthy_threshold
    unhealthy_threshold = var.alb_health_check_unhealthy_threshold
    timeout             = var.alb_health_check_timeout
    interval            = var.alb_health_check_interval
    path                = var.alb_health_check_path
    matcher             = var.alb_health_check_matcher
  }
}

# ==============================================================================
# MONITORING OUTPUTS
# ==============================================================================

output "sns_topic_alerts_arn" {
  description = "ARN of the SNS topic for alerts"
  value       = aws_sns_topic.alerts.arn
}

output "sns_topic_alerts_name" {
  description = "Name of the SNS topic for alerts"
  value       = aws_sns_topic.alerts.name
}

output "ec2_cpu_high_alarm_arn" {
  description = "ARN of the EC2 CPU high alarm"
  value       = aws_cloudwatch_metric_alarm.ec2_cpu_high.arn
}

output "rds_cpu_high_alarm_arn" {
  description = "ARN of the RDS CPU high alarm"
  value       = aws_cloudwatch_metric_alarm.rds_cpu_high.arn
}

# ==============================================================================
# SUMMARY OUTPUTS
# ==============================================================================

output "monitoring_configuration" {
  description = "Monitoring configuration summary"
  value = {
    alert_email_configured = var.alert_email != "" ? true : false
    sns_topic             = aws_sns_topic.alerts.name
    ec2_cpu_threshold     = var.ec2_cpu_alarm_threshold
    rds_cpu_threshold     = var.rds_cpu_alarm_threshold
  }
}

output "infrastructure_summary" {
  description = "Summary of deployed infrastructure"
  value = {
    project_name    = var.project_name
    environment     = var.environment
    aws_region      = var.aws_region
    vpc_cidr        = aws_vpc.main.cidr_block
    web_servers     = length([aws_instance.web_server_1a.id, aws_instance.web_server_1b.id])
    app_servers     = length([aws_instance.app_server_1a.id, aws_instance.app_server_1b.id])
    database_engine = aws_db_instance.main.engine
    load_balancer   = aws_lb.main.dns_name
    backup_bucket   = aws_s3_bucket.backup.id
  }
}

output "access_information" {
  description = "How to access your infrastructure"
  value = {
    web_application_url = "http://${aws_lb.main.dns_name}"
    web_server_1a_ssh   = "ssh -i ${var.key_pair_name}.pem ubuntu@${aws_instance.web_server_1a.public_ip}"
    web_server_1b_ssh   = "ssh -i ${var.key_pair_name}.pem ubuntu@${aws_instance.web_server_1b.public_ip}"
    database_endpoint   = aws_db_instance.main.endpoint
  }
} 