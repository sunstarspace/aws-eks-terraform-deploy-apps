terraform {
  required_version = "~> 1.11.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.94.1"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.36.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.2.4"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.19.0"
    }
  }

  backend "s3" {
    bucket       = "eks-sunstar-apps-tfstate"
    key          = "tfstate-infra"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true # new way of locking as the dynamodb way is deprecated.
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "terraform"
  default_tags {
    tags = {
      Environment = terraform.workspace
      Project     = var.project
      Contact     = var.contact
      Terraform   = "true"
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}
