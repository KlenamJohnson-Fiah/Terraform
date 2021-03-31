variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "region" {
  default = "us-east-1"
}

variable "env_instance_type" {}

variable "env_instance_tags" {
  type = map(string)
}

#variable "ssh_key_name"{}

variable "private_key_path"{
  default = "C:/Users/KJF/Desktop/Personal Projects/tf_key.pem"
}

variable "db_name"{
  default   = "terra_fast"
  #sensitive = true
}


variable "db_password"{
  default  = "terra_fast"
  #sensitive = true
}
