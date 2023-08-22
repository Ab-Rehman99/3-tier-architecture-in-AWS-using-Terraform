
# Local variables


locals {
  user_data = <<-EOT
#!/bin/bash
yum update -y
amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
yum install -y httpd
systemctl start httpd
systemctl enable httpd
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;
echo '<?php phpinfo(); ?>' > /var/www/html/phpinfo.php
sudo yum install php-mbstring php-xml -y
sudo systemctl restart httpd
sudo systemctl restart php-fpm
cd /var/www/html
wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz
mkdir phpMyAdmin && tar -xvzf phpMyAdmin-latest-all-languages.tar.gz -C phpMyAdmin --strip-components 1
rm phpMyAdmin-latest-all-languages.tar.gz
echo '<?php phpinfo(); ?>' > /var/www/html/phpinfo.php
cd phpMyAdmin
mv config.sample.inc.php config.inc.php
sed -i 's/localhost/${module.rds.db_instance_address}/g' config.inc.php
  EOT
}


# Supporting Resources


module "asg_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = var.asg_sg_name
  description = var.asg_sg_description
  vpc_id      = module.vpc.vpc_id

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.alb_http_sg.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  egress_rules = ["all-all"]

  tags = var.asg_sg_tags
}


# Autoscaling scaling group (ASG)


module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  # Autoscaling group
  name = var.asg_name

  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  desired_capacity          = var.asg_desired_capacity
  vpc_zone_identifier       = module.vpc.private_subnets
  target_group_arns         = module.alb.target_group_arns
  health_check_type         = var.asg_health_check_type
  user_data                 = base64encode(local.user_data)

  # Launch template
  launch_template_name        = var.asg_launch_template_name
  launch_template_description = var.asg_launch_template_description
  update_default_version      = var.asg_update_default_version

  image_id          = var.asg_image_id
  instance_type     = var.asg_instance_type

  # IAM role & instance profile


  tags = var.asg_tags
}