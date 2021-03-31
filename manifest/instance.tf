resource "aws_instance" "bastion" {
  depends_on = [
    aws_eip.bastion_eip
  ]

  ami                    = "ami-00f9f4069d04c0c6e"
  instance_type          = var.env_instance_type
  subnet_id              = "${aws_subnet.backend_subnet.id}"
  vpc_security_group_ids =["${aws_security_group.only_ssh_bastion.id}"]
  key_name               = "tf_key"

  tags                   ={
      Name ="bastion"
    }
  
  connection{
      agent = false
      type = "ssh"
      bastion_host = self.public_ip
      bastion_user = "ec2-user"
      bastion_private_key = "${file(var.private_key_path)}"
    }
}





resource "aws_instance" "backend_instance" {
    ami                    = "ami-00f9f4069d04c0c6e"
    instance_type          = var.env_instance_type
    subnet_id              = "${aws_subnet.backend_subnet.id}"
    vpc_security_group_ids =["${aws_security_group.backend_security_groups.id}"]
    key_name               = "tf_key"

    tags                   ={
      Name ="backend_instance"
    }

    provisioner "file" {
      source  =  "C:/Users/KJF/Desktop/Personal Projects/Terraform_fastapi/config/fastapi_dependencies.sh"
      destination = "/tmp/fastapi_dependencies.sh"


     connection{
      type = "ssh"
      host = self.public_ip
      user = "ec2-user"
      private_key = "${file(var.private_key_path)}"
    }
  
    }

    

    provisioner "remote-exec" {
      inline = [
        "sed -i -e 's/\r$//' /tmp/fastapi_dependencies.sh",
        "sudo chmod +x /tmp/fastapi_dependencies.sh",
        "/tmp/fastapi_dependencies.sh"
        #"sudo shutdown -r now"

        #moved this command into my shell script to fix an annoying problem 
        #ofUpload failed: wait: remote command exited without exit status or exit signal and
        #Still creating... Stuck
        #This was a real gotcha. Terraform strongly advices againt the use of provisioners. My plan 
        # was to use my anisble node to deploy. But this fixed it like all IT(just power down and backup) issues.
      ]
      on_failure = continue 


      connection{
      type = "ssh"
      host = self.public_ip
      user = "ec2-user"
      private_key = "${file(var.private_key_path)}"
    }  
    
    }
   
  
}

resource "aws_instance" "ansible" {
    depends_on = [
      aws_instance.bastion
    ]

    ami                    = "ami-00f9f4069d04c0c6e"
    instance_type          = var.env_instance_type
    subnet_id              = "${aws_subnet.db.id}"
    vpc_security_group_ids = ["${aws_security_group.db_security_groups.id}"]  #"${aws_security_group.backend_security_groups.id}",
    key_name               = "tf_key"

    tags                   ={
      Name ="ansible"
    }

     provisioner "file" {
      source  =  "C:/Users/KJF/Desktop/Personal Projects/Terraform_fastapi/config/ansible_config.sh"
      destination = "/tmp/ansible_config.sh"



      connection{
        type = "ssh"
        agent = false
        bastion_host = "${aws_instance.bastion.public_ip}"
        bastion_user = "ec2-user"
        bastion_private_key = file(var.private_key_path)

        host = self.private_ip
        user = "ec2-user"
        private_key = file(var.private_key_path)
        
    }

    
    }

    provisioner "remote-exec" {

      inline = [
        "sed -i -e 's/\r$//' /tmp/ansible_config.sh",
        "sudo chmod +x /tmp/ansible_config.sh",
        "/tmp/ansible_config.sh"
        #"sudo shutdown -r now" 
       
        #moved this command into my shell script to fix an annoying problem 
        #ofUpload failed: wait: remote command exited without exit status or exit signal and
        #Still creating... Stuck
        #This was a real gotcha. Terraform strongly advices againt the use of provisioners. My fallback plan 
        #was to use my anisble node to deploy. But this fixed it like all IT(just power down and backup) issues.
               
      ]    
      on_failure = continue

      connection{
          type = "ssh"
        agent = false
        bastion_host = "${aws_instance.bastion.public_ip}"
        bastion_user = "ec2-user"
        bastion_private_key = file(var.private_key_path)

        host = self.private_ip
        user = "ec2-user"
        private_key = file(var.private_key_path)
        
    }

      
    }
}







 output "instance" {
    value       = ["${aws_instance.backend_instance.id}","${aws_instance.ansible.id}","${aws_instance.bastion.id}"]
    description = "aws_instance details"
}

 output "ip" {
    value       = ["${aws_instance.backend_instance.public_ip}","${aws_instance.ansible.public_ip}"]
    description = "aws_instance ip"
}