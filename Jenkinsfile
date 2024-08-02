pipeline {
    agent any
    tools {
        jdk 'jdk17-jenkins'
        nodejs 'nodejs-jenkins'
        maven 'maven-jenkins'
    }
    environment {
        SCANNER_HOME = tool "sonarqube-scanner-jenkins"
        APP_NAME = "demo-docker-sonar-pipeline"
        RELEASE="1.0.0"
        DOCKER_USER="mrwin95"
        DOCKER_PASS="dockerhub"
        IMAGE_NAME="${DOCKER_USER}" + "/" + "${APP_NAME}"
        IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
        MAVEN_HOME= tool "maven-jenkins"
    }

    stages {
         stage('Build') {
            steps {
                echo "Building"
                sh "mvn clean install -DskipTests"
            }
        }
        stage('Test') {
            steps {
                echo "Testing"
            }
        }

        stage('clean workspace') {
            steps {
                cleanWs()
            }
        }
        stage('checkout from git') {
            steps {
                git branch: 'main', url: 'https://github.com/mrwin95/demo-docker-build-multiple-stage.git'
            }
        }

        stage('Sonarqube Analyses') {
            steps {
                withSonarQubeEnv('sonarqube-server'){
                    sh '''$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=example-ci \
                        -Dsonar.projectKey=example-ci \
                        -Dsonar.sources=.\
                        -Dsonar.language=java \
                        -Dsonar.java.binaries=.'''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonarqube-token'
                }
            }
        }

//         stage('Install Dependencies') {
//             steps {
//                 sh "mvn install"
//             }
//         }

        stage('trivy fs scan') {
            steps {
                sh "trivy fs . > trivyfs.txt"
            }
        }

        stage('Build and Push Docker image') {
            steps {
                script {
                    docker.withRegistry('', DOCKER_PASS){
                        docker_image = docker.build "${}IMAGE_NAME}"
                    }
                    docker.withRegistry('', DOCKER_PASS){
                        docker_image.push("${IMAGE_TAG}")
                        docker_image.push("latest")
                    }
                }
            }
        }
    }
}
