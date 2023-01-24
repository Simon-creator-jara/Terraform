resource "aws_kms_key" "a" {
  description             = "KMS key 1"
  deletion_window_in_days = 10
}

resource "aws_secretsmanager_secret" "dockerhubconnection" {
  kms_key_id   =aws_kms_key.a.id
  name          = "dockerhub-connection"
  description = "Master password for docker hub"
}

resource "aws_secretsmanager_secret_version" "dockerhubconnection" {
  secret_id = aws_secretsmanager_secret.dockerhubconnection.id
  secret_string = jsonencode({
    Username = ""
    Password = ""
  })
}