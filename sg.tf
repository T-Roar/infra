resource "aws_security_group" "rds_security_group" {
  name        = "rds-security-group"
  description = "Security group for RDS instance"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "ec2_security_group" {
  for_each = var.security_group_configs

  name        = "ec2-security-group-${each.key}"
  description = each.value.description
  vpc_id      = aws_vpc.vpc[each.key].id

  ingress {
    from_port   = each.value.ingress_rules.from_port
    to_port     = each.value.ingress_rules.to_port
    protocol    = each.value.ingress_rules.protocol
    cidr_blocks = each.value.ingress_rules.cidr_blocks
  }

  egress {
    from_port   = each.value.egress_rules.from_port
    to_port     = each.value.egress_rules.to_port
    protocol    = each.value.egress_rules.protocol
    cidr_blocks = each.value.egress_rules.cidr_blocks
  }

  tags = {
    Name = "EC2 Security Group - ${each.key}"
  }
}


