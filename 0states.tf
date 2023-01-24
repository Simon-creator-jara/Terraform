terraform{
    backend "s3"{
        bucket="platzi-mi-repo-para-terraform-simi"
        encrypt=true 
        key="terraform.tfstate"
        region="us-east-1"
    }
}

provider "aws"{
    region =""
    access_key=""
    secret_key=""
}