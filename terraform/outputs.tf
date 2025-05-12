output "backend_container_ip" {
  value = docker_container.backend_app.ip_address
}

output "frontend_container_ip" {
  value = docker_container.frontend_app.ip_address
}
