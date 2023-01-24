resource "random_password" "master_password" {
  length  = 16
  special = false
}


resource "aws_db_instance" "default" {
  identifier             = var.name_flyaway
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "13.3"
  name                 = var.name_flyaway
  username             = "newuser"
  password             = random_password.master_password.result
  parameter_group_name   = aws_db_parameter_group.education.name
  skip_final_snapshot  = true
  publicly_accessible = true
}

resource "aws_db_parameter_group" "education" {
  name   = "education"
  family = "postgres13"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}


resource "aws_secretsmanager_secret" "newrds" {
  kms_key_id   ="arn:aws:kms:us-east-1:697289108405:key/45fbc80f-af4f-4fc3-b1e9-c7f8efba39b7"
  name          = "credential2-mibdproduccion"
  description = "credential bd"
}

resource "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id     = aws_secretsmanager_secret.newrds.id
  secret_string = <<EOF
{
  "Username": "${aws_db_instance.default.username}",
  "Password": "${random_password.master_password.result}",
  "Engine": "${aws_db_instance.default.engine}",
  "Host": "${aws_db_instance.default.endpoint}",
  "Port": ${aws_db_instance.default.port}
}
EOF
}


