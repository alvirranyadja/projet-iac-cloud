output "jenkins_public_ip" {
  value = module.eip.public_ip
}

output "jenkins_url" {
  value = "http://${module.eip.public_ip}:8080"
}

output "private_key_path" {
  value     = module.keypair.private_key_path
  sensitive = true
}
