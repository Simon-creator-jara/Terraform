resource "aws_codebuild_project" "tf-plan-serverless2" {
  name        = "cicd-build-${var.name_serverless_node}"
  description = "pipeline for serverless"

  service_role = var.codebuild_role

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }
   source {
     type   = "CODEPIPELINE"
     buildspec = file("3-serverless/buildspec/buildspecnode.yml")
 }
}



resource "aws_codepipeline" "serverless_pipeline2" {
  name     = "cicd-${var.name_serverless_node}"
  role_arn = var.codepipeline_role

  artifact_store {
    type     = "S3"
    location = var.s3_terraform_pipeline
  }

  stage {

    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["code"]
      configuration = {
        RepositoryName       = "repositorio-de-cicd"
        BranchName           = "master"
        OutputArtifactFormat = "CODE_ZIP"
      }
  }
  }

  stage {
    name = "Plan"
    action {
      name            = "Build"
      category        = "Build"
      provider        = "CodeBuild"
      version         = "1"
      owner           = "AWS"
      input_artifacts = ["code"]
      configuration = {
        ProjectName = "cicd-build-${var.name_serverless_node}"
      }
    }
  }


  }
