# Generic variables
region = "ap-south-1"

# VPC variables
vpc_name             = "abdul-vpc"
vpc_cidr             = "10.0.0.0/16"
vpc_azs              = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
vpc_public_subnets   = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
vpc_private_subnets  = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
vpc_database_subnets = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]
vpc_tags             = { "created-by" = "terraform" }

# ASG variables
asg_sg_name                             = "abdul-asg-sg"
asg_sg_description                      = "abdul-asg-sg"
asg_sg_tags                             = { "Name" = "abdul-asg-sg", "created-by" = "terraform" }
asg_name                                = "abdul-asg"
asg_min_size                            = 1
asg_max_size                            = 2
asg_desired_capacity                    = 1
asg_health_check_type                   = "EC2"
asg_launch_template_name                = "abdul-lt"
asg_launch_template_description         = "abdul-lt"
asg_update_default_version              = true
asg_image_id                            = "ami-0da59f1af71ea4ad2"
asg_instance_type                       = "t2.micro"
asg_tags                                = { "Name" = "abdul-asg", "created-by" = "terraform" }


# ALB variables
alb_sg_name                    = "abdul-alb-sg"
alb_sg_ingress_cidr_blocks     = ["0.0.0.0/0"]
alb_sg_description             = "abdul-alb-sg"
alb_sg_tags                    = { "Name" = "abdul-alb-sg", "created-by" = "terraform" }
alb_name                       = "abdul-alb"
alb_http_tcp_listeners_port    = 80
alb_target_group_name          = "abdul-alb-tg"
alb_target_groups_backend_port = 80
alb_tags                       = { "Name" = "abdul-alb", "created-by" = "terraform" }

# RDS variables
rds_sg_name                               = "abdul-rds-sg"
rds_sg_description                        = "abdul-rds-sg"
rds_sg_tags                               = { "Name" = "abdul-rds-sg", "created-by" = "terraform" }
rds_identifier                            = "abdul-rds"
rds_mysql_engine                          = "mysql"
rds_engine_version                        = "8.0.33"
rds_family                                = "mysql8.0" # DB parameter group
rds_major_engine_version                  = "8.0"      # DB option group
rds_instance_class                        = "db.t2.small"
rds_allocated_storage                     = 20
rds_max_allocated_storage                 = 100
rds_db_name                               = "abdul_mysql_db"
rds_username                              = "abdul_user"
rds_port                                  = 3306
rds_multi_az                              = false
rds_maintenance_window                    = "Mon:00:00-Mon:03:00"
rds_backup_window                         = "03:00-06:00"
rds_enabled_cloudwatch_logs_exports       = ["general"]
rds_create_cloudwatch_log_group           = true
rds_backup_retention_period               = 0
rds_skip_final_snapshot                   = true
rds_deletion_protection                   = false
rds_performance_insights_enabled          = false
rds_performance_insights_retention_period = 7
rds_create_monitoring_role                = true
rds_monitoring_interval                   = 60
rds_tags                                  = { "Name" = "abdul-rds", "created-by" = "terraform" }
rds_db_instance_tags                      = { "Name" = "abdul-rds-instance", "created-by" = "terraform" }
rds_db_option_group_tags                  = { "Name" = "abdul-rds-option-group", "created-by" = "terraform" }
rds_db_parameter_group_tags               = { "Name" = "abdul-rds-db-parameter-group", "created-by" = "terraform" }
rds_db_subnet_group_tags                  = { "Name" = "abdul-rds-db-subnet-group", "created-by" = "terraform" }