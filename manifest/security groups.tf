data "aws_security_group" "bckend_security_groups"{
  id = aws_security_group.backend_security_groups.id
}

data "aws_security_group" "dbs_security_groups"{
  id = aws_security_group.db_security_groups.id
}



resource "aws_security_group" "backend_security_groups" {
    name        = "fastapi_backend"
    description = "Allow connections in and out"
    vpc_id      = aws_vpc.vpc.id

   ingress  {
     from_port   = 8000
     to_port     = 8000
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   } 

   ingress  {
     from_port   = 80
     to_port     = 80
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }

   ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 

    ingress  {
     from_port   = 22
     to_port     = 22
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   } 

  ingress {
    description = "Allows ICMP requests: IPV4" # For ping,communication, error reporting etc, Note necessary because DB does not 
                                               # respond to pings anyway.
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
   } 

   egress  {
     
     from_port   = 0  # allows as call out to anywhere our heart desires
     to_port     = 0
     protocol    = "-1"
     cidr_blocks = [ "0.0.0.0/0" ]
     
   } 

  egress {
    description      = "Allows ICMP requests: IPV4" # For ping,communication, error reporting etc, Note necessary because DB does not 
                                               # respond to pings anyway.
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      /* this is the vpc cidr block */
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress  {
     from_port   = 8000
     to_port     = 8000
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
    }

    egress  {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }  



}


resource "aws_security_group" "db_security_groups" {
    name        = "fastapi_db"
    description = "Allow connections db"
    vpc_id      = aws_vpc.vpc.id
    

    ingress  {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    } 

    ingress  {
     from_port   = 22
     to_port     = 22
     protocol    = "tcp"
     security_groups = [aws_security_group.only_ssh_bastion.id]
     
    } 

    ingress  {
      from_port   = 8000
      to_port     = 8000
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    } 

    ingress  {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    } 

    ingress {
      description = "Allows ICMP requests: IPV4" # For ping,communication, error reporting etc, Note necessary because DB does not 
                                               # respond to pings anyway.
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      cidr_blocks = ["0.0.0.0/0"]
    } 


    egress  {
     
      from_port   = 0  # allows as call out to anywhere our heart desires
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = [ "0.0.0.0/0" ]
     
    } 
     egress {
      description      = "Allows ICMP requests: IPV4" # For ping,communication, error reporting etc, Note necessary because DB does not 
                                               # respond to pings anyway.
      from_port        = -1
      to_port          = -1
      protocol         = "icmp"
      cidr_blocks      = ["0.0.0.0/0"]
    }

    egress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      /* this is the vpc cidr block */
      security_groups = [aws_security_group.only_ssh_bastion.id]
    }

}



resource "aws_security_group" "only_ssh_bastion" {
  depends_on=[aws_subnet.backend_subnet]
  name        = "only_ssh_basiton"
  vpc_id      =  aws_vpc.vpc.id

  tags = {
    Name = "only_ssh_basiton"
  }


ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }





  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description      = "Allows ICMP requests: IPV4" # For ping,communication, error reporting etc, Note necessary because DB does not 
                                               # respond to pings anyway.
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      /* this is the vpc cidr block */
      cidr_blocks = ["0.0.0.0/0"]
    }
    

}



output "vpc_security_groups" {
    value       = ["${aws_security_group.backend_security_groups.id}","${aws_security_group.db_security_groups.id}","${aws_security_group.only_ssh_bastion.id}"]
    description = "VPC SECURITY GROUPS"

}


