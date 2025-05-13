output "backend_container_name" {
  description = "Nom du conteneur backend"
  value       = docker_container.backend_app.name
}

output "frontend_container_name" {
  description = "Nom du conteneur frontend"
  value       = docker_container.frontend_app.name
}

output "backend_port" {
  description = "Port du backend exposé"
  value       = docker_container.backend_app.ports[0].external
}

output "frontend_port" {
  description = "Port du frontend exposé"
  value       = docker_container.frontend_app.ports[0].external
}
