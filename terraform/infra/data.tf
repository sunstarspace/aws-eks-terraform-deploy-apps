data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name

  depends_on = [
    null_resource.cluster_blocker
  ]
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}
