provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "backend_image" {
  name = "${var.docker_user}/profilapp-backend:latest"
  build {
    context = "./Backend-main/odc"
  }
}

resource "docker_image" "frontend_image" {
  name = "${var.docker_user}/profilapp-frontend:latest"
  build {
    context = "./Frontend-main"
  }
}

resource "docker_container" "backend_app" {
  name  = "backend_app"
  image = docker_image.backend_image.latest
  ports {
    internal = 8080
    external = 8080
  }
}

resource "docker_container" "frontend_app" {
  name  = "frontend_app"
  image = docker_image.frontend_image.latest
  ports {
    internal = 80
    external = 80
  }
}
