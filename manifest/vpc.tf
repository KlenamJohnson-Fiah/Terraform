
data "aws_vpc" "fastapi_vpc"{
    id = aws_vpc.vpc.id
}



resource "aws_vpc" "vpc" {
    cidr_block           = "10.0.0.0/16"
    enable_dns_hostnames = true

    tags = var.env_instance_tags
    
}
    
