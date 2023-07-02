
# data "aws_db_instance" "primary_rds_instance" {
#   db_instance_identifier = "my-rds-instance-identifier"
# }



resource "aws_db_instance" "secondary_rds_instance" {
  for_each = var.secondary_rds_instances

  identifier             = each.value.identifier
  engine                 = each.value.engine
  instance_class         = each.value.instance_class
  allocated_storage      = each.value.allocated_storage
  storage_type           = each.value.storage_type
  username               = each.value.username
  password               = each.value.password
  publicly_accessible    = each.value.publicly_accessible
  multi_az               = false
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group[each.key].name
  replicate_source_db    = aws_db_instance.primary_rds_instance[each.key].id

  tags = {
    Name = "Secondary RDS Instance - ${each.key}"
  }
}


resource "aws_db_subnet_group" "rds_subnet_group" {
  for_each = var.dbsubnet_config

  name       = "rds-subnet-group-${each.key}"
  subnet_ids = [aws_subnet.db_subnet[each.key].id]
}



resource "aws_db_instance" "primary_rds_instance" {
  for_each = var.primary_rds_instances

  instance_class         = each.value.instance_class
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group[each.key].name
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]

  tags = {
    Name = "Primary RDS Instance"
  }
}

