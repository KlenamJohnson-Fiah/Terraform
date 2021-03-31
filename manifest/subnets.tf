data "aws_subnet" "bckend_subnets"{
    id = aws_subnet.backend_subnet.id
}

data "aws_subnet" "dbs_subnets"{
    id = aws_subnet.db.id
}


resource "aws_subnet" "backend_subnet" {
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone       = "us-west-2a"
    tags                    = var.env_instance_tags
    
        
    
  
}

resource "aws_subnet" "db" {
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = "10.0.2.0/24"
    map_public_ip_on_launch = false
    availability_zone       = "us-west-2b"
    tags                    = var.env_instance_tags   
  
}

resource "aws_db_subnet_group" "db-subnet-group"{
    name       = "db subnet group"
    subnet_ids = ["${aws_subnet.backend_subnet.id}","${aws_subnet.db.id}"]
}

output "subnets" {
    value       = ["${aws_subnet.backend_subnet.id}","${aws_subnet.db.id}"]
    description = "subnets"
}



