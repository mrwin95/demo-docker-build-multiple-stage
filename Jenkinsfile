pipeline {
    agent any
    tools {
        jdk 'jdk17'
        nodejs 'NodeJS18.20.4'
    }
    environment {
        SCANNER_HOME = tool "sonar-scanner"
        APP_NAME = ""
        RELEASE=""
        DOCKER_USER="mrwin95"
        DOCKER_PASS="Thang@123"
        IMAGE_NAME="${DOCKER_USER}" + "/" + "${APP_NAME}"
        IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
//         JENKINS_API_TOKEN=credentials("JENKINS_API_TOKEN")
    }

    stages {
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
                withSonarQubeEnv('SonarQube-Server'){
                    sh '''${SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Example-Sonarqube-CI \
                    -Dsonar.projectKey=Example-Sonarqube-CI}'''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'SonarQube-Token'
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                sh "npm install"
            }
        }

        stage('trivy fs scan') {
            steps {
                sh "trivy fs . > trivyfs.txt"
            }
        }
    }
}
