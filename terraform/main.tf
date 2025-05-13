terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = "npipe:////./pipe/docker_engine" # Utilisé sous Windows avec Docker Desktop
}

variable "docker_user" {
  description = "Nom d'utilisateur Docker Hub"
  type        = string
  default     = "fatou0409"
}

resource "docker_image" "backend_image" {
  name = "${var.docker_user}/profilapp-backend:latest"
  build {
    context = "${path.module}/../Backend-main/odc"
  }
}

resource "docker_image" "frontend_image" {
  name = "${var.docker_user}/profilapp-frontend:latest"
  build {
    context = "${path.module}/../Frontend-main"
  }
}

resource "docker_container" "backend_app" {
  name  = "backend_app"
  image = docker_image.backend_image.name

  ports {
    internal = 8080
    external = 8080
  }

  depends_on = [docker_image.backend_image]
}

resource "docker_container" "frontend_app" {
  name  = "frontend_app"
  image = docker_image.frontend_image.name

  ports {
    internal = 80
    external = 80
  }

  depends_on = [docker_image.frontend_image]
}
