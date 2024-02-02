pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = credentials('dockerhub-credentials-id')
    }

    stages {
        stage('Checkout') {
            steps {
                cleanWs()
                // Checkout your code from the 'main' branch in version control
                git branch: 'main', url: 'https://github.com/Sivaprakash-pk/My-portfolio-website.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image using Dockerfile
                    docker.build("${params.IMAGE_NAME}:${params.IMAGE_TAG}")
                }
            }
        }

        stage('Scan Docker Image with Trivy') {
            steps {
                script {
                    sh "trivy image ${params.IMAGE_NAME}:${params.IMAGE_TAG} --format json -o trivy-results.json"
                }
            }
        }
        stage('Push Docker Image to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials-id', passwordVariable: 'dockerHubpasswd', usernameVariable: 'dockerHubuser')]) {
                    sh "echo \"\$dockerHubpasswd\" | docker login -u \"\$dockerHubuser\" --password-stdin"
                    sh "docker tag ${params.IMAGE_NAME}:${params.IMAGE_TAG} sivaprakash1998/${params.IMAGE_NAME}:${params.IMAGE_TAG}"
                    sh "docker push sivaprakash1998/${params.IMAGE_NAME}:${params.IMAGE_TAG}"
                    sh "docker logout"
                }
            }
        }
        stage('Run the Docker image on EC2') {
            steps {
                script {
                    sh "docker rm -f portfolio"
                    sh "docker run -dit -p 80:80 --name portfolio ${params.IMAGE_NAME}:${params.IMAGE_TAG}"
                }
            }
        }
    }

    post {
        always {
            // Clean up by removing the Docker image locally
            sh "docker rmi -f ${params.IMAGE_NAME}:${params.IMAGE_TAG}"
            sh "docker rmi -f sivaprakash1998/${params.IMAGE_NAME}:${params.IMAGE_TAG}"
        }
    }
}
