resource "helm_release" "argocd" {
  name             = "argocd"
  create_namespace = true
  namespace        = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "7.8.23"

  values = [
    <<-EOT
    server:
      service:
        type: NodePort
    configs:
      secret:
        argocdServerAdminPassword: "${var.argo_password_hash}"
    EOT
  ]

  depends_on = [null_resource.cluster_blocker]
}
