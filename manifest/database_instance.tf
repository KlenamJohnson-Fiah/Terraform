resource "aws_db_instance" "fastapi_db"{
    allocated_storage      = 20
    engine                 = "postgres"
    storage_type           = "gp2"
    engine_version         = "12" 
    instance_class         = "db.t2.small"
    name                   = "fastapi_user_article_db"
    username               = var.db_name
    password               = var.db_password
    skip_final_snapshot    = true
    publicly_accessible    = true
    vpc_security_group_ids = ["${aws_security_group.db_security_groups.id}"]
    db_subnet_group_name   = "${aws_db_subnet_group.db-subnet-group.name}"

    tags = {
        Name = "fastapi_user_article_db"
    }
    
}

output "db_instance" {
    value = "${aws_db_instance.fastapi_db.id}"
}

output "db_ip" {
    value = "${aws_db_instance.fastapi_db.address}"
}