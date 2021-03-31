resource "aws_nat_gateway" "natgw" {
    allocation_id = "${aws_eip.natgw_eip.id}"
    subnet_id     = "${aws_subnet.backend_subnet.id}"
    tags = {
      Name        = "NAT gw"
    }

    depends_on = [
      aws_internet_gateway.igw
    ]
  
}