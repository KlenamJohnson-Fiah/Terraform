resource "aws_eip" "backend_instance_eip" {
  instance = "${aws_instance.backend_instance.id}"
  vpc      = true
}


resource "aws_eip" "natgw_eip" {
  vpc      = true
}

resource "aws_eip" "bastion_eip" {
  #instance = "${aws_instance.bastion.id}"
  vpc      = true
}

output "aws_eip" {
  value = ["${aws_eip.backend_instance_eip.id}","${aws_eip.natgw_eip.id}","${aws_eip.bastion_eip.id}"] 
  description = "eip"
}