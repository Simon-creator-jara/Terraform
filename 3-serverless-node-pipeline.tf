resource "aws_codebuild_project" "tf-plan-serverless2" {
  name        = "cicd-build-serverless-node"
  description = "pipeline for serverless"

  service_role = "arn:aws:iam::697289108405:role/codebuild_role"

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
     buildspec = file("repositorio-de-cicd/3-serverless/buildspec/buildspecnode.yml")
 }
}



resource "aws_codepipeline" "serverless_pipeline2" {
  name     = "cicd-serverless-node"
  role_arn = "arn:aws:iam::697289108405:role/codepipeline_role"

  artifact_store {
    type     = "S3"
    location = "platzi-mis-despliegues-automaticos-con-terraform-simi"
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
        ProjectName = "cicd-build-serverless-node"
      }
    }
  }


  }
