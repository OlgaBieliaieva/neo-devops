output "jenkins_url" {
  value = "http://jenkins.${var.jenkins_namespace}.svc.cluster.local:8080"
}