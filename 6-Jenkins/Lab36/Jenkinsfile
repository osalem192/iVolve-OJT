@Library('iVolve_sharedLiberary') _
pipeline {
    agent any

    environment {
        namespace = "${env.GIT_BRANCH}"
        IMAGE_NAME = "osalem192/jenkins_app_${namespace}"
        IMAGE_TAG = "v${env.BUILD_ID}"
        
    }

    stages {
        stage('Clone Repository') {
            steps {
                cloneRepo(branch: 'main', url: "https://github.com/osalem192/Jenkins_App.git")
            }
        }
        
        stage('Run Unit Tests') {
            steps {
                runUnitTests()
            }
        }

        stage('Build App') {
            steps {
                buildApp()
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                buildAndPushDockerImage(credentials: "docker_credentials", imageName: "${IMAGE_NAME}", imageTag: "${IMAGE_TAG}")
            }
        }

        stage('Delete Local Docker Image') {
            steps {
                deleteLocalDockerImage(imageName: "${IMAGE_NAME}", imageTag: "${IMAGE_TAG}")
            }
        }

        stage('Update Deployment YAML') {
            steps {
                updateDeploymentYaml(imageName: "${IMAGE_NAME}", imageTag: "${IMAGE_TAG}")
            }
        }


        stage('Deploy to Kubernetes') {
            steps {
                // Call shared library method
                deployToKubernetes("kubeconfig", namespace)
            }
        }
    }
}
