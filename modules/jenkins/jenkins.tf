resource "kubernetes_namespace" "jenkins" {
  metadata { name = var.jenkins_namespace }
}

resource "kubernetes_service_account" "jenkins_agent" {
  metadata {
    name      = "jenkins-agent"
    namespace = var.jenkins_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = var.kaniko_role_arn
    }
  }
}

resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = var.jenkins_chart_version
  namespace  = kubernetes_namespace.jenkins.metadata[0].name
  create_namespace = false

  values = [
    file("${path.module}/values.yaml")
  ]

  depends_on = [kubernetes_service_account.jenkins_agent]
}