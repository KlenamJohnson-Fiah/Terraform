resource "aws_route_table" "backend_route_table" {
    vpc_id = "${aws_vpc.vpc.id}"
    
    route  {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.igw.id}"
    } 

    tags = {
      Name = "Route Table for fastapi backend"
    }
}


resource "aws_route_table" "nat_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.natgw.id}"

  }
  depends_on = [
    aws_nat_gateway.natgw
  ]

  tags = {
      Name = "Route Table for NAT backend"
    }
  
}

# resource "aws_route_table" "ansible" {
#   vpc_id = "${aws_vpc.vpc.id}"

#   route {
#     cidr_block = "10.0.2.0/24"
#     instance_id = "${aws_instance.bastion.id}"

#   }
#   depends_on = [
#     aws_instance.bastion
#   ]

#   tags = {
#       Name = "Route Table for Bastion to private subnet"
#     }
  
# }

#+++++++++++++++++++++++++++aws_route_table_association+++++++++++++++++++++++++++++++++++++++
resource "aws_route_table_association" "route_association_backend_subnet" {
    subnet_id      = "${aws_subnet.backend_subnet.id}"
    route_table_id = "${aws_route_table.backend_route_table.id}"
  
}


resource "aws_route_table_association" "route_association_natgw" {
  subnet_id = "${aws_subnet.db.id}"     
  route_table_id = "${aws_route_table.nat_route_table.id}"
}


# resource "aws_route_table_association" "ansible_privatesub" {
#   subnet_id = "${aws_subnet.db.id}"
#   route_table_id = "${aws_route_table.ansible.id}"
  
# }