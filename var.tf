
variable "vpc_config" {
  type = map(object({
    region       = string
    cidr_block   = string
    vpc_name     = string
    subnet_count = number
  }))
  default = {
    us-east-1 = {
      region       = "us-east-1"
      cidr_block   = "10.0.0.0/16"
      vpc_name     = "vpc-1"
      subnet_count = 2
    }
    us-west-1 = {
      region       = "us-west-1"
      cidr_block   = "172.128.0.0/16"
      vpc_name     = "vpc-2"
      subnet_count = 2
    }
  }
}

variable "secondary_rds_instances" {
  type = map(object({
    identifier          = string
    replicate_source_db = string
    engine              = string
    instance_class      = string
    allocated_storage   = number
    storage_type        = string
    username            = string
    password            = string
    publicly_accessible = bool
  }))
  default = {}
}

variable "instance_configs" {
  type = map(object({
    ami_id         = string
    instance_type  = string
    subnet_id      = string
    security_group = string
    key_pair       = string
  }))
  default = {
    us-east-1 = {
      ami_id         = "ami-053b0d53c279acc90"
      instance_type  = "t2.medium"
      subnet_id      = "aws_subnet.private_subnet.id"
      security_group = "sg-0a161e81521c14b97"
      key_pair       = "aws_key_pair.hammer.key_name"
    }
  }
}


variable "primary_rds_instances" {
  type = map(object({
    identifier          = string
    replicate_source_db = string
    engine              = string
    engine_version      = string
    instance_class      = string
    allocated_storage   = number
    storage_type        = string
    username            = string
    password            = string
    publicly_accessible = bool
  }))
  default = {
    us-east-1 = {
      identifier          = "my-rds-instance-identifier"
      allocated_storage   = 100
      engine              = "mysql"
      engine_version      = "5.7"
      instance_class      = "db.t2.micro"
      storage_type        = "standard" 
      username            = "admin"
      password            = "mysecretpassword"
      publicly_accessible = false
      replicate_source_db = "source_db_identifier"

    }
    us-west-1 = {
      identifier          = "my-rds-instance-identifier"
      allocated_storage   = 100
      engine              = "mysql"
      engine_version      = "5.7"
      instance_class      = "db.t2.micro"
      storage_type        = "standard"
      username            = "admin"
      password            = "mysecretpassword"
      publicly_accessible = false
      replicate_source_db = "source_db_identifier"

    }
  }
}

variable "security_group_configs" {
  type = map(object({
    description = string
    ingress_rules = object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    })
    egress_rules = object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    })
  }))
  default = {
    "us-east-1" = {
      description = "Allow all http"
      ingress_rules = {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
      egress_rules = {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    },
    "us-west-1" = {
      description = "Allow all http & ssh"
      ingress_rules = {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
      ingress_rules = {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
      egress_rules = {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }
  }
}

variable "dbsubnet_config" {
  type = map(object({
    cidr_block : string
  }))
  default = {
    "us-east-1" = {
      cidr_block = "10.0.7.0/24"
      availability_zones = ["us-east-1a", "us-east-1b"]
    }
    "us-west-1" = {
      cidr_block = "172.128.7.0/24"
      availability_zones = ["us-west-1c","us-west-1d"]

    }
  }
}



