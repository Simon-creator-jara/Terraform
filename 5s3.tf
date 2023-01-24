resource "aws_s3_bucket" "codepipeline_artifacts" {
  bucket = "platzi-mis-despliegues-automaticos-con-terraform-simi"
} 
resource "aws_s3_bucket" "terraformstate" {
  bucket = "platzi-terraform-state-simi"
} 