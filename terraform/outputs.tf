output "backend_container_name" {
  description = "Nom du conteneur backend"
  value       = docker_container.backend_app_new.name
}

output "frontend_container_name" {
  description = "Nom du conteneur frontend"
  value       = docker_container.frontend_app_new.name
}

output "backend_port" {
  description = "Port du backend exposé"
  value       = docker_container.backend_app_new.ports[0].external
}

output "frontend_port" {
  description = "Port du frontend exposé"
  value       = docker_container.frontend_app_new.ports[0].external
}
