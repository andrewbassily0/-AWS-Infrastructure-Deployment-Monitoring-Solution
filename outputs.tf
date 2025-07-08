# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

# Internet Gateway Outputs
output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

# Public Subnet Outputs
output "public_subnet_ids" {
  description = "List of IDs of the public subnets"
  value       = [aws_subnet.public_1a.id, aws_subnet.public_1b.id]
}

output "public_subnet_1a_id" {
  description = "ID of the public subnet in AZ 1a"
  value       = aws_subnet.public_1a.id
}

output "public_subnet_1b_id" {
  description = "ID of the public subnet in AZ 1b"
  value       = aws_subnet.public_1b.id
}

# Private Subnet Outputs
output "private_subnet_ids" {
  description = "List of IDs of the private subnets"
  value       = [aws_subnet.private_1a.id, aws_subnet.private_1b.id]
}

output "private_subnet_1a_id" {
  description = "ID of the private subnet in AZ 1a"
  value       = aws_subnet.private_1a.id
}

output "private_subnet_1b_id" {
  description = "ID of the private subnet in AZ 1b"
  value       = aws_subnet.private_1b.id
}

# NAT Gateway Outputs
output "nat_gateway_ids" {
  description = "List of IDs of the NAT Gateways"
  value       = [aws_nat_gateway.nat_1a.id, aws_nat_gateway.nat_1b.id]
}

output "nat_gateway_1a_id" {
  description = "ID of the NAT Gateway in AZ 1a"
  value       = aws_nat_gateway.nat_1a.id
}

output "nat_gateway_1b_id" {
  description = "ID of the NAT Gateway in AZ 1b"
  value       = aws_nat_gateway.nat_1b.id
}

# Elastic IP Outputs
output "eip_nat_1a" {
  description = "Elastic IP associated with NAT Gateway in AZ 1a"
  value       = aws_eip.nat_1a.public_ip
}

output "eip_nat_1b" {
  description = "Elastic IP associated with NAT Gateway in AZ 1b"
  value       = aws_eip.nat_1b.public_ip
}

# Route Table Outputs
output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_1a_id" {
  description = "ID of the private route table in AZ 1a"
  value       = aws_route_table.private_1a.id
}

output "private_route_table_1b_id" {
  description = "ID of the private route table in AZ 1b"
  value       = aws_route_table.private_1b.id
}

# Availability Zones
output "availability_zones" {
  description = "List of availability zones used"
  value       = var.availability_zones
}

# Security Group Outputs
output "web_security_group_id" {
  description = "ID of the Web Security Group"
  value       = aws_security_group.web.id
}

output "app_security_group_id" {
  description = "ID of the Application Security Group"
  value       = aws_security_group.app.id
}

output "db_security_group_id" {
  description = "ID of the Database Security Group"
  value       = aws_security_group.db.id
}

output "security_group_ids" {
  description = "Map of all security group IDs"
  value = {
    web = aws_security_group.web.id
    app = aws_security_group.app.id
    db  = aws_security_group.db.id
  }
}

# EC2 Instance Outputs
output "web_server_ids" {
  description = "List of Web Server instance IDs"
  value       = [aws_instance.web_server_1a.id, aws_instance.web_server_1b.id]
}

output "web_server_1a_id" {
  description = "Web Server 1a instance ID"
  value       = aws_instance.web_server_1a.id
}

output "web_server_1b_id" {
  description = "Web Server 1b instance ID"
  value       = aws_instance.web_server_1b.id
}

output "web_server_public_ips" {
  description = "List of Web Server public IP addresses"
  value       = [aws_instance.web_server_1a.public_ip, aws_instance.web_server_1b.public_ip]
}

output "web_server_1a_public_ip" {
  description = "Web Server 1a public IP address"
  value       = aws_instance.web_server_1a.public_ip
}

output "web_server_1b_public_ip" {
  description = "Web Server 1b public IP address"
  value       = aws_instance.web_server_1b.public_ip
}

output "web_server_private_ips" {
  description = "List of Web Server private IP addresses"
  value       = [aws_instance.web_server_1a.private_ip, aws_instance.web_server_1b.private_ip]
}

output "app_server_ids" {
  description = "List of Application Server instance IDs"
  value       = [aws_instance.app_server_1a.id, aws_instance.app_server_1b.id]
}

output "app_server_1a_id" {
  description = "Application Server 1a instance ID"
  value       = aws_instance.app_server_1a.id
}

output "app_server_1b_id" {
  description = "Application Server 1b instance ID"
  value       = aws_instance.app_server_1b.id
}

output "app_server_private_ips" {
  description = "List of Application Server private IP addresses"
  value       = [aws_instance.app_server_1a.private_ip, aws_instance.app_server_1b.private_ip]
}

output "app_server_1a_private_ip" {
  description = "Application Server 1a private IP address"
  value       = aws_instance.app_server_1a.private_ip
}

output "app_server_1b_private_ip" {
  description = "Application Server 1b private IP address"
  value       = aws_instance.app_server_1b.private_ip
}

# IAM Role Outputs
output "web_server_iam_role_arn" {
  description = "ARN of the Web Server IAM role"
  value       = aws_iam_role.web_server_role.arn
}

output "app_server_iam_role_arn" {
  description = "ARN of the Application Server IAM role"
  value       = aws_iam_role.app_server_role.arn
}

# AMI Information
output "ubuntu_ami_id" {
  description = "AMI ID for Ubuntu 22.04"
  value       = data.aws_ami.ubuntu.id
}

output "amazon_linux_ami_id" {
  description = "AMI ID for Amazon Linux 2"
  value       = data.aws_ami.amazon_linux.id
}

# RDS Database Outputs
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
  description = "RDS instance multi AZ deployment"
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

output "db_kms_key_id" {
  description = "KMS key ID used for RDS encryption"
  value       = aws_kms_key.rds.key_id
}

output "db_kms_key_arn" {
  description = "KMS key ARN used for RDS encryption"
  value       = aws_kms_key.rds.arn
}

# Database connection information (for application configuration)
output "db_connection_info" {
  description = "Database connection information"
  value = {
    endpoint = aws_db_instance.main.endpoint
    port     = aws_db_instance.main.port
    database = aws_db_instance.main.db_name
    username = aws_db_instance.main.username
  }
  sensitive = false
}

# S3 Backup Bucket Outputs
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

output "s3_backup_bucket_website_endpoint" {
  description = "Website endpoint of the S3 backup bucket"
  value       = aws_s3_bucket.backup.website_endpoint
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
  value       = aws_s3_bucket_server_side_encryption_configuration.backup.rule[0].apply_server_side_encryption_by_default[0].sse_algorithm
}

output "s3_backup_iam_role_arn" {
  description = "ARN of the IAM role for backup operations"
  value       = aws_iam_role.backup_role.arn
}

output "s3_backup_iam_role_name" {
  description = "Name of the IAM role for backup operations"
  value       = aws_iam_role.backup_role.name
}

output "s3_backup_iam_policy_arn" {
  description = "ARN of the IAM policy for backup operations"
  value       = aws_iam_policy.backup_policy.arn
}

output "s3_backup_instance_profile_arn" {
  description = "ARN of the instance profile for backup operations"
  value       = aws_iam_instance_profile.backup_profile.arn
}

output "s3_backup_instance_profile_name" {
  description = "Name of the instance profile for backup operations"
  value       = aws_iam_instance_profile.backup_profile.name
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

output "s3_backup_bucket_policy_document" {
  description = "S3 bucket policy document"
  value       = aws_s3_bucket_policy.backup.policy
  sensitive   = true
}

# Application Load Balancer Outputs
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

output "alb_hosted_zone_id" {
  description = "Hosted zone ID of the Application Load Balancer"
  value       = aws_lb.main.zone_id
}

output "alb_security_group_id" {
  description = "Security group ID of the Application Load Balancer"
  value       = aws_security_group.alb.id
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

output "alb_https_listener_arn" {
  description = "ARN of the HTTPS listener"
  value       = var.alb_enable_https ? aws_lb_listener.https[0].arn : null
}

output "alb_url" {
  description = "URL of the Application Load Balancer"
  value       = var.alb_enable_https ? "https://${aws_lb.main.dns_name}" : "http://${aws_lb.main.dns_name}"
}

# Auto Scaling Group Outputs
output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.web.name
}

output "asg_arn" {
  description = "ARN of the Auto Scaling Group"
  value       = aws_autoscaling_group.web.arn
}

output "asg_min_size" {
  description = "Minimum size of the Auto Scaling Group"
  value       = aws_autoscaling_group.web.min_size
}

output "asg_max_size" {
  description = "Maximum size of the Auto Scaling Group"
  value       = aws_autoscaling_group.web.max_size
}

output "asg_desired_capacity" {
  description = "Desired capacity of the Auto Scaling Group"
  value       = aws_autoscaling_group.web.desired_capacity
}

output "asg_launch_template_id" {
  description = "ID of the launch template"
  value       = aws_launch_template.web.id
}

output "asg_launch_template_name" {
  description = "Name of the launch template"
  value       = aws_launch_template.web.name
}

output "asg_launch_template_version" {
  description = "Latest version of the launch template"
  value       = aws_launch_template.web.latest_version
}

output "asg_scale_out_policy_arn" {
  description = "ARN of the scale out policy"
  value       = aws_autoscaling_policy.scale_out.arn
}

output "asg_scale_in_policy_arn" {
  description = "ARN of the scale in policy"
  value       = aws_autoscaling_policy.scale_in.arn
}

output "asg_cpu_high_alarm_arn" {
  description = "ARN of the CPU high alarm"
  value       = aws_cloudwatch_metric_alarm.cpu_high.arn
}

output "asg_cpu_low_alarm_arn" {
  description = "ARN of the CPU low alarm"
  value       = aws_cloudwatch_metric_alarm.cpu_low.arn
}

output "asg_target_health_alarm_arn" {
  description = "ARN of the target health alarm"
  value       = aws_cloudwatch_metric_alarm.alb_target_health.arn
}

# Auto Scaling Configuration Summary
output "asg_scaling_configuration" {
  description = "Auto Scaling Group scaling configuration"
  value = {
    min_size                = var.asg_min_size
    max_size                = var.asg_max_size
    desired_capacity        = var.asg_desired_capacity
    scale_out_threshold     = var.asg_cpu_high_threshold
    scale_in_threshold      = var.asg_cpu_low_threshold
    scale_out_adjustment    = var.asg_scale_out_adjustment
    scale_in_adjustment     = var.asg_scale_in_adjustment
    scale_out_cooldown      = var.asg_scale_out_cooldown
    scale_in_cooldown       = var.asg_scale_in_cooldown
  }
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

# CloudWatch Monitoring & Alerts Outputs
output "sns_topic_alerts_arn" {
  description = "ARN of the SNS topic for alerts"
  value       = aws_sns_topic.alerts.arn
}

output "sns_topic_alerts_name" {
  description = "Name of the SNS topic for alerts"
  value       = aws_sns_topic.alerts.name
}

output "cloudwatch_log_group_vpc_flow_logs_arn" {
  description = "ARN of the CloudWatch log group for VPC Flow Logs"
  value       = aws_cloudwatch_log_group.vpc_flow_logs.arn
}

output "cloudwatch_log_group_cloudtrail_arn" {
  description = "ARN of the CloudWatch log group for CloudTrail"
  value       = aws_cloudwatch_log_group.cloudtrail.arn
}

output "cloudtrail_arn" {
  description = "ARN of the CloudTrail"
  value       = aws_cloudtrail.main.arn
}

output "cloudtrail_s3_bucket_name" {
  description = "Name of the S3 bucket for CloudTrail logs"
  value       = aws_s3_bucket.cloudtrail_logs.id
}

output "vpc_flow_logs_id" {
  description = "ID of the VPC Flow Logs"
  value       = aws_flow_log.vpc_flow_logs.id
}

output "cloudwatch_dashboard_url" {
  description = "URL of the CloudWatch dashboard"
  value       = "https://${var.aws_region}.console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#dashboards:name=${aws_cloudwatch_dashboard.main.dashboard_name}"
}

# CloudWatch Alarm Outputs
output "ec2_cpu_high_alarm_arn" {
  description = "ARN of the EC2 CPU high alarm"
  value       = aws_cloudwatch_metric_alarm.ec2_cpu_high.arn
}

output "rds_cpu_high_alarm_arn" {
  description = "ARN of the RDS CPU high alarm"
  value       = aws_cloudwatch_metric_alarm.rds_cpu_high.arn
}

output "rds_connections_high_alarm_arn" {
  description = "ARN of the RDS connections high alarm"
  value       = aws_cloudwatch_metric_alarm.rds_connections_high.arn
}

output "rds_free_storage_low_alarm_arn" {
  description = "ARN of the RDS free storage low alarm"
  value       = aws_cloudwatch_metric_alarm.rds_free_storage_low.arn
}

output "root_login_attempts_alarm_arn" {
  description = "ARN of the root login attempts alarm"
  value       = aws_cloudwatch_metric_alarm.root_login_attempts.arn
}

output "security_group_changes_alarm_arn" {
  description = "ARN of the security group changes alarm"
  value       = aws_cloudwatch_metric_alarm.security_group_changes.arn
}

output "console_login_failures_alarm_arn" {
  description = "ARN of the console login failures alarm"
  value       = aws_cloudwatch_metric_alarm.console_login_failures.arn
}

output "unauthorized_api_calls_alarm_arn" {
  description = "ARN of the unauthorized API calls alarm"
  value       = aws_cloudwatch_metric_alarm.unauthorized_api_calls.arn
}

# Monitoring Configuration Summary
output "monitoring_configuration" {
  description = "CloudWatch monitoring configuration summary"
  value = {
    sns_topic                = aws_sns_topic.alerts.name
    alert_email_configured   = var.alert_email != ""
    vpc_flow_logs_enabled    = true
    cloudtrail_enabled       = true
    cloudtrail_multi_region  = var.cloudtrail_multi_region
    flow_logs_retention_days = var.flow_logs_retention_days
    cloudtrail_retention_days = var.cloudtrail_retention_days
    ec2_cpu_threshold        = var.ec2_cpu_alarm_threshold
    rds_cpu_threshold        = var.rds_cpu_alarm_threshold
    dashboard_name           = aws_cloudwatch_dashboard.main.dashboard_name
  }
}

# Security Monitoring Summary
output "security_monitoring_summary" {
  description = "Summary of security monitoring configuration"
  value = {
    root_login_monitoring        = true
    security_group_monitoring    = true
    console_login_monitoring     = true
    unauthorized_api_monitoring  = true
    cloudtrail_enabled          = true
    vpc_flow_logs_enabled       = true
    alert_notifications_enabled = var.alert_email != ""
  }
}

# CloudWatch Alarm Thresholds
output "alarm_thresholds" {
  description = "CloudWatch alarm thresholds configuration"
  value = {
    ec2_cpu_threshold               = var.ec2_cpu_alarm_threshold
    rds_cpu_threshold              = var.rds_cpu_alarm_threshold
    rds_connections_threshold      = var.rds_connections_alarm_threshold
    rds_storage_threshold_gb       = var.rds_storage_alarm_threshold / 1000000000
    root_login_threshold           = var.root_login_alarm_threshold
    security_group_changes_threshold = var.security_group_alarm_threshold
    console_login_failures_threshold = var.console_login_alarm_threshold
    unauthorized_api_threshold     = var.unauthorized_api_alarm_threshold
  }
}

# AWS Backup Outputs
output "backup_vault_name" {
  description = "Name of the backup vault"
  value       = aws_backup_vault.main.name
}

output "backup_vault_arn" {
  description = "ARN of the backup vault"
  value       = aws_backup_vault.main.arn
}

output "backup_vault_kms_key_id" {
  description = "KMS key ID for backup vault encryption"
  value       = aws_kms_key.backup_vault.key_id
}

output "backup_vault_kms_key_arn" {
  description = "KMS key ARN for backup vault encryption"
  value       = aws_kms_key.backup_vault.arn
}

output "backup_plan_id" {
  description = "ID of the backup plan"
  value       = aws_backup_plan.main.id
}

output "backup_plan_arn" {
  description = "ARN of the backup plan"
  value       = aws_backup_plan.main.arn
}

output "backup_plan_version" {
  description = "Version of the backup plan"
  value       = aws_backup_plan.main.version
}

output "backup_service_role_arn" {
  description = "ARN of the backup service role"
  value       = aws_iam_role.backup_service_role.arn
}

output "backup_service_role_name" {
  description = "Name of the backup service role"
  value       = aws_iam_role.backup_service_role.name
}

output "backup_rds_selection_id" {
  description = "ID of the RDS backup selection"
  value       = aws_backup_selection.rds.id
}

output "backup_ebs_selection_id" {
  description = "ID of the EBS backup selection"
  value       = aws_backup_selection.ebs.id
}

output "backup_s3_selection_id" {
  description = "ID of the S3 backup selection"
  value       = var.backup_s3_enabled ? aws_backup_selection.s3[0].id : null
}

output "backup_notifications_topic_arn" {
  description = "ARN of the backup notifications SNS topic"
  value       = aws_sns_topic.backup_notifications.arn
}

output "backup_notifications_topic_name" {
  description = "Name of the backup notifications SNS topic"
  value       = aws_sns_topic.backup_notifications.name
}

output "backup_events_log_group_name" {
  description = "Name of the backup events log group"
  value       = aws_cloudwatch_log_group.backup_events.name
}

output "backup_events_log_group_arn" {
  description = "ARN of the backup events log group"
  value       = aws_cloudwatch_log_group.backup_events.arn
}

output "backup_job_failed_alarm_arn" {
  description = "ARN of the backup job failed alarm"
  value       = aws_cloudwatch_metric_alarm.backup_job_failed.arn
}

output "backup_configuration_summary" {
  description = "Summary of backup configuration"
  value = {
    vault_name                   = aws_backup_vault.main.name
    plan_name                    = aws_backup_plan.main.name
    daily_backup_schedule        = var.backup_schedule_expression
    weekly_backup_schedule       = var.backup_weekly_schedule_expression
    monthly_backup_schedule      = var.backup_monthly_schedule_expression
    backup_retention_days        = var.backup_delete_after
    weekly_retention_days        = var.backup_weekly_delete_after
    monthly_retention_days       = var.backup_monthly_delete_after
    cold_storage_after_days      = var.backup_cold_storage_after
    encryption_enabled           = var.backup_encryption_enabled
    s3_backup_enabled           = var.backup_s3_enabled
    notification_email_configured = var.backup_notification_email != ""
    compliance_enabled          = var.backup_compliance_enabled
    cross_region_enabled        = var.backup_cross_region_enabled
  }
}

output "backup_schedules" {
  description = "Backup schedules configuration"
  value = {
    daily_schedule   = var.backup_schedule_expression
    weekly_schedule  = var.backup_weekly_schedule_expression
    monthly_schedule = var.backup_monthly_schedule_expression
    timezone         = "Asia/Bahrain (UTC+3)"
    schedule_note    = "All times are in Bahrain local time (2:00 AM)"
  }
}

output "backup_retention_policy" {
  description = "Backup retention policy configuration"
  value = {
    daily_backups = {
      retention_days        = var.backup_delete_after
      cold_storage_after    = var.backup_cold_storage_after
    }
    weekly_backups = {
      retention_days        = var.backup_weekly_delete_after
      cold_storage_after    = var.backup_weekly_cold_storage_after
    }
    monthly_backups = {
      retention_days        = var.backup_monthly_delete_after
      cold_storage_after    = var.backup_monthly_cold_storage_after
    }
  }
}

output "backup_protected_resources" {
  description = "List of resources protected by backup"
  value = {
    rds_database = {
      resource_type = "RDS"
      resource_arn  = aws_db_instance.main.arn
      backup_enabled = true
    }
    ebs_volumes = {
      resource_type = "EBS"
      selection_criteria = "Tag-based selection for Environment=${var.environment}, Project=${var.project_name}, BackupEnabled=true"
      backup_enabled = true
    }
    s3_bucket = {
      resource_type = "S3"
      resource_arn  = aws_s3_bucket.backup.arn
      backup_enabled = var.backup_s3_enabled
    }
  }
}

output "backup_monitoring" {
  description = "Backup monitoring configuration"
  value = {
    sns_topic_arn           = aws_sns_topic.backup_notifications.arn
    cloudwatch_alarm_arn    = aws_cloudwatch_metric_alarm.backup_job_failed.arn
    log_group_name          = aws_cloudwatch_log_group.backup_events.name
    monitored_events        = var.backup_vault_events
    notification_email      = var.backup_notification_email != "" ? "Configured" : "Not configured"
    alarm_threshold         = var.backup_alarm_threshold
  }
}

output "backup_security" {
  description = "Backup security configuration"
  value = {
    vault_encryption_enabled = true
    kms_key_arn             = aws_kms_key.backup_vault.arn
    kms_key_rotation_enabled = true
    vault_access_policy     = "Configured"
    service_role_arn        = aws_iam_role.backup_service_role.arn
    cross_region_replication = var.backup_cross_region_enabled
  }
}

output "backup_cost_optimization" {
  description = "Backup cost optimization settings"
  value = {
    lifecycle_management_enabled = var.backup_lifecycle_enabled
    cold_storage_transition_days = var.backup_cold_storage_after
    backup_deletion_after_days   = var.backup_delete_after
    weekly_long_term_retention   = var.backup_weekly_delete_after
    monthly_compliance_retention = var.backup_monthly_delete_after
    estimated_monthly_cost       = "Varies based on backup size and retention"
  }
} 