pipeline {
    agent any

    environment {
        DOCKER_USER = 'fatou0409'
        BACKEND_IMAGE = "${DOCKER_USER}/profilapp-backend"
        FRONTEND_IMAGE = "${DOCKER_USER}/profilapp-frontend"
        MIGRATE_IMAGE = "${DOCKER_USER}/profilapp-migrate"
        SONARQUBE_URL = "http://localhost:9000"
        SONARQUBE_TOKEN = credentials('fafa') // Token Jenkins
        PATH = "C:\\Users\\hp\\Desktop\\terraform_1.11.4_windows_amd64;${env.PATH}"
    }

    stages {
        stage('Cloner le dépôt') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/fatou0409/fil_rouge_terraform.git'
            }
        }

        stage('Vérifier Terraform') {
            steps {
                echo 'Vérification de la présence de Terraform...'
                bat 'where terraform'
                bat 'terraform -v'
            }
        }

        stage('Build des images Docker') {
            steps {
                bat 'docker build -t %BACKEND_IMAGE%:latest ./Backend-main/odc'
                bat 'docker build -t %FRONTEND_IMAGE%:latest ./Frontend-main'
                bat 'docker build -t %MIGRATE_IMAGE%:latest ./Backend-main/odc'
            }
        }

        stage('Terraform Init') {
            steps {
                echo "Initialisation de Terraform..."
                dir('terraform') {
                    writeFile file: 'versions.tf', text: '''
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}
'''
                    bat 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                echo "Exécution du plan Terraform..."
                dir('terraform') {
                    bat 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                echo "Application du plan Terraform..."
                dir('terraform') {
                    bat 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage("Analyse SonarQube - Backend") {
            steps {
                dir("Backend-main/odc") {
                    echo "Analyse SonarQube du backend..."
                    withEnv(["SONAR_TOKEN=${SONARQUBE_TOKEN}"]) {
                        bat '''
                            "C:\\Users\\hp\\Desktop\\SonarScanner\\sonar-scanner\\bin\\sonar-scanner.bat" ^
                              -Dsonar.projectKey=backend ^
                              -Dsonar.sources=. ^
                              -Dsonar.host.url=%SONARQUBE_URL% ^
                              -Dsonar.login=%SONAR_TOKEN%
                        '''
                    }
                }
            }
        }

        stage("Analyse SonarQube - Frontend") {
            steps {
                dir("Frontend-main") {
                    echo "Analyse SonarQube du frontend..."
                    withEnv(["SONAR_TOKEN=${SONARQUBE_TOKEN}"]) {
                        bat '''
                            "C:\\Users\\hp\\Desktop\\SonarScanner\\sonar-scanner\\bin\\sonar-scanner.bat" ^
                              -Dsonar.projectKey=frontend ^
                              -Dsonar.sources=. ^
                              -Dsonar.host.url=%SONARQUBE_URL% ^
                              -Dsonar.login=%SONAR_TOKEN%
                        '''
                    }
                }
            }
        }

        stage('Push des images sur Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: 'jenk', url: '']) {
                    bat 'docker push %BACKEND_IMAGE%:latest'
                    bat 'docker push %FRONTEND_IMAGE%:latest'
                    bat 'docker push %MIGRATE_IMAGE%:latest'
                }
            }
        }

        // Suppression manuelle des anciens conteneurs si nécessaire
        stage('Nettoyage des anciens conteneurs (optionnel)') {
            steps {
                bat '''
                    docker rm -f backend_app || exit 0
                    docker rm -f frontend_app || exit 0
                '''
            }
        }

        /*
        stage('Terraform Destroy (optionnel)') {
            steps {
                dir('terraform') {
                    bat 'terraform destroy -auto-approve'
                }
            }
        }
        */
    }
}
